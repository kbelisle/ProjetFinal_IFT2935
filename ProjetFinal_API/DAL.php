<?php

function getAllCategories($conn) {
    $result = pg_query($conn, "SELECT ncat,pcat,niveau FROM projet.categorie_listing");
    if (!$result) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Categorie/All", "[]"));
    }
    $data = pg_fetch_all($result);
    if(!$data) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Categorie/All", "[]"));
    }
    return json_encode($data,JSON_UNESCAPED_UNICODE);
}

function getObjetById($conn, $id) {
    $result = pg_query_params($conn, "SELECT * FROM projet.objet WHERE idobj = $1", array($id));
    if (!$result) {
        pg_close($conn);
        die (responseJson("5", "Error on request : objet/id", "[]"));
    }
    $data = pg_fetch_assoc($result);
    if(!$data) {
        $error = pg_last_error($conn);
        pg_close($conn);
        if ($error == "") {
            /* No Result*/
            die (responseJson("1", "Error on request : objet/id. No Result." . $error, "[]"));
        }
        else {
            /*Error*/
            die (responseJson("5", "Error on request : objet/id. " . $error, "[]"));
        }
    }
    $result = pg_query_params($conn, "SELECT * FROM projet.feature WHERE idobj = $1", array($data["idobj"]));
    if (!$result) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Features on objet/id", "[]"));
    }
    $features = pg_fetch_all($result);
    if(!$features) {
        $error = pg_last_error($conn);
        pg_close($conn);
        if ($error == "") {
            /*No Result*/
            $data["features"] = [];
        }
        else {
            /*Error*/
            die (responseJson("5", "Error on request : objet/id. " . $error, "[]"));
        }
    }
    else {
        $data["features"] = $features;
    }
    return json_encode($data,JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_LINE_TERMINATORS);
}

?>