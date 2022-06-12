<?php
header("Access-Control-Allow-Origin: *");
include ("conn.php");

$isAttend = $_POST['isAttend'];
$search = $_POST['search'];
$page   = $_POST['page'];
$key    = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT `id`, `name`, `region`, `img`, DATE_FORMAT(`attend_time`,'%Y %M %d | %h:%m %p') AS 'attend_time' FROM `guest` LIMIT $page, 15";
    if (isset($search)) {
        $query = "SELECT `id`, `name`, `region`, `img`, DATE_FORMAT(`attend_time`,'%Y %M %d | %h:%m %p') AS 'attend_time' FROM `guest` WHERE `id` = '$search' OR `name` LIKE '%$search%' LIMIT $page, 15";
    }
    if (isset($isAttend)) {
if($isAttend=="1"){
        $query = "SELECT `id`, `name`, `region`, `img`, DATE_FORMAT(`attend_time`,'%Y %M %d | %h:%m %p') AS 'attend_time' FROM `guest` WHERE `attend_time` != 'NULL' LIMIT $page, 15";
    }else{
        $query = "SELECT `id`, `name`, `region`, `img`, DATE_FORMAT(`attend_time`,'%Y %M %d | %h:%m %p') AS 'attend_time' FROM `guest` WHERE `attend_time` is NULL LIMIT $page, 15";
}}

    $queryResult = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResult)) {
        $results = array();
        while ($fetchdata = $queryResult->fetch_assoc()) {
            $results[] = $fetchdata;
        }
        echo json_encode($results);
        http_response_code(202);
    } else {
        http_response_code(400);
    }
} else {
        http_response_code(403);
    echo "<font color=red> Access denied ! </font>";
}
?>
