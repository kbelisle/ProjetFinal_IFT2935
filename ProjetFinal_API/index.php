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
elseif ($request_count > 0 && $request[0] == "sales") {
	
	if($request_count == 2 && $method == "GET") {
		
		if(ctype_digit($request[1])) {
		
			$data = getSaleHistory($DB, intval($request[1]));
			pg_close($DB);
		}
		else {
            /* Invalide */
            pg_close($DB);
            die(responseJson("4", "Invalid Argument for sales/id", "[]"));
        }
		
	}
	else {
        /* Invalide */
        pg_close($DB);
        die(responseJson("4", "Invalid Argument for sales", "[]"));
    }
}
elseif ($request_count > 0 && $request[0] == "purchases") {
	
	if($request_count == 2 && $method == "GET") {
		
		if(ctype_digit($request[1])) {
		
			$data = getPurchaseHistory($DB, intval($request[1]));
			pg_close($DB);
		}
		else {
            /* Invalide */
            pg_close($DB);
            die(responseJson("4", "Invalid Argument for purchases/id", "[]"));
        }
		
	}
	else {
        /* Invalide */
        pg_close($DB);
        die(responseJson("4", "Invalid Argument for purchases", "[]"));
    }
}
elseif ($request_count > 0 && $request[0] == "ad") {
	
	if($method == "GET") {
		if($request_count == 1) {
		    if(isset($_GET['cat']) && isset($_GET['name'])) {
		        $data = searchActiveAnnonceByCategorieAndName($DB, $_GET['cat'], $_GET['name']);
		        pg_close($DB);
		    }
		    else {
		        $data = getAllAds($DB);
		        pg_close($DB);
		    }
			
		}
		else if($request_count == 2) {
		
			if(ctype_digit($request[1])) {
			
				$data = getAd($DB, intval($request[1]));
				pg_close($DB);
			}
			else {
				/* Invalide */
				pg_close($DB);
				die(responseJson("4", "Invalid Argument for ad/id", "[]"));
			}
		
		}
		else {
			/* Invalide */
			pg_close($DB);
			die(responseJson("4", "Invalid Argument for ad", "[]"));
		}
		
	}
	else if($method == "POST" && sizeof($_POST) == 7) {
		
		$objectDescription = $_POST["objet_description"];
		$endDate = $_POST["annonce_date_fin"];
		$price = $_POST["objet_prix"];
		$qte = $_POST["objet_qte"];
		$objectName = $_POST["objet_nom"];
		$categoryName = $_POST["objet_categorie"];
		$userID = $_POST["vendeur_id"];
		
		addAd($DB, $endDate, $price, $qte, $objectName, $objectDescription, $userID, $categoryName);
		
		$data = '"success"';
		
	}
	
}
elseif ($request_count > 0 && $request[0] == "features") {
		
	if($request_count == 2 && $method == "GET") {
	
		if(ctype_digit($request[1])) {
		
			$data = getFeatures($DB, intval($request[1]));
			pg_close($DB);
		}
		else {
			/* Invalide */
			pg_close($DB);
			die(responseJson("4", "Invalid Argument for features/id", "[]"));
		}
	
	}
	else {
		/* Invalide */
		pg_close($DB);
		die(responseJson("4", "Invalid Argument for features", "[]"));
	}
	
}
elseif ($request_count > 0 && $request[0] == "partage") {
	
	if($request_count == 1 && $method == "POST" && sizeof($_POST) == 2) {
		
		$idannonce = $_POST["annonce_id"];
		$idacheteur = $_POST["acheteur_id"];
		addPartage($DB, $idannonce, $idacheteur);
		$data = '"success"';
		pg_close($DB);
		
	}
	
}
elseif ($request_count > 0 && $request[0] == "utilisateur") {
	
	if($request_count == 1 && $method == "GET") {
		
		$data = getAllUsers($DB);
		pg_close($DB);
		
	}
	elseif($request_count == 1 && $method = "POST" && sizeof($_POST) == 5) {
	
		$firstName = $_POST["prenom"];
		$lastName = $_POST["nom"];
		$email = $_POST["email"];
		$address = $_POST["adresse"];
		$preference = $_POST["preference"];
		
		addUser($DB, $firstName, $lastName, $email, $address, $preference);
		$data = '"success"';
		pg_close($DB);
		
	}
	else {
		error_log(sizeof($_POST));
		error_log($_POST["preference"]);
		/* Invalide */
		pg_close($DB);
		die(responseJson("4", "Invalid Argument for utilisateur", "[]"));
	}
	
}
else {
    /*Requete Invalide*/
    pg_close($DB);
    die(responseJson("6", "Invalid Request. Check the request URI", "[]"));
}

echo responseJson(0, '', $data);

?>