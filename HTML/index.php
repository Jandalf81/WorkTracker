<!DOCTYPE html>
<?php
    require_once('_defaults.php');
?>
<html lang="de">
    <head charset="utf-8">
        <title>WorkTracker</title>
        <link rel="stylesheet" href="generic.css">
    </head>
    <body>
        <div>
            <h1>Aktuelle Zeiterfassung</h1>
            <form action="insertTrackedHours.php" method="POST">
                <table>
                    <tr>
                        <td>Beginn:</td>
                        <td>
                            <label for="fromDate">📅</label>
                            <input type="date" name="fromDate" id="fromDate" value="<?php echo date("Y-m-d"); ?>" required>
                        </td>
                        <td>
                            <label for="fromTime">🕑</label>
                            <input type="time" name="fromTime" id="fromTime" value="<?php echo date("H:i:s"); ?>" required>
                        </td>
                    </tr>
                    <tr>
                        <td>Ende:</td>
                        <td>
                            <label for="toDate">📅</label>
                            <input type="date" name="toDate" id="toDate" value="<?php echo date("Y-m-d"); ?>" required>
                        </td>
                        <td>
                            <label for="toTime">🕑</label>
                            <input type="time" name="toTime" id="toTime" value="<?php echo date("H:i:s"); ?>" required>
                        </td>
                    </tr>
                    <tr>
                        <td>Ort:</td>
                        <td>
                            <label for="site">🗺️</label>
                            <select name="site" id="site">
<?php
    $results = $db->query('SELECT * FROM sites ORDER BY name');
    while ($row = $results->fetchArray()) {
        echo "\t\t\t\t\t\t\t\t<option value=\"" . $row['id'] . "\">" . $row['name'] . "</option>" . $rn;
    }
?>
                            </select>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <input type="submit" value=" 💾 Speichern">
                        </td>
                        <td></td>
                    </tr>                
                </table>
            </form>
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
                    <th>Anzeigen</th>
                </tr>
<?php
    $results = $db->query('SELECT * FROM v_TrackedHours ORDER BY date DESC');
    while ($row = $results->fetchArray()) {
        # print PHP object to browser's console
        #echo '<script>';
        #echo 'var row = ' . json_encode($row) . ';';
        #echo 'console.log(row);';
        #echo '</script>';


        echo "\t\t\t\t<tr>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['date'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['dayOfWeek'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['blocks'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['trackedHoursPerDay'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . $row['plannedHours'] . "</td>" . $rn;
        echo "\t\t\t\t\t<td>" . 'DIFF' . "</td>" . $rn;
        echo "\t\t\t\t\t<td><a href=\"showTrackedHours.php?date=" . $row['date'] . "\">➡️</a></td>" . $rn;
        echo "\t\t\t\t</tr>" . $rn;
    }
?>
            </table>
        </div>
    </body>
</html>