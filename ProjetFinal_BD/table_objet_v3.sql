BEGIN;

DROP TABLE projet.partage;
DROP TABLE projet.feature;
DROP TABLE projet.objet;
DROP TABLE projet.categorie;
DROP TABLE projet.utilisateur;


CREATE TABLE projet.utilisateur (
	iduser integer primary key
);
CREATE TABLE projet.categorie(
	ncat	varchar(64) primary key,
	pcat 	varchar(64),
	foreign key (pcat) references projet.categorie(ncat)
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


/*
Connection string
serveur : postgres.iro.umontreal.ca
port : 5432
user : belislek_app
passwd : Projet_final_groupe_14
*/