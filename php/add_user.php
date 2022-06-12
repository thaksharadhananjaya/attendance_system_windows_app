<?php
include("conn.php");
header("Access-Control-Allow-Origin: *");

$base64_string = $_POST["image"];
$name          = $_POST["name"];
$region       = $_POST["region"];
$inv_num         = $_POST["invNum"];
$key           = $_POST["key"];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {

    $query = "INSERT INTO `guest`(`name`, `region`, `id`) VALUES ('$name','$region','$inv_num')";
   if($inv_num=="null"){
        if($base64_string=="null"){
            $query = "INSERT INTO `guest`(`name`, `region`, `img`) VALUES ('$name','$region',1)";
        }else{
            $query = "INSERT INTO `guest`(`name`, `region`) VALUES ('$name','$region')";
        }
    }else{
        if($base64_string=="null"){
            $query = "INSERT INTO `guest`(`name`, `region`, `id`, `img`) VALUES ('$name','$region','$inv_num',1)";
        }
    }

    if (mysqli_query($connection, $query)) {
        if($base64_string!="null"){
        if($inv_num=="null"){
           $id = mysqli_insert_id($connection);
        }else{
           $id = $inv_num;
        }

        try {

            $outputfile  = "/var/www/html/attend/images/" . $id . ".jpg";
            $filehandler = fopen($outputfile, 'wb');
            if (!$filehandler) {

                echo json_encode($outputfile);
            } else {
                $data = fwrite($filehandler, base64_decode($base64_string));
                fclose($filehandler);
                http_response_code(201);
            }
        }
        catch (Exception $e) {
            echo json_encode($e);
        }
      }else{
        http_response_code(201);
        }


    } else {
        http_response_code(422);
    }


} else {
    http_response_code(403);
    echo "<font color=red> Access denied ! </font>";
}
?>