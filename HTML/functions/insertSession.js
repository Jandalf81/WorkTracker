function insertSession(fromDateTime, toDateTime, site, workType, createdAt) {
    if (fromDateTime == "") {
        $('#result').html("❌ Please enter startedAt");
        return;
    }
    if (toDateTime == "") {
        $('#result').html("❌ Please enter stoppedAt");
        return;
    }

    $.ajax({
        type: "POST",
        url: "functions/insertSession.php",
        dataType: "json",
        data: {fromDateTime: DatetimeToString(fromDateTime), toDateTime: DatetimeToString(toDateTime), site:site, workType: workType, createdAt: createdAt},
        success: function(obj, textstatus) {
            console.log(obj);
            $('#result').html("✅");
            getLatestSessionsGroupedByDay(30);
        },
        error: function(obj, textstatus) {
            console.log(obj);
            $('#result').html("❌");
        },
    });
}