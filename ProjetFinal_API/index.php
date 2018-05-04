<?php include "utility.php" ?>
<?php include "DAL.php" ?>
<?php

/*
 * $method contient une string représentant le tpe de la requête (GET,POST,PUT,DELETE)
 * $request contient la partie de l'URL après l'host dans un tableau split
 * EX: http://localhost:8312/objet/1 ($request contient ['objet', '1']
*/

/* Allow localhost to call localhost*/
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');

/* Deny access to all pages except this one in .htaccess */
// get the HTTP method, path and body of the request
$method = $_SERVER['REQUEST_METHOD'];

if(isset($_SERVER['PATH_INFO']))
    $request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
else
    die(responseJson("3", "Empty Request", "[]"));

//Hide this in web.config on app deploy
//Modifié connection_string pour pointé vers votre BD.
$connection_string = 'host=postgres.iro.umontreal.ca port=5432 dbname=belislek user=belislek_app password=Projet_final_groupe_14';
$DB = pg_connect($connection_string) or die ('Could not connect to BD : ' . pg_last_error());

/*Analyse, Valide et obtient les données de la bd si valide*/
$request_count = count($request);
if ($request_count == 0) {
    /* Invalid (Empty Request) */
    pg_close($DB);
    die(responseJson("3", "Empty Request", "[]"));
}
elseif ($request_count > 0 && $request[0] == "categorie") {
    /* Request categorie*/
    if($request_count == 1 && $method == "GET") {
        /* All */
        $data = getAllCategories($DB);
        pg_close($DB);
    }
    else {
        /* Invalide */
        pg_close($DB);
        die(responseJson("4", "Invalid Argument for categorie", "[]"));
    }
}
else if($request_count > 0 && $request[0] == "objet") {
    if ($request_count == 2 && $method == "GET") {
        /* Get by Id */
        if (ctype_digit($request[1])) {
            $data = getObjetById($DB, intval($request[1]));
            pg_close($DB);
        }
        else {
            /* Invalide */
            pg_close($DB);
            die(responseJson("4", "Invalid Argument for objet/id", "[]"));
        }
    }
    else {
        /* Invalide */
        pg_close($DB);
        die(responseJson("4", "Invalid Argument for objet", "[]"));
    }
}
elseif ($request_count == 1 && $request[0] == "filterSearch" && $method == 'GET') {
    /* Validate Input */
    if(isset($_GET['name']) && isset($_GET['categorie'])) {
        $data = filterSearch($DB,$_GET['name'],$_GET['categorie']);
        pg_close($DB);
    }
    else {
        /*Input Invalide*/
        pg_close($DB);
        die(responseJson("7", "Invalid Input for search", "[]"));
    }
}
else {
    /*Requete Invalide*/
    pg_close($DB);
    die(responseJson("6", "Invalid Request. Check the request URI", "[]"));
}

echo responseJson(0, '', $data);

?>