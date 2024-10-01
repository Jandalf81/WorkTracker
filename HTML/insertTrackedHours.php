<?php
    require_once('_defaults.php');

    echo json_encode($_POST) . $rn . "<br />";

    try {
        $stmt = $db->prepare("INSERT INTO trackedHours (id, startedAt, stoppedAt, site, workType, createdAt) VALUES (null, :fromDate, :toDate, :site, :workType, :createdAt);");
        $stmt->bindValue(':fromDate', $_POST['fromDate'] . ' ' . $_POST['fromTime'], SQLITE3_TEXT);
        $stmt->bindValue(':toDate', $_POST['toDate'] . ' ' . $_POST['toTime'], SQLITE3_TEXT);
        $stmt->bindValue(':site', $_POST['site'], SQLITE3_INTEGER);
        $stmt->bindValue(':workType', $_POST['workType'], SQLITE3_INTEGER);
        $stmt->bindValue(':createdAt', $_POST['toDate'] . ' ' . $_POST['toTime'], SQLITE3_TEXT);

        #echo $stmt->getSQL($expanded = false) . $rn . "<br />";
        #echo $stmt->getSQL($expanded = true) . $rn . "<br />";

        $result = $stmt->execute();

        echo 'Der Eintrag wurde erfolgreich gespeichert';
    } catch (Exception $e) {
        echo 'Caught exception: ' . $e->getMessage();
    }
?>