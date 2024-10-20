<!DOCTYPE html>
<?php
    require_once('_defaults.php');
?>
<html lang="de">
    <head charset="utf-8">
        <title>WorkTracker</title>
        <link rel="stylesheet" href="generic.css">
        <script type="text/javascript" src="functions/_genericFunctions.js"></script>
        <script type="text/javascript" src="functions/getOptionsSite.js"></script>
        <script type="text/javascript" src="functions/getOptionsWorkType.js"></script>
        <script type="text/javascript" src="functions/insertSession.js"></script>
        <script type="text/javascript" src="functions/getLatestSessionsGroupedByDay.js"></script>
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="test">
            <h1>Aktuelle Zeiterfassung</h1>
            <form action="insertTrackedHours.php" method="POST">
                <table>
                    <tr>
                        <td>Beginn:</td>
                        <td>
                            <input type="datetime-local" name="fromDateTime" id="fromDateTime" required>
                            <input type="button" value="✖️" title="Un-set" onClick="document.getElementById('fromDateTime').value = undefined;">
                            <input type="button" value="🕒" title="Set to now" onClick="document.getElementById('fromDateTime').value = getNowForDatetimeLocal();">
                        </td>
                    </tr>
                    <tr>
                        <td>Ende:</td>
                        <td>
                            <input type="datetime-local" name="toDateTime" id="toDateTime" required>
                            <input type="button" value="✖️" title="Un-set" onClick="document.getElementById('toDateTime').value = undefined;">
                            <input type="button" value="🕒" title="Set to now" onClick="document.getElementById('toDateTime').value = getNowForDatetimeLocal();">
                        </td>
                    </tr>
                    <tr>
                        <td>Ort:</td>
                        <td>
                            <select name="optionsSite" id="optionsSite">
                                <script type="text/javascript" language="javascript">
                                    getOptionsSite();
                                </script>
                            </select>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Typ:</td>
                        <td>
                            <select name="optionsWorkType" id="optionsWorkType">
                                <script type="text/javascript" language="javascript">
                                    getOptionsWorkType();
                                </script>
                            </select>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <!-- call JavaScript function with parameters -->
                            <input type="button" value=" 💾 Speichern" onClick="insertSession(
                                    document.getElementById('fromDateTime').value,
                                    document.getElementById('toDateTime').value,
                                    document.getElementById('optionsSite').value,
                                    document.getElementById('optionsWorkType').value,
                                    Date.now()
                                );">
                            <div id="result"></div>
                        </td>
                        <td></td>
                    </tr>
                </table>
            </form>
        </div>
        <div>
            <h1>Zeiterfassungen der letzten 30 Tage</h1>
            <script type="text/javascript" language="javascript">
                getLatestSessionsGroupedByDay(30);
            </script>
            <div id="latestSessionsGroupedByDay">
        </div>
    </body>
</html>