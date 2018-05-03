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
    $result = pg_query_params($conn, "SELECT fname,fvalue FROM projet.feature WHERE idobj = $1", array($data["idobj"]));
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

function filterSearch($conn, $name, $cat) {
    $result = pg_query_params($conn, "SELECT projet.objet.idobj,name,ncat,odesc,fname,fvalue FROM projet.objet LEFT JOIN projet.feature ON projet.objet.idobj = projet.feature.idobj WHERE ncat = $1 AND position($2 in LOWER(name)) > 0", array($cat,strtolower($name)));
    if (!$result) {
        $error = pg_last_error($conn);
        pg_close($conn);
        if ($error == "") {
            /*No Result*/
            return json_encode([],JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_LINE_TERMINATORS);
        }
        else {
            /*Error*/
            die (responseJson("5", "Error on request : filterSearch on filterSearch", "[]"));
        }
    }
    $data = array();
    for($i = 0; $i < pg_num_rows($result); $i++) {
        $row = pg_fetch_assoc($result,$i);
        $obj = array();
        $obj['idobj'] = $row['idobj'];
        $obj['name'] = $row['name'];
        $obj['ncat'] = $row['ncat'];
        $obj['odesc'] = $row['odesc'];
        if($row['fname'] === null) {
            /*no features*/
            $obj['features'] = [];
        }
        else {
            /*1->n features*/
            $tmp = array();
            $f = array();
            do {
                $f['fname'] = $row['fname'];
                $f['fvalue'] = $row['fvalue'];
                array_push($tmp, $f);
                $i++;
                if($i === pg_num_rows($result)) break;
                $row = pg_fetch_assoc($result,$i);
            } while($row['idobj'] === $obj['idobj']);
            $i -= 1;
            $obj['features'] = $tmp;
        }
        array_push($data, $obj);
    }
    return json_encode($data,JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_LINE_TERMINATORS);
}

?>