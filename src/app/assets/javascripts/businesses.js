var createDynamicStatistics = function (url, id, section_to_append, loading_image) {
    var originalClassName = section_to_append.className;
    var _this = this;

    this.executeQuery = function () {
        section_to_append.innerHTML = loading_image;
        section_to_append.className = originalClassName + " col-md-offset-5";
        var _this = this;
        $.getJSON(url, {
            id: id
        }, function (data) {
            _this.printData(data);
        }, "json").error(_this.errorHandler);
    };


    this.printData = function (data) {
        section_to_append.innerHTML = "";
        section_to_append.className = originalClassName;

        var title = document.createElement("h2");
        var strongTitle = document.createElement("strong");
        strongTitle.innerText = "Business Statistics";
        title.appendChild(strongTitle);
        section_to_append.appendChild(title);

        for (var key in data) {
            var item = document.createElement("p");
            var strongKey = document.createElement("strong");
            strongKey.innerText = key + ": ";
            var value = document.createElement('span');
            if(data[key])
                value.innerText = data[key];
            else
                value.innerText = "----";
            item.appendChild(strongKey);
            item.appendChild(value);
            section_to_append.appendChild(item);
        }
    };

    this.errorHandler = function (e) {
        console.log("ERROR: " + e);
        section_to_append.innerHTML = JSON.stringify(e);
    };

    return this;
};