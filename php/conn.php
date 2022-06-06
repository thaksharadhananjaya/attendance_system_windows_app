<?php

    $connection = new mysqli(
		'localhost', 
		'root', 
		'4321!@#$qW', 
		'guest');

    if (!$connection) {
        echo "connection failed!";
        exit();
    }
	
?>
