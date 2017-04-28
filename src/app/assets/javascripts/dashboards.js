var createDynamicTable = function (offset, count, url, section_to_append, loading_image, queryElement) {
    var originalClassName = section_to_append.className;
    var _this = this;
    var searchQuery = '';

    this.executeQuery = function () {
        section_to_append.innerHTML = loading_image;
        section_to_append.className = originalClassName + " col-md-offset-5";
        var _this = this;
        $.getJSON(url, {
            query: searchQuery,
            offset: offset,
            count: count
        }, function (data) {
            _this.insertDataToTable(data);
        }, "json").error(_this.errorHandler);
    };

    if(queryElement){
        var queryTimeout = null;
        queryElement.oninput = function () {
            clearTimeout(queryTimeout);
            queryTimeout = setTimeout(function(){
                searchQuery = queryElement.value;
                _this.executeQuery();
            }, 500);
        };
    }

    this.insertDataToTable = function (data) {
        section_to_append.innerHTML = "";
        section_to_append.className = " col-md-offset-0";
        var table = document.createElement("table");
        table.className = "table panel panel-default";

        var table_head = document.createElement("thead");
        table_head.className = "panel-heading";
        var head_row = document.createElement("tr");

        for (var type in data["columns"]) {
            var head_cell = document.createElement("td");
            head_cell.innerText = data["columns"][type];
            head_row.appendChild(head_cell);
        }
        table_head.appendChild(head_row);
        table.appendChild(table_head);

        var table_body = document.createElement("tbody");
        table_body.className = "panel-body";

        for (var element in data["items"]) {
            var body_row = document.createElement('tr');
            for (var information in data["items"][element]) {
                var body_cell = document.createElement('td');
                if (information.match('link') || information.match('url')) {
                    body_cell.innerHTML = "<a href=" + data['items'][element][information][0] + " class='btn btn-default'>" + data['items'][element][information][1] + "</a>"
                } else {
                    body_cell.innerText = data["items"][element][information];
                }
                body_row.appendChild(body_cell);
            }
            table_body.appendChild(body_row);
        }
        table.appendChild(table_body);
        section_to_append.appendChild(table);
        if (offset !== 0) {
            var prev_orders_btn = document.createElement("button");
            prev_orders_btn.innerText = "Previous page";
            prev_orders_btn.className = "btn btn-primary col-md-4";
            prev_orders_btn.onclick = function () {
                _this.loadPreviousPage();
            };
            section_to_append.appendChild(prev_orders_btn);
        }
        if (data["count"][0]["count"] > (offset + count)) {
            var next_orders_btn = document.createElement("button");
            next_orders_btn.innerText = "Next page";
            next_orders_btn.className = "btn btn-primary col-md-4 col-md-offset-4";
            next_orders_btn.onclick = function () {
                _this.loadNextPage();
            };
            section_to_append.appendChild(next_orders_btn);
        }
    };

    this.loadNextPage = function () {
        offset = offset + count;
        this.executeQuery();
    };

    this.loadPreviousPage = function () {
        var oldOffset = offset;
        offset = offset - count;
        if (offset < 0)
            offset = 0;
        if (offset !== oldOffset)
            this.executeQuery();
    };

    this.errorHandler = function (e) {
        console.log("ERROR: " + e);
        section_to_append.innerHTML = JSON.stringify(e);
    };

    return this;
};