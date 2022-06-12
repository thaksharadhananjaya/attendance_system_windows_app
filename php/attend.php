include ("conn.php");

$id = $_POST['id'];
$key    = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "SELECT `attend_time`, `name`, `id`, `img` FROM `guest` WHERE `id` = '$id' LIMIT 1";

    $queryResult = mysqli_query($connection, $query);
    if (mysqli_num_rows($queryResult)) {
        $results     = mysqli_fetch_array($queryResult);
        $attend_time = $results["attend_time"];
        if($attend_time==null || $id == "12354"){
            mysqli_query($connection, "UPDATE `guest` SET `attend_time`=now() WHERE `id` = '$id'");
            http_response_code(201);
            echo json_encode($results);
        }else{
            http_response_code(201);
            echo json_encode("0");
        }

    } else {
        http_response_code(400);
        echo json_encode("-1");
    }

} else {
   http_response_code(403);
    echo "<font color=red> Access denied ! </font>";
}
?>