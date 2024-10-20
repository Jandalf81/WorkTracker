<?php
    require_once("../_defaults.php");

    header('Content-Type: application/json');

    try {
        $stmt = $db->prepare("SELECT * FROM sites ORDER BY name;");

        $results = $stmt->execute();

        $object = (object) [
            'result' => 'OK',
            'errorMessage' => '',
            'data' => ''
        ];

        $object->data = $object->data . "<option value=\"-1\" selected hidden disabled>Please select...</option>";

        while ($row = $results->fetchArray()) {
            $object->data = $object->data . "<option value=\"" . $row["id"] . "\"";

            $object->data = $object->data . ">" . $row["name"] . "</option>";
        }
    } catch (Exception $e) {
        $object->result = "ERROR";
        $object->errorMessage = $e->getMessage();
    }

    echo json_encode($object);
?>