var displayLatestOrders = function () {
    $.getJSON('/latest_businesses_orders', {
        data: 'Some data',
        another_data: 'some another data'
    }, function (e) {
        console.log(e);
    }, "json").error(errorHandler);
}

var errorHandler = function(e){
    console.log("ERROR: " + e);
}