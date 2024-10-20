<?php
    require_once("../_defaults.php");

    header('Content-Type: application/json');

    try {
        $object = (object) [
            'result' => 'OK',
            'errorMessage' => '',
            'data' => ''
        ];

        $stmt = $db->prepare("INSERT INTO session (startedAt, stoppedAt, site, workType, createdAt) VALUES (:fromDate, :toDate, :site, :workType, :createdAt);");
        $stmt->bindValue(":fromDate", $_POST["fromDateTime"], SQLITE3_TEXT);
        $stmt->bindValue(":toDate", $_POST["toDateTime"], SQLITE3_TEXT);
        $stmt->bindValue(":site", $_POST["site"], SQLITE3_INTEGER);
        $stmt->bindValue(":workType", $_POST["workType"], SQLITE3_INTEGER);
        $stmt->bindValue(":createdAt", $_POST["createdAt"], SQLITE3_TEXT);

        $object->data =  $stmt->getSQL($expanded = true);

        $results = $stmt->execute();
    } catch (Exception $e) {
        $object->result = "ERROR";
        $object->errorMessage = $e->getMessage();
    }

    echo json_encode($object);
?>