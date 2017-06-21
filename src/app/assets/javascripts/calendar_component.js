var createDynamicCalendar = function (calendarElement, businesses, customerID, externalEventsElement, externalEventsUrl, externalEventsOptions) {

    this._calendarElement = $(calendarElement);
    this._externalEventsUrl = externalEventsUrl;
    this._externalEventsOptions = externalEventsOptions;

    this._businesses = businesses;
    this._customerID = customerID;

    this.handleError = function (err) {
        UIkit.modal.alert(JSON.stringify(err));
    }

    this.initialize = function () {
        var _this = this;

        if (this._externalEventsUrl) {
            $.getJSON(this._externalEventsUrl, this._loadExternalEventsOptions)
                .done(_this.renderExternalEvents).fail(_this._handleError);
        }

        for (var b in this._businesses) {
            $.getJSON('/business_service_time_slots', {
                "business_id": this._businesses[b]
            })
                .done(
                    function (data) {
                        for (var d in data) {
                            switch (data[d].state) {
                                case 0:
                                    data[d].color = '#526F35';
                                    break;
                                case 1:
                                    data[d].color = '#BD2F3A';
                                    break;
                                case 2:
                                    data[d].color = '#1d3557';
                                    break;
                            }
                        }
                        _this.renderCalendar(data);
                    })
                .fail(
                    function (err) {
                        _this.handleError(err);
                    });
        }
    }

    this.removeSlotById = function (id) {
        var event = this._calendarElement.fullCalendar('clientEvents', [id])[0];
        if (!confirm(event.title + " on Start: " + event.start.format() + ", End: " + event.end.format() + " is being removed.\n\nAre you sure about this change?")) {
            return;
        }
        var _this = this;
        $.ajax({
            type: "DELETE",
            url: '/business_service_time_slot',
            data: {
                "time_slot": {
                    "id": id
                }
            },
            dataType: "json"
        }).done(function () {
            _this._calendarElement.fullCalendar('removeEvents', [id]);
            _this._calendarElement.fullCalendar('refresh');
        }).fail(function (err) {
            var errEvent = _this._calendarElement.fullCalendar('clientEvents', [id])[0];
            if (errEvent)
                UIkit.modal.alert("Error saving event: " + JSON.stringify(err));
        });
    }

    /* initialize the external events
     -----------------------------------------------------------------*/
    this.renderExternalEvents = function (data) {
        if (!data) {
            document.getElementById("external-events").innerHTML = "";
            document.getElementById("calendar").innerHTML = "";
            return;
        }
        var parentElement = document.getElementById('external-events');
        var businessesIds = [];
        var businessCounter = 0;
        var events = [];
        for (var d in data) {
            var divEl = document.createElement("LI");
            divEl.className = "fc-event";
            divEl.setAttribute("value", data[d].id);
            divEl.innerText = data[d].service_label;

            $(divEl).data('event', {
                title: data[d].service_label, // use the element's text as the event title
                stick: true, // maintain when user navigates (see docs on the renderEvent method)
                business_service_id: data[d].id,
                business_id: data[d].business_id
            });

            if (businessesIds.indexOf(data[d].business_id) === -1)
                businessesIds.push(data[d].business_id)

            // make the event draggable using jQuery UI
            $(divEl).draggable({
                zIndex: 999,
                revert: true,      // will cause the event to go back to its
                revertDuration: 0  //  original position after the drag
            });

            parentElement.appendChild(divEl);
        }

        for (var b in businessesIds) {
            $.ajax({
                type: "GET",
                url: '/business_service_time_slots',
                data: {
                    "business_id": businessesIds[b]
                },
                dataType: "json"
            }).done(function (data) {
                businessCounter++;
                events = events.concat(data);
                if (businessCounter === businessesIds.length)
                    initializeCalendar(events);
            }).fail(function (err) {
                UIkit.modal.alert("Error saving event: " + JSON.stringify(err));
            });
        }
    }

    /* initialize the calendar
     -----------------------------------------------------------------*/
    this.renderCalendar = function (ev) {
        var _this = this;
        var params = {
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'agendaWeek,agendaDay'
            },
            events: ev,
            defaultView: 'agendaWeek',
            allDayDefault: false,
            defaultTimedEventDuration: moment.duration(1, 'hours'),
            forceEventDuration: true,
            eventClick: function (event, jsEvent, view) {
                if (!confirm(event.title + ", Start: " + event.start.format() + ", End: " + event.end.format() + ".\n\nDo you really want to book it?"))
                    return
                $.ajax({
                    type: "PUT",
                    url: '/make_time_slot_reservation',
                    data: {
                        "time_slot": {
                            "id": event.id,
                            "customer_id": this._customerID
                        }
                    },
                    dataType: "json"
                }).done(function (data) {
                    event.id = data["id"];
                    event._id = data["id"];
                    switch (data["state"]) {
                        case 0:
                            event.color = '#526F35';
                            break;
                        case 1:
                            event.color = '#BD2F3A';
                            break;
                        case 2:
                            event.color = '#1d3557';
                            break;
                    }
                    _this._calendarElement.fullCalendar('updateEvent', event);
                }).fail(function (err) {
                    UIkit.modal.alert("Error saving event: " + JSON.stringify(err));
                });
            }
        };

        if (this._externalEventsUrl) {
            params["editable"] = true;
            params["droppable"] = true; // this allows things to be dropped onto the calendar
            params["drop"] = function (event) {
                event.business_service_id = this.value;
            };
            params["eventDrop"] = function (event, delta, revertFunc) {
                if (!confirm(event.title + " was dropped on Start: " + event.start.format() + " End: " + event.end.format() + ".\n\nAre you sure about this change?")) {
                    revertFunc();
                } else {
                    $.ajax({
                        type: "PUT",
                        url: '/business_service_time_slot',
                        data: {
                            "time_slot": {
                                "id": event.id,
                                "datetime_from": event.start.format(),
                                "datetime_to": event.end.format()
                            }
                        },
                        dataType: "json"
                    }).fail(function (err) {
                        UIkit.modal.alert("Error saving event: " + JSON.stringify(err));
                        revertFunc();
                    });
                }
            };
            params["eventResize"] = function (event, delta, revertFunc) {
                if (!confirm(event.title + " was resized to Start: " + event.start.format() + " End: " + event.end.format() + ".\n\nAre you sure about this change?")) {
                    revertFunc();
                } else {
                    $.ajax({
                        type: "PUT",
                        url: '/business_service_time_slot',
                        data: {
                            "time_slot": {
                                "id": event.id,
                                "datetime_from": event.start.format(),
                                "datetime_to": event.end.format()
                            }
                        },
                        dataType: "json"
                    }).fail(function (err) {
                        UIkit.modal.alert("Error saving event: " + JSON.stringify(err));
                        revertFunc();
                    });
                }
            };
            params["eventReceive"] = function (event) {
                $.ajax({
                    type: "POST",
                    url: '/business_service_time_slot',
                    data: {
                        "time_slot": {
                            "business_service_id": event["business_service_id"],
                            "datetime_from": event.start.format(),
                            "datetime_to": event.end.format()
                        }
                    },
                    dataType: "json"
                }).done(function (data) {
                    event.id = data["id"];
                    event._id = data["id"];
                    switch (data["state"]) {
                        case 0:
                            event.color = '#526F35';
                            break;
                        case 1:
                            event.color = '#BD2F3A';
                            break;
                        case 2:
                            event.color = '#1d3557';
                            break;
                    }
                    _this._calendarElement.fullCalendar('updateEvent', event);
                }).fail(function (err) {
                    UIkit.modal.alert("Error saving event: " + JSON.stringify(err));
                });
            };
            params["eventRender"] = function (event, eventElement) {
                eventElement.find("div.fc-title").addClass("uk-float-left");
                eventElement.find("div.fc-content").append("<i onclick='removeTimeSlotById(" + event.id + ")' class='uk-icon-close uk-float-right'></i>");
            };
        }
        this._calendarElement.fullCalendar(params);
    }
}