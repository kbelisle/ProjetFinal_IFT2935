/* requêtes d'insertion */

INSERT INTO projet.partage (idacheteur, idannonce, date) VALUES($1,$2,now());

INSERT INTO projet.utilisateur (prenom, nom, email, adresse) VALUES($1,$2,$3,$4);

INSERT INTO projet.prefere (iduser,ncat) VALUES($1,$2);

INSERT INTO projet.objet (name, ncat, odesc) VALUES($1,$2,$3);

INSERT INTO projet.annonce (datefin, prix, qte, idvendeur, idobj) VALUES ($1,$2,$3,$4,$5);

/* requêtes de sélection */

SELECT * FROM projet.utilisateur;

SELECT * FROM projet.annonce_actif ORDER BY idannonce ASC

SELECT ncat,pcat,niveau FROM projet.categorie_listing

SELECT * FROM projet.objet WHERE idobj = $1

SELECT
	o.name AS objet_nom,
	o.ncat AS objet_categorie,
	p.date AS partage_date,
	a.prix,
	u.prenom AS acheteur_prenom,
	u.nom AS acheteur_nom,
	v.prenom AS vendeur_prenom,
	v.nom AS vendeur_nom
FROM
	projet.annonce AS "a"
	INNER JOIN projet.partage AS "p"
		ON a.idvendeur = $1 AND a.idannonce = p.idannonce
	NATURAL JOIN projet.objet AS "o"
	INNER JOIN projet.utilisateur AS "u"
		ON u.iduser = p.idacheteur
	INNER JOIN projet.utilisateur AS "v"
		ON v.iduser = a.idvendeur ORDER BY date ASC;

SELECT 
	o.name AS objet_nom
	o.ncat AS objet_categorie
	p.date AS partage_date
	a.prix
	u.prenom AS vendeur_prenom
	u.nom AS vendeur_nom
	ac.prenom AS acheteur_prenom
	ac.nom AS acheteur_nom
FROM
	projet.partage AS "p"
	INNER JOIN projet.annonce AS "a"
	ON p.idacheteur = $1 AND a.idannonce = p.idannonce
	NATURAL JOIN projet.objet AS "o"
	INNER JOIN projet.utilisateur AS "u"
	ON u.iduser = a.idvendeur 
	INNER JOIN projet.utilisateur AS "ac"
	ON ac.iduser = p.idacheteur;

SELECT
	fname AS feature_nom,
	fvalue AS feature_valeur
FROM projet.feature WHERE idobj = $1;

SELECT 	
	aa.idannonce AS annonce_id
	aa.idobj AS objet_id
	aa.datedebut AS date_debut
	aa.datefin AS date_fin 
	aa.prix 
	aa.qte
	o.name AS objet_nom
	o.ncat AS objet_categorie
	o.odesc AS objet_description 
	u.prenom AS vendeur_prenom
	u.nom AS vendeur_nom 
	u.email AS vendeur_email
	u.adresse AS vendeur_adresse 
FROM
	projet.annonce_actif AS "aa"
	INNER JOIN projet.objet AS "o"
	ON aa.idannonce = $1 AND aa.idobj = o.idobj
	INNER JOIN projet.utilisateur AS "u"
	ON aa.idvendeur = u.iduser;

