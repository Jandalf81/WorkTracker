function insertTrackedHours(fromDate, fromTime, toDate, toTime, site, workType, ) {
    $(document).ready(function() { /// Wait till page is loaded
        // call PHP file with parameters, put return value into DIV
        $('#modalDialogText').load('insertTrackedHours.php', {fromDate: fromDate, fromTime: fromTime, toDate: toDate, toTime: toTime, site: site, workType: workType});

        const dialog = document.querySelector("dialog");
        dialog.showModal();
    });
}