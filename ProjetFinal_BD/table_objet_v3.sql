BEGIN;

DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA IF NOT EXISTS projet AUTHORIZATION CURRENT_USER;

CREATE TABLE projet.utilisateur (
	iduser	INTEGER PRIMARY KEY,
	prenom	VARCHAR(35) NOT NULL,
	nom	VARCHAR(35) NOT NULL,
	email 	VARCHAR(255) UNIQUE,
	adresse VARCHAR(255)
);

CREATE TABLE projet.categorie(
	ncat	varchar(64) primary key,
	pcat 	varchar(64),
	foreign key (pcat) references projet.categorie(ncat)
);

CREATE TABLE projet.prefere (
	iduser 	INTEGER,
	ncat    VARCHAR(64),
	PRIMARY KEY (iduser, ncat),
	FOREIGN KEY (iduser) REFERENCES projet.utilisateur(iduser),
	FOREIGN KEY (ncat) REFERENCES projet.categorie(ncat)
);

CREATE TABLE projet.objet (
	idobj	integer primary key,
	name	varchar(128) NOT NULL,
	ncat 	varchar(64) NOT NULL,
	odesc	text,
	foreign key (ncat) references projet.categorie(ncat)
);

CREATE TABLE projet.feature (
	idobj int,
	fname varchar(64),
	fvalue varchar(255),
	primary key (idobj,fname),
	foreign key (idobj) references projet.objet(idobj) ON DELETE CASCADE
);

CREATE TABLE projet.partage (
	idobj	integer,
	idvend	integer,
	idacht	integer,
	qt	integer NOT NULL,
	date	timestamp NOT NULL,
	duree	interval,
	prix	money,
	lieu	varchar(255),
	primary key (idobj, idvend, idacht),
	foreign key (idobj) references projet.objet(idobj),
	foreign key (idvend) references projet.utilisateur(iduser),
	foreign key (idacht) references projet.utilisateur(iduser)
);

COMMIT;

/*Data*/
BEGIN;

/*Categorie*/
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Électronique', NULL);
INSERT INTO projet.categorie (ncat,pcat) VALUES ('PC','Électronique');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Accessoires PC','PC');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Mobile','Électronique');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Accesoires Mobile','Mobile');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Chargeur','Accesoires Mobile');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Portable','Électronique');

/* Objet */
INSERT INTO projet.objet (idobj,name,ncat,odesc) VALUES (1,'Ordinateur Aspire GX d''Acer (Core i7-7700 Intel/DD 2 To/RAM 12 Go/GeForce GTX1050 NVIDIA/Win 10)', 'PC', '<h4>Survol</h4>Conçu pour les tâches graphiques exigeantes et l''informatique au quotidien, l''ordinateur de bureau Aspire GX d''Acer est optimisé par un processeur Core i7-7700 d''Intel avec une mémoire vive DDR4 de 12 Go et une carte graphique GeForce GTX1050 de NVIDIA. Il est idéal pour les jeux, le montage vidéo et d''autres tâches quotidiennes. Et quand vous voulez vous reposer, cet ordinateur est parfait pour regarder des films en 4K à couper le souffle.<h4>En savoir plus</h4><ul><li>Processeur quadruple coeur Core i7-7700 d''Intel avec 12 Go de mémoire vive DDR4 offrant amplement de puissance pour les tâches quotidiennes, la navigation sur le web, l''édition, etc. </li> <li>Disque dur de 2 To offrant amplement d''espace de stockage pour vos photos, vos fichiers et vos applications</li> <li>Carte graphique GeForce GTX1050 de NVIDIA idéale pour les jeux et les tâches quotidiennes</li> <li>Port Ethernet 10/100/1000 permettant d''établir une connexion câblée fiable à Internet sur un réseau local pour des téléversements et téléchargements plus rapides</li> <li>Wi-Fi 802.11ac vous offrant la possibilité de profiter d''une connexion sans fil avec votre réseau résidentiel</li> <li>Lecteur optique 8x DVD+/-RW lisant vos films préférés et enregistrant du contenu</li> <li>Comprend 8 ports USB, y compris un port USB 3.1 de type C</li> <li>Équipé du système d''exploitation Windows 10 de 64 bits bilingue </li></ul>');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (1,'Type de processeur','Core i7-7700 d''Intel');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (1,'Nombre de Coeurs du processeur','4');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (1, 'Capacité du Disque dur', '2 To');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (1, 'Couleur', 'Noir');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (1, 'Système d''exploitation','Windows 10 Édition Familiale 64 bits');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (1, 'Mémoire Vive', '12 Go DDR4 à 2400 MHz');
INSERT INTO projet.objet (idobj,name,ncat,odesc) VALUES (2,'Portable MacBook Pro de 13,3 po d''Apple (Core i5 2,3GHz d''Intel/SSD 128 Go/RAM 8 Go) - Gris -Anglais', 'Portable', '<h4>Survol</h4>Le nouveau MacBook Pro est ultramince, léger et maintenant plus rapide et plus puissant qu''avant. Son écran est le plus lumineux et le plus coloré des écrans de portable Mac. Et il offre jusqu''à 10 heures d''autonomie.* C''est un portable conçu pour le travail quotidien. Il est prêt à vous suivre dans tous vos projets innovants.<h4>En savoir plus</h4><ul><li>Écran Retina éclatant </li> <li>Bicoeur Core i5 de 7e génération d''Intel</li> <li>Iris Plus Graphics 640 d''Intel</li> <li>Disque SSD ultrarapide</li> <li>Deux ports Thunderbolt 3 (USB-C) </li> <li>Offre jusqu''à 10 h d''autonomie*</li> <li>Wi-Fi 802.11ac</li> <li>Pavé tactile Force Touch</li></ul><p>*L''autonomie de la batterie varie selon l''utilisation et la configuration. Pour en savoir plus, consultez le site www.apple.com/ca/fr/batteries.</p>');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2,'Type de processeur','Core i5 d''Intel');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2,'Résolution d''écran native','2560 x 1600');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2,'Nombre de Coeurs du processeur','2');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2, 'Capacité du Disque SSD', '128 Go');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2, 'Couleur', 'Gris cosmique');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2, 'Système d''exploitation','macOS High Sierra');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (2, 'Mémoire Vive', '8 Go LPDDR3 à 2133 MHz');
INSERT INTO projet.objet (idobj,name,ncat,odesc) VALUES (3,'Portable de jeu de 15,6 po d''ASUS - Noir (Core i5-7300HQ d''Intel/DD 1 To/RAM 12 Go/Windows 10)','Portable', '<h4>Survol</h4> Ouvrez la porte à de meilleures expériences de jeu avec ce portable de jeu de 15,6 po d''ASUS. Il est doté d''un processeur quadruple coeur Core i5 d''Intel, de 12 Go de mémoire vive, d''un disque dur de 1 To et d''une carte graphique GeForce GTX 1050, ce qui vous permet de profiter d''expériences de jeu supérieures à la maison ou ailleurs.<h4>En savoir plus</h4><ul> <li>Processeur quadruple coeur Core i5-7300HQ à 2,5 GHz d''Intel et 12 Go de mémoire vive offrant une performance rapide et fiable pour vous permettre de profiter d''expériences de jeu supérieures </li> <li>Disque dur de 1 To offrant tout l''espace dont vous avez besoin pour vos jeux et vos fichiers multimédias </li> <li>Carte graphique GeForce GTX 1050 de NVIDIA avec mémoire vidéo dédiée de 4 Go pour des jeux fluides sans flous </li> <li>Écran HD intégrale de 15,6 po avec résolution native de 1920 x 1080 pixels affichant très clairement des images, vidéos, applications et autres de façon clairement détaillée </li> <li>Connectivité Wi-Fi 802.11ac pour une connexion sans fil très rapide à votre réseau Wi-Fi et aux points d''accès Wi-Fi publics</li> <li>Port Ethernet 10/100/1000 pour une connexion câblée fiable et sécurisée permettant une vitesse de téléchargement potentiellement plus rapide </li> <li>Connectivité Bluetooth 4.1 et 3 ports USB (1 port USB 2.0 et 2 ports USB 3.0) permettant de connecter facilement une variété de périphériques supplémentaires comme une imprimante ou des écouteurs sans fil</li> <li>Sortie HDMI vous offrant la possibilité de brancher votre portable à un téléviseur HD ou un moniteur HD pour une utilisation comme deuxième écran </li> <li>Fourni avec le système d''exploitation Windows 10 préinstallé, qui propose un navigateur Internet peaufiné, un menu Démarrer amélioré, un assistant numérique nommé Cortana, des applications Windows universelles et plus</li></ul>');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3,'Type de processeur','Core i5-7300HQ d''Intel');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3,'Résolution d''écran native','1920 x 1080');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3,'Nombre de Coeurs du processeur','4');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3, 'Capacité du Disque dur', '1 To');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3, 'Couleur', 'Noir');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3, 'Système d''exploitation','Windows 10 (64 bits)');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (3, 'Mémoire Vive', '12 Go DDR4');
INSERT INTO projet.objet (idobj, name,ncat,odesc) VALUES (4,'Corsair Gaming K70 LUX RGB Mechanical Keyboard, Backlit RGB LED, Cherry MX Red','Accessoires PC','<ul><li>Aircraft-grade anodized brushed aluminum frame for superior durability, Advanced lighting control and large font keycaps deliver dynamic, vibrant backlighting</li><li>CUE support enables advanced macro and lighting programming for virtually unlimited game customization</li><li>100-Percent anti-ghosting with full key rollover on USB, Detachable soft-touch wrist rest and dedicated multimedia controls</li><li>Dimension(mm):438 x 163 x 24</li></ul>');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (4,'Numéro de Modèle', 'CH-9101010-NA');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (4,'Poids de livraison', '1.7 Kg');
INSERT INTO projet.objet (idobj,name,ncat,odesc) VALUES (5,'Logitech G600 MMO Gaming Mouse, Black','Accessoires PC', '<ul><li>20 MMO-tuned buttons: includes unique 12-button thumb panel designed for quick, no-look navigation</li><li>G-Shift ring-finger button: instantly double the number of actions you can perform with every button</li><li>Built for comfort: sculpted shape and tuned buttons reduce click fatigue during marathon multiplayer sessions. G8-Cycle modes</li><li>Total personalization: set it up your way with customizable thumb panel lighting colors, dpi levels or button assignments</li><li>Made for pc gaming: compatible with windows vista, windows 7 and windows 8</li></ul>');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (5,'Numéro de Modèle', '910-002864');
INSERT INTO projet.feature (idobj,fname,fvalue) VALUES (5,'Poids de livraison', '268 g');
COMMIT;


/*SET SERIAL BACK AFTER ADDING DATA*/
BEGIN;

/*Utilisateur*/
CREATE SEQUENCE projet.utilisateur_id_seq;
ALTER TABLE projet.utilisateur ALTER COLUMN iduser SET DEFAULT nextval('projet.utilisateur_id_seq');
ALTER SEQUENCE projet.utilisateur_id_seq OWNED BY projet.utilisateur.iduser;
SELECT setval('projet.utilisateur_id_seq', 1); --Set this to MAX(id) + 1

/*Objet*/
CREATE SEQUENCE projet.objet_id_seq;
ALTER TABLE projet.objet ALTER COLUMN idobj SET DEFAULT nextval('projet.objet_id_seq');
ALTER SEQUENCE projet.objet_id_seq OWNED BY projet.objet.idobj;
SELECT setval('projet.objet_id_seq', 5); --Set this to MAX(id) + 1

COMMIT;

/*Views*/
CREATE VIEW projet.categorie_listing AS
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

/*
Connection string
serveur : postgres.iro.umontreal.ca
port : 5432
user : belislek_app
passwd : Projet_final_groupe_14
*/
