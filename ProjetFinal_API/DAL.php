<?php

function addPartage($conn, $idannonce, $idacheteur) {
	
	$query = 'INSERT INTO projet.partage (idacheteur, idannonce, date) VALUES ($1,$2,now());';
	
	$result = pg_query_params($conn, $query, array($idannonce,$idacheteur));
	
	if(!$result) {
		
		die (responseJson("5", "Error on post request : partage. ", "[]"));
		
	}
	
}

function getAllUsers($conn) {
	
	$query = 'SELECT * FROM projet.utilisateur;';
	
	$result = pg_query($conn, $query);
	
	if(!$result) {

		pg_close($conn);
		die (responseJson("5", "Error on request : utilisateur/all. ", "[]"));
	
	}
	
	$data = pg_fetch_all($result);
	
	if(!$data) {
		$error = pg_last_error($conn);
        pg_close($conn);
        if ($error == "") {
            /* No Result*/
            die (responseJson("1", "Error on request : utilisateur/all. No Result." . $error, "[]"));
        }
        else {
            /*Error*/
            die (responseJson("5", "Error on request : utilisateur/all. " . $error, "[]"));
        }
	}
	
	return json_encode($data,JSON_UNESCAPED_UNICODE);
	
}

function addUser($conn, $firstName, $lastName, $email, $address, $preference) {
	
	$query = 'INSERT INTO projet.utilisateur (prenom, nom, email, adresse) VALUES($1,$2,$3,$4);';
	
	$result = pg_query_params($conn, $query, array($firstName, $lastName, $email, $address));
	
	if(!$result) {

		pg_close($conn);
		die (responseJson("5", "Error on post request : utilisateur. ", "[]"));
		
	}
	
	$query = 'SELECT iduser FROM projet.utilisateur WHERE email = $1';
	
	$result = pg_query_params($conn, $query, array($email));
	
	$id = pg_fetch_assoc($result)["iduser"];
	
	$query = 'INSERT INTO projet.prefere (iduser,ncat) VALUES($1,$2)';
	
	$result = pg_query_params($conn, $query, array($id, $preference));
	
}

function addAd($conn, $endDate, $price, $qte, $objectName, $objectDescription, $userID, $categoryName) {
	
	$query = 'INSERT INTO projet.objet (name, ncat, odesc) VALUES($1,$2,$3);';
	
	$result = pg_query_params($conn, $query, array($objectName, $categoryName, $objectDescription));
	
	if(!$result) {

		pg_close($conn);
		die (responseJson("5", "Error on post request : utilisateur. ", "[]"));
		
	}
	
	$query = 'SELECT idobj FROM projet.objet WHERE name = $1 AND ncat = $2 AND odesc = $3;';
	
	$result = pg_query_params($conn, $query, array($objectName, $categoryName, $objectDescription));
	
	$data = pg_fetch_assoc($result);
	
	$idobj = $data["idobj"];
	
	$query = 'INSERT INTO projet.annonce (datefin, prix, qte, idvendeur, idobj) VALUES ($1,$2,$3,$4,$5);';
	
	$result = pg_query_params($conn, $query, array($endDate, $price, $qte, $userID, $idobj));
	
}

function getSaleHistory($conn, $id) {
	/* Retourne l'historique de ventes d'un utilisateur */
	$query = 'SELECT ' .
				'o.name AS objet_nom,' .
				'o.ncat AS objet_categorie,' .
				'p.date AS partage_date,' .
				'a.prix,' .
				'u.prenom AS acheteur_prenom, ' .
				'u.nom AS acheteur_nom, ' .
				'v.prenom AS vendeur_prenom, ' .
				'v.nom AS vendeur_nom ' .
			'FROM ' .
				'projet.annonce AS "a" ' .
				'INNER JOIN projet.partage AS "p" ' .
					'ON a.idvendeur = $1 AND a.idannonce = p.idannonce ' .
				'NATURAL JOIN projet.objet AS "o" ' .
				'INNER JOIN projet.utilisateur AS "u" ' . 
					'ON u.iduser = p.idacheteur ' .
				'INNER JOIN projet.utilisateur AS "v" ' .
					'ON v.iduser = a.idvendeur ORDER BY date ASC;';
	
	$result = pg_query_params($conn, $query, array($id));
	
	if(!$result) {
		
		pg_close($conn);
		die (responseJson("5", "Error on request : sales/id. ", "[]"));
		
	}
	
	$data = pg_fetch_all($result);
	
	if(!$data) {
		$error = pg_last_error($conn);
        pg_close($conn);
        if ($error == "") {
            /* No Result*/
            die (responseJson("1", "Error on request : sales/id. No Result." . $error, "[]"));
        }
        else {
            /*Error*/
            die (responseJson("5", "Error on request : sales/id. " . $error, "[]"));
        }
	}
	
	return json_encode($data,JSON_UNESCAPED_UNICODE);
	
}

function getPurchaseHistory($conn, $id) {
	
	$query = 'SELECT ' .
				'o.name AS objet_nom,' .
				'o.ncat AS objet_categorie,' .
				'p.date AS partage_date,' .
				'a.prix,' .
				'u.prenom AS vendeur_prenom,' .
				'u.nom AS vendeur_nom,' .
				'ac.prenom AS acheteur_prenom,' .
				'ac.nom AS acheteur_nom ' .
			'FROM ' .
				'projet.partage AS "p" ' .
				'INNER JOIN projet.annonce AS "a"  ' .
					'ON p.idacheteur = $1 AND a.idannonce = p.idannonce ' .
				'NATURAL JOIN projet.objet AS "o" ' .
				'INNER JOIN projet.utilisateur AS "u" ' .
					'ON u.iduser = a.idvendeur ' .
				'INNER JOIN projet.utilisateur AS "ac" ' .
					'ON ac.iduser = p.idacheteur;';
	
	$result = pg_query_params($conn, $query, array($id));
	
	if(!$result) {
		
		pg_close($conn);
		die (responseJson("5", "Error on request : sales/id. ", "[]"));
		
	}
	
	$data = pg_fetch_all($result);
	
	if(!$data) {
		$error = pg_last_error($conn);
        pg_close($conn);
        if ($error == "") {
            /* No Result*/
            die (responseJson("1", "Error on request : purchases/id. No Result." . $error, "[]"));
        }
        else {
            /*Error*/
            die (responseJson("5", "Error on request : purchases/id. " . $error, "[]"));
        }
	}
	
	return json_encode($data,JSON_UNESCAPED_UNICODE);
	
}

function getFeatures($conn, $id) {
	
	$query = 	'SELECT ' .
					'fname AS feature_nom,' .
						'fvalue AS feature_valeur ' .
				'FROM projet.feature WHERE idobj = $1;';
				
	$result = pg_query_params($conn, $query, array($id));
	
	if (!$result) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Features/id", "[]"));
    }
	
    $data = pg_fetch_all($result);
	
    if(!$data) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Features/id", "[]"));
		
    }
	
    return json_encode($data,JSON_UNESCAPED_UNICODE);
	
}

function getAd($conn, $id) {
	
	$query = 'SELECT ' .
				'aa.idannonce AS annonce_id,' .
				'aa.idobj AS objet_id,' .
				'aa.datedebut AS date_debut,' .
				'aa.datefin AS date_fin,' . 
				'aa.prix,' . 
				'aa.qte,' .
				'o.name AS objet_nom,' . 
				'o.ncat AS objet_categorie,' . 
				'o.odesc AS objet_description,' . 
				'u.prenom AS vendeur_prenom,' .
				'u.nom AS vendeur_nom,' . 
				'u.email AS vendeur_email,' . 
				'u.adresse AS vendeur_adresse ' .
			'FROM ' .
				'projet.annonce_actif AS "aa" ' .
				'INNER JOIN projet.objet AS "o" ' .
					'ON aa.idannonce = $1 AND aa.idobj = o.idobj ' .
				'INNER JOIN projet.utilisateur AS "u" ' .
		'			ON aa.idvendeur = u.iduser;';

	$result = pg_query_params($conn, $query, array($id));
	
    if (!$result) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Ad/id", "[]"));
    }
	
    $data = pg_fetch_assoc($result);
	
    if(!$data) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Ad/id", "[]"));
		
    }
	
    return json_encode($data,JSON_UNESCAPED_UNICODE);
	
}

function getAllAds($conn) {
	
	$result = pg_query($conn, "SELECT * FROM projet.annonce_actif ORDER BY idannonce ASC");
    if (!$result) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Ad/All", "[]"));
    }
    $data = pg_fetch_all($result);
    if(!$data) {
        pg_close($conn);
        die (responseJson("5", "Error on request : Ad/All", "[]"));
    }
    return json_encode($data,JSON_UNESCAPED_UNICODE);
	
}

/*Obtient toutes les catégories et les retournent en JSON*/
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
/*Obtient l'objet et ces features avec l'id associé*/
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

/*Obtient tous les objets et leurs features selon so $name fait partie de son nom et si il fait partie de la categorie $cat*/
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