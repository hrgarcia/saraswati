$(document).ready(function () {
    // Code for the Validator
    var $validator = $("#learningsExcelForm form").validate({
        rules: {
            typeOFile: {
                required: true,
            },
            trimester: {
                required: true,
            },
            learning: {
                required: true,
            },
        },
    });
});
