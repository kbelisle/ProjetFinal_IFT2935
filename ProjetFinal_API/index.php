<?php include "utility.php" ?>
<?php

// get the HTTP method, path and body of the request
$method = $_SERVER['REQUEST_METHOD'];

if(isset($_SERVER['PATH_INFO']))
    $request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
else
    $request = ["/"];

//Get Json Input
$input = json_decode(file_get_contents('php://input'),true);
//Uncomment to only receive JSON data
/*if (json_last_error() != JSON_ERROR_NONE) {
    //Error on DATA
    die(responseJson("2", "Wrong Data Type", "[]"));
}*/

/*Validation des requêtes ici*/

//Hide this in web.config on app deploy
//Modifié connection_string pour pointé vers votre BD.
$connection_string = 'host=postgres.iro.umontreal.ca port=5432 dbname=belislek user=belislek_app password=Projet_final_groupe_14';
$DB = pg_connect($connection_string) or die ('Could not connect to BD : ' . pg_last_error());
        
pg_set_client_encoding($DB,"UTF-8");

/* Fill Data  ici*/

$data = "[]";

pg_close($DB);

echo responseJson(0, '', $data);

?>