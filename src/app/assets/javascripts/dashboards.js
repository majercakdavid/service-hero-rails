var table = document.getElementById("latest-orders-table");
var offset = 0;
var count = 5;

var initialize_business_owner_dashboard = function (ioffset, icount) {
    table = document.getElementById("latest-orders-table");
    offset = ioffset;
    count = icount;
    executeQuery();
}

var executeQuery = function () {
    $.getJSON('/latest_businesses_orders', {
        offset: offset,
        count: count
    }, function (e) {
        console.log(e);
        insertDataToTable(e, table);
    }, "json").error(errorHandler);
};

var insertDataToTable = function (data, table) {
    table.innerHTML = "";
    for (var element in data) {
        var row = document.createElement('tr')
        for (var information in data[element]) {
            var cell = document.createElement('td');
            cell.innerText = data[element][information];
            row.appendChild(cell);
        }
        table.appendChild(row);
    }
}

var loadNextPage = function () {
    offset = offset + count;
    executeQuery();
}

var loadPreviousPage = function () {
    var oldOffset = offset;
    offset = offset - count;
    if (offset < 0)
        offset = 0;
    if(offset != oldOffset)
        executeQuery();
}

var errorHandler = function (e) {
    console.log("ERROR: " + e);
}