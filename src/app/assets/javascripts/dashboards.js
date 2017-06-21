function merge_options(obj1, obj2) {
    var obj3 = {};
    for (var attrname in obj1) {
        obj3[attrname] = obj1[attrname];
    }
    for (var attrname in obj2) {
        obj3[attrname] = obj2[attrname];
    }
    return obj3;
}

var createDynamicTable = function (offset, count, url, section_to_append, loading_image, options, titleText, doNotChangeStyleClass, createSearch, createPath, createText) {
    var originalClassName = section_to_append.className;
    var _this = this;
    var searchQuery = null;
    var queryTimeouts = [];

    var tableBody = null;
    var prevButton = null;
    var nextButton = null;

    var opts = null;
    var columnsMetadata = null;

    this.executeQuery = function () {
        var _this = this;
        if(tableBody){
            tableBody.innerHTML = loading_image
        } else {
            section_to_append.innerHTML = loading_image;
            if (!doNotChangeStyleClass)
                section_to_append.className = originalClassName + "";
        }

        opts = {
            query: searchQuery,
            offset: offset,
            count: count
        };

        if (options) {
            opts = merge_options(opts, options);
        }

        $.getJSON(url, opts)
            .done(function (data) {
                if (tableBody)
                    _this.loadItemsIntoTable(data);
                else
                    _this.insertDataToTable(data);
            })
            .fail(_this.errorHandler);
    };

    this.insertDataToTable = function (data) {
        section_to_append.innerHTML = "";
        if (!doNotChangeStyleClass)
            section_to_append.className = "";

        if (titleText) {
            var title = document.createElement("h2");
            var strongTitle = document.createElement("strong");
            strongTitle.innerText = titleText;
            title.appendChild(strongTitle);
            section_to_append.appendChild(title);
        }

        if(createPath && createText){
            var link = document.createElement("a");
            link.innerText = createText;
            link.setAttribute("href", createPath);
            section_to_append.appendChild(link);
        }

        var table = document.createElement("table");
        //table.className = "uk-table"
        table.className = "uk-table uk-table-stripped uk-container";

        var table_head = document.createElement("thead");
        table_head.className = "panel-heading";
        var head_row = document.createElement("tr");

        columnsMetadata = data["columns"];
        for (var type in data["columns"]) {
            var head_cell = document.createElement("th");
            if (createSearch && data["columns"][type]["queriable"]) {
                var form_encap = document.createElement("div");
                form_encap.className = "uk-form";
                var input_field = document.createElement("input");
                input_field.setAttribute("type", "text");
                input_field.setAttribute("placeholder", data["columns"][type]["label"] + '...');
                input_field.setAttribute("name", type);

                // Ensure ID uniqueness
                var rand_id = data["columns"][type]["label"] + "_" + type + "_" + "_" + Math.round(Math.random() * 1000);
                while (document.getElementById(rand_id))
                    rand_id = data["columns"][type]["label"] + "_" + type + "_" + "_" + Math.round(Math.random() * 1000);

                input_field.setAttribute("id", rand_id);
                queryTimeouts[rand_id] = null;
                var self = this;
                input_field.oninput = function () {
                    var _this = this;
                    clearTimeout(queryTimeouts[this.getAttribute("id")]);
                    queryTimeouts[this.getAttribute("id")] = setTimeout(function () {
                        //var name = _this.getAttribute("id").substr(0, _this.getAttribute("id").indexOf('_'));
                        if (!searchQuery)
                            searchQuery = {};
                        searchQuery[_this.getAttribute("name")] = _this.value;
                        self.executeQuery();
                    }, 500);
                };

                form_encap.appendChild(input_field);
                head_cell.appendChild(form_encap);
            }
            var column_text_heading = document.createElement("span");
            var column_name_strong = document.createElement("strong");
            column_name_strong.innerText = data["columns"][type]["label"];
            column_text_heading.appendChild(column_name_strong);
            head_cell.appendChild(column_text_heading);
            head_row.appendChild(head_cell);
        }
        table_head.appendChild(head_row);
        table.appendChild(table_head);

        var table_body = document.createElement("tbody");
        table_body.className = "uk-table-body";
        tableBody = table_body;
        table.appendChild(table_body);
        section_to_append.appendChild(table);

        var prev_orders_btn = document.createElement("button");
        prev_orders_btn.innerText = "Previous page";
        prev_orders_btn.className = "uk-float-left uk-button uk-form-width-small";
        //prev_orders_btn.style.opacity = 0;
        prev_orders_btn.disabled = true;

        var next_orders_btn = document.createElement("button");
        next_orders_btn.innerText = "Next page";
        next_orders_btn.className = "uk-float-left uk-button uk-form-width-small";
        //next_orders_btn.style.opacity = 0;
        next_orders_btn.disabled = true;

        prev_orders_btn.style.opacity = 1;
        prev_orders_btn.disabled = true;
        prev_orders_btn.onclick = function () {
            _this.loadPreviousPage();
        };

        next_orders_btn.style.opacity = 1;
        next_orders_btn.disabled = true;
        next_orders_btn.onclick = function () {
            _this.loadNextPage();
        };

        var btn_wrapper = document.createElement("div");
        btn_wrapper.className = "uk-flex uk-flex-item-1 uk-flex-space-between";

        btn_wrapper.appendChild(prev_orders_btn);
        btn_wrapper.appendChild(next_orders_btn);
        section_to_append.appendChild(btn_wrapper);

        prevButton = prev_orders_btn;
        nextButton = next_orders_btn;

        this.loadItemsIntoTable(data);
    };

    this.loadItemsIntoTable = function (data) {
        tableBody.innerHTML = "";
        for (var element in data["items"]) {
            var body_row = document.createElement('tr');
            for(var column in columnsMetadata){
                var body_cell = document.createElement('td');
                if (column.match('link') || column.match('url')) {
                    body_cell.innerHTML = "<a href=" + data['items'][element][column][0] + " class='btn btn-default'>" + data['items'][element][column][1] + "</a>"
                } else {
                    body_cell.innerText = data["items"][element][column];
                }
                body_row.appendChild(body_cell);
            }
            tableBody.appendChild(body_row);
        }
        this.updateButtonAppearance(data);
    }

    this.updateButtonAppearance = function (data) {
        if (offset !== 0)
            prevButton.disabled = false;
        else
            prevButton.disabled = true;
        if (data["count"] > (offset + count))
            nextButton.disabled = false;
        else
            nextButton.disabled = true;
        if (prevButton.disabled && nextButton.disabled) {
            prevButton.style.opacity = 0;
            nextButton.style.opacity = 0;
        }
    }

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

var createDynamicSearchTable = function () {
    "use strict";

}