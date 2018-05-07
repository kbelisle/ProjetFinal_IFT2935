/* $<integer> représente le paramètre en php passé à la requête*/
/* requêtes d'insertion */

INSERT INTO projet.partage (idacheteur, idannonce, date) VALUES($1,$2,now());

INSERT INTO projet.utilisateur (prenom, nom, email, adresse) VALUES($1,$2,$3,$4);

INSERT INTO projet.prefere (iduser,ncat) VALUES($1,$2);

INSERT INTO projet.objet (name, ncat, odesc) VALUES($1,$2,$3);

INSERT INTO projet.annonce (datefin, prix, qte, idvendeur, idobj) VALUES ($1,$2,$3,$4,$5);

/* requêtes de sélection */
SELECT fname,fvalue FROM projet.feature WHERE idobj = $1

SELECT * FROM projet.utilisateur;

SELECT * FROM projet.annonce_actif ORDER BY idannonce ASC

SELECT ncat,pcat,niveau FROM projet.categorie_listing

SELECT * FROM projet.objet WHERE idobj = $1

/* (#1) 4 ou + relations : partage,annonce,objet,utilisateur(2)*/
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
		
/* (#2) 4 ou + relations : partage,annonce,objet,utilisateur(2)*/
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

/* (#3) 4 ou + relations : getCategorieHierarchy(2), projet.annonce_actif(2), objet*/	
SELECT 
	annonce_actif.idannonce,
	projet.objet.name, 
	projet.annonce_actif.datedebut,
	projet.annonce_actif.datefin 
FROM 
	projet.annonce_actif 
	JOIN projet.objet 
	ON ($1 = '' OR projet.objet.ncat IN ( SELECT projet.getCategorieHierarchy($1))) 
		AND position($2 in LOWER(projet.objet.name)) > 0 
		AND  projet.annonce_actif.idobj = projet.objet.idobj
		
/* (#4) 4 ou + relations : objet,feature,getCategorieHierarchy(2)*/	
SELECT 
	projet.objet.idobj,
	name,
	ncat,
	odesc,
	fname,
	fvalue 
FROM 
	projet.objet 
	LEFT JOIN projet.feature 
	ON projet.objet.idobj = projet.feature.idobj 
WHERE ncat IN (SELECT projet.getCategorieHierarchy($1)) AND position($2 in LOWER(name)) > 0		
/* Requete des Vues*/
/*Categorie hierarchie*/
/* (#5) 4 ou + relations : requete hierarchique à 5 niveau*/
SELECT n1cat as "ncat", p1cat as "pcat", niv as "niveau",
		niv1_parent,niv2_parent,niv3_parent,niv4_parent,niv5_parent
FROM (
SELECT *,
RANK() OVER(ORDER BY niv1_parent NULLS FIRST) as "rank1",
RANK() OVER(PARTITION BY niv1_parent ORDER BY niv2_parent NULLS FIRST) as "rank2",
RANK() OVER(PARTITION BY niv1_parent,niv2_parent ORDER BY niv3_parent NULLS FIRST) as "rank3",
RANK() OVER(PARTITION BY niv1_parent,niv2_parent,niv3_parent ORDER BY niv4_parent NULLS FIRST) as "rank4",
RANK() OVER(PARTITION BY niv1_parent,niv2_parent,niv3_parent,niv4_parent ORDER BY niv5_parent NULLS FIRST) as "rank5"
FROM (
SELECT n1cat, p1cat, niv,
CASE WHEN niv = 1 THEN n1cat WHEN niv = 2 THEN n2cat WHEN niv = 3 THEN n3cat WHEN niv = 4 THEN n4cat ELSE p5cat END as "niv1_parent",
CASE WHEN niv = 2 THEN n1cat WHEN niv = 3 THEN n2cat WHEN niv = 4 THEN n3cat WHEN niv = 5 THEN p4cat END as "niv2_parent",
CASE WHEN niv = 3 THEN n1cat WHEN niv = 4 THEN n2cat WHEN niv = 5 THEN p3cat END as "niv3_parent",
CASE WHEN niv = 4 THEN n1cat WHEN niv = 5 THEN p2cat END as "niv4_parent",
CASE WHEN niv = 5 THEN n1cat END as "niv5_parent"
FROM (
SELECT t1.ncat as "n1cat",t2.ncat as "n2cat",t3.ncat as "n3cat",t4.ncat as "n4cat",t5.ncat as "n5cat",
        t1.pcat as "p1cat",t2.ncat as "p2cat",t3.ncat as "p3cat",t4.ncat as "p4cat",t5.ncat as "p5cat",
CASE WHEN t1.pcat IS NULL THEN 1 WHEN t2.pcat IS NULL THEN 2 WHEN t3.pcat IS NULL THEN 3 WHEN t4.pcat IS NULL THEN 4 ELSE 5 END as "niv"
FROM projet.categorie t1
LEFT JOIN projet.categorie t2 ON t1.pcat = t2.ncat
LEFT JOIN projet.categorie t3 ON t2.pcat = t3.ncat
LEFT JOIN projet.categorie t4 ON t3.pcat = t4.ncat
LEFT JOIN projet.categorie t5 ON t4.pcat = t5.ncat
) t ) t
ORDER BY rank1,rank2,rank3,rank4,rank5) t;
/*Annonce_actif*/
SELECT a.*, a.qte - COUNT(p.idannonce) as "qteleft"
FROM projet.annonce as "a"
LEFT JOIN projet.partage as "p" ON a.idannonce = p.idannonce
WHERE (datefin IS NULL OR now() < a.datefin)
GROUP BY (a.idannonce)
HAVING COUNT(p.idannonce) < a.qte;