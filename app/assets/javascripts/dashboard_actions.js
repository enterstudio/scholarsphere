$(document).ready(function() {
    // toggle button on or off based on boxes being clicked
    $(".batch_document_selector").bind('click', function(e) {
        var n = $(".batch_document_selector:checked").length;
        if (n>0) {
            $('.sort-toggle').hide();
        } else {
            $('.sort-toggle').show();
        }

    });
});