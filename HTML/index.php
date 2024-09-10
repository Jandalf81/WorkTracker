<!DOCTYPE html>
<?php
    # define path to database
    $db = new SQLite3('/home/pi/TimeTracker/db.sqlite');
?>
<html lang="de">
    <head charset="utf-8">
        <title>TimeTracker</title>
        <link rel="stylesheet" href="generic.css">
    </head>
    <body>
        <div>
            <h1>Aktuelle Zeiterfassung</h1>
        </div>
        <div>
            <h1>Zeiterfassungen der letzten 30 Tage</h1>
        </div>
    </body>
</html>