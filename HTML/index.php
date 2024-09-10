<!DOCTYPE html>
<?php
    $rn = "\r\n";

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
            <table>
                <tr>
                    <th>Datum</th>
                    <th>Wochentag</th>
                    <th>Blöcke</th>
                    <th>IST</th>
                    <th>SOLL</th>
                    <th>Differenz</th>
                </tr>
<?php
    $results = $db->query('SELECT * FROM v_TrackedHours ORDER BY date DESC');
    while ($row = $results->fetchArray()) {
        # print PHP object to browser's console
        echo '<script>';
        echo 'var row = ' . json_encode($row) . ';';
        echo 'console.log(row);';
        echo '</script>';


        echo "\t\t\t\t<tr>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['date'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['dayOfWeek'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['blocks'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['trackedHoursPerDay'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['plannedHours'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . 'DIFF' . "</td>" . $rn;
        echo "\t\t\t\t</tr>" . $rn;
    }
?>
            </table>
        </div>
    </body>
</html>