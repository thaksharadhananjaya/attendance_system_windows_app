<?php
header("Access-Control-Allow-Origin: *");
include ("conn.php");

$id = $_POST['id'];
$key    = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT `attend_time`, `name`, `id` FROM `guest` WHERE `id` = '$id' LIMIT 1";

    $queryResult = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResult)) {
        $results     = mysqli_fetch_array($queryResult);
        $attend_time = $results["attend_time"];
        if($attend_time!=null){
            mysql_query($connection, "UPDATE `guest` SET `attend_time`=now()");
            http_response_code(201);
            echo json_encode($results);
        }else{
            http_response_code(201);
            echo json_encode("0");
        }
        
    } else {
        echo json_encode("-1");
    }
    mysql_close($connection);
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>