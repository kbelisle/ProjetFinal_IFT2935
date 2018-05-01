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
	name	varchar(64),
	odesc	text,
	ncat varchar(64),
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

/*BEGIN;

COMMIT;*/

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
SELECT setval('projet.objet_id_seq', 1); --Set this to MAX(id) + 1

COMMIT;

/*
Connection string
serveur : postgres.iro.umontreal.ca
port : 5432
user : belislek_app
passwd : Projet_final_groupe_14
*/