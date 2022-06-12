<?php
include ("conn.php");
 header("Access-Control-Allow-Origin: *");
 $id =  $_POST['id'];
 $key = $_POST['key'];
 if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "DELETE FROM `guest` WHERE `id` = '$id'";

   if( mysqli_query($connection, $query)){
        http_response_code(201);
        $delete_file  = "/var/www/html/attend/images/" . $id . ".jpg";
        if (is_file($delete_file)){
          unlink($delete_file);
        }
        mysqli_close($connection);
   }else{
        http_response_code(400);
   }

} else {
        http_response_code(403);
    echo "<font color=red> Access denied ! </font>";
}
?>
ubuntu@ip-172-31-8-130:/var/www/html/attend/API$ ^C
ubuntu@ip-172-31-8-130:/var/www/html/attend/API$ ^C
ubuntu@ip-172-31-8-130:/var/www/html/attend/API$ cat delete_guest.php
<?php
include ("conn.php");
 header("Access-Control-Allow-Origin: *");
 $id =  $_POST['id'];
 $key = $_POST['key'];
 if ($key == "z\$#PYc3E/:33VTiVB]T3p!c3E/Kcx!") {
    $query = "DELETE FROM `guest` WHERE `id` = '$id'";

   if( mysqli_query($connection, $query)){
        http_response_code(201);
        $delete_file  = "/var/www/html/attend/images/" . $id . ".jpg";
        if (is_file($delete_file)){
          unlink($delete_file);
        }
        mysqli_close($connection);
   }else{
        http_response_code(400);
   }

} else {
        http_response_code(403);
    echo "<font color=red> Access denied ! </font>";
}
?>