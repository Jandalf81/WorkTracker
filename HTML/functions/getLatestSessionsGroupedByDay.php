<?php
    require_once("../_defaults.php");

    header('Content-Type: application/json');

    try {
        $stmt = $db->prepare("SELECT * FROM v_sessionsGroupedByDay_Split ORDER BY date DESC LIMIT :limit");
        $stmt->bindValue(":limit", $_POST["limit"], SQLITE3_INTEGER);
        
        $results = $stmt->execute();

        $object = (object) [
            'result' => 'OK',
            'errorMessage' => '',
            'limit' => $_POST["limit"],
            'data' => ''
        ];

        $object->data = "<table>";
        $object->data = $object->data . "<tr>";
        $object->data = $object->data . "<th>Datum</th>";
        $object->data = $object->data . "<th>Wochentag</th>";
        $object->data = $object->data . "<th>Sessions</th>";
        $object->data = $object->data . "<th>IST-Stunden</th>";
        $object->data = $object->data . "<th>SOLL-Stunden</th>";
        $object->data = $object->data . "<th>DiffPositiv</th>";
        $object->data = $object->data . "<th>DiffNegativ</th>";
        $object->data = $object->data . "<th>Anzeigen</th>";
        $object->data = $object->data . "</tr>";

        while ($row = $results->fetchArray()) {
            $object->data = $object->data . "<tr>";
            $object->data = $object->data . "<td>" . $row['date'] . "</td>";
            $object->data = $object->data . "<td>" . $row['dayOfWeek'] . "</td>";
            $object->data = $object->data . "<td>" . $row['sessions'] . "</td>";
            $object->data = $object->data . "<td>" . $row['trackedHoursTime'] . "</td>";
            $object->data = $object->data . "<td>" . $row['plannedHoursTime'] . "</td>";

            $object->data = $object->data . "<td>" . $row['DiffPositive'] . "</td>";
            $object->data = $object->data . "<td>" . $row['DiffNegative'] . "</td>";
            
            $object->data = $object->data . "<td><a href=\"showTrackedHours.php?date=" . $row['date'] . "\">➡️</a></td>";
            $object->data = $object->data . "</tr>";
        }

        $object->data = $object->data . "</table>";
    } catch (Exception $e) {
        $object->result = "ERROR";
        $object->errorMessage = $e->getMessage();
    }

    echo json_encode($object);
?>