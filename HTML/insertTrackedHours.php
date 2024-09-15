<?php
    require_once('_defaults.php');

    echo json_encode($_POST) . $rn . "<br />";

    try {
        $stmt = $db->prepare("INSERT INTO trackedHours (id, startedAt, stoppedAt, site, createdAt) VALUES (null, :fromDate, :toDate, :site, :createdAt);");
        $stmt->bindValue(':fromDate', $_POST['fromDate'] . ' ' . $_POST['fromTime'], SQLITE3_TEXT);
        $stmt->bindValue(':toDate', $_POST['toDate'] . ' ' . $_POST['toTime'], SQLITE3_TEXT);
        $stmt->bindValue(':site', $_POST['site'], SQLITE3_INTEGER);
        $stmt->bindValue(':createdAt', $_POST['toDate'] . ' ' . $_POST['toTime'], SQLITE3_TEXT);

        echo $stmt->getSQL(false) . $rn . "<br />";
        echo $stmt->getSQL(true) . $rn . "<br />";

        $result = $stmt->execute();

        header('Location: index.php');
    } catch (Exception $e) {
        echo 'Caught exception: ' . $e->getMessage();
    }
?>