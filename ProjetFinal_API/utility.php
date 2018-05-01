<?php
/*
 * Retourne une string Json au client
 * $errorCode : Code erreur (string)
 * $errorMessage : Message d'erreur (string)
 * $data : Donnée de la requête (string)
 * 
 * */
function responseJson($errorCode, $errorMessage, $data) {
    return '{"errCode":'.$errorCode.',"errMsg":"'.$errorMessage.'", "data":'.$data.'}';
}
?>