<?php
    date_default_timezone_set("Europe/Berlin");

    $rn = "\r\n";

    # define path to database
    $db = new SQLite3('/home/pi/WorkTracker/WorkTracker.sqlite', SQLITE3_OPEN_READWRITE);

    $db->enableExceptions(true);
?>