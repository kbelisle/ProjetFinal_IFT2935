<?php include "utility.php" ?>
<?php include "DAL.php" ?>
<?php
/* Deny access to all pages except this one in .htaccess */
// get the HTTP method, path and body of the request
header('Content-Type: application/json');
$method = $_SERVER['REQUEST_METHOD'];

if(isset($_SERVER['PATH_INFO']))
    $request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
else
    die(responseJson("3", "Empty Request", "[]"));

//Get Json Input
$input = json_decode(file_get_contents('php://input'),true);
//Uncomment to only receive JSON data
/*if (json_last_error() != JSON_ERROR_NONE) {
    //Error on DATA
    die(responseJson("2", "Wrong Data Type", "[]"));
}*/

/*Validation des requêtes ici*/

/* Fill Data*/
//Hide this in web.config on app deploy
//Modifié connection_string pour pointé vers votre BD.
$connection_string = 'host=postgres.iro.umontreal.ca port=5432 dbname=belislek user=belislek_app password=Projet_final_groupe_14';
$DB = pg_connect($connection_string) or die ('Could not connect to BD : ' . pg_last_error());

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
else {
    pg_close($DB);
    die(responseJson("6", "Invalid Request. Check the request URI", "[]"));
}

echo responseJson(0, '', $data);

?>