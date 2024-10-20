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
            <h1>Einträge zum <?php echo $_GET['date']; ?></h1>
            <table>
                <tr>
                    <th>Start</th>
                    <th>Ende</th>
                    <th>Ort</th>
                    <th>Ändern</th>
                </tr>
<?php
    try {
        $stmt = $db->prepare("SELECT * FROM session WHERE strftime('%Y-%m-%d', startedAt) = :date ORDER BY startedAt DESC;");
        $stmt->bindValue(':date', $_GET['date'], SQLITE3_TEXT);

        #echo $stmt->getSQL($expanded = false) . $rn . "<br />";
        #echo $stmt->getSQL($expanded = true) . $rn . "<br />";

        $results = $stmt->execute();
        while ($row = $results->fetchArray()) {
            echo "\t\t\t\t<tr>" . $rn;
            echo "\t\t\t\t\t<td>" . $row['startedAt'] . "</td>" . $rn;
            echo "\t\t\t\t\t<td>" . $row['stoppedAt'] . "</td>" . $rn;
            echo "\t\t\t\t\t<td>" . $row['site'] . "</td>" . $rn;
            echo "\t\t\t\t\t<td><a href=\"changeTrackedHours.php?id=" . $row['id'] . "\">🔧</a></td>" . $rn;
            echo "\t\t\t\t</tr>" . $rn;
        }
    } catch (Exception $e) {
        echo 'Caught exception: ' . $e->getMessage();
    }
?>
            </table>
        </div>
    </body>
</html>