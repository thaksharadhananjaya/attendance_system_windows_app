<?php
include("conn.php");
header("Access-Control-Allow-Origin: *");

$base64_string = $_POST["image"];
$name          = $_POST["name"];
$contact       = $_POST["contact"];
$email         = $_POST["email"];
$address       = $_POST["address"];
$city          = $_POST["city"];
$key           = $_POST['key'];

if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {

    
    $query = "INSERT INTO `guest`(`name`, `region`, `inv_num`) VALUES ('$name','$region','$inv_num')";
    if($inv_num==null){
        if($base64_string==null){
            $query = "INSERT INTO `guest`(`name`, `region`, `img`) VALUES ('$name','$region',1)";
        }else{
            $query = "INSERT INTO `guest`(`name`, `region`) VALUES ('$name','$region')";
        }
    }else{
        if($base64_string==null){
            $query = "INSERT INTO `guest`(`name`, `region`, `inv_num`, `img`) VALUES ('$name','$region','$inv_num',1)";
        }
    }
    
    if (mysqli_query($connection, $query)) {
        
        $queryResult = mysqli_query($connection, "SELECT MAX(`id`) AS 'id' FROM `guest` LIMIT 1");
        $results     = mysqli_fetch_array($queryResult);
        $productID   = $results["id"];
        if($base64_string!="null"){
        try {
            
            $outputfile  = "/var/www/html/attend/images/" . $productID . ".jpg";
            $filehandler = fopen($outputfile, 'wb');
            if (!$filehandler) {
                echo json_encode("-1");
            } else {
                $data = fwrite($filehandler, base64_decode($base64_string));
                fclose($filehandler); 
                http_response_code(200);              
            }
        }
        }
        catch (Exception $e) {
            echo json_encode($e);
        }
        
    } else {
        echo json_encode("0");
    }
    
    
} else {
    echo "<font color=red> Access denied ! </font>";
}
?>