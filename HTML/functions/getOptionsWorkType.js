function getOptionsWorkType() {
    $(document).ready(function() { /// Wait till page is loaded
        console.log("TEST");
        // call PHP function with parameter
        $.ajax({
            type: "POST",
            url: "functions/getOptionsWorkType.php",
            dataType: "json",
            data: {},
            success: function (obj, textstatus) {
                console.log(obj);
                if (obj.result == "OK") {
                    $('#optionsWorkType').html(obj.data);
                } else {
                    $('#optionsWorkType').html("Fehler beim Laden der Daten");
                }
            },
            error: function (obj, textstatus) {
                console.log("Fehler");
            }
        });
    });
}