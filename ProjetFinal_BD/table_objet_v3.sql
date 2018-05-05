BEGIN;

DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA IF NOT EXISTS projet AUTHORIZATION CURRENT_USER;

CREATE TABLE projet.utilisateur (
	iduser	SERIAL PRIMARY KEY,
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
	FOREIGN KEY (iduser) REFERENCES projet.utilisateur(iduser) ON DELETE CASCADE,
	FOREIGN KEY (ncat) REFERENCES projet.categorie(ncat) ON DELETE CASCADE
);

CREATE TABLE projet.objet (
	idobj	INTEGER primary key,
	name	VARCHAR(128) NOT NULL,
	ncat 	VARCHAR(64) NOT NULL,
	odesc	TEXT,
	foreign key (ncat) references projet.categorie(ncat)
);

CREATE TABLE projet.feature (
	idobj INTEGER NOT NULL,
	fname VARCHAR(64) NOT NULL,
	fvalue VARCHAR(255),
	primary key (idobj,fname),
	foreign key (idobj) references projet.objet(idobj) ON DELETE CASCADE
);

CREATE TABLE projet.annonce (
	idannonce SERIAL PRIMARY KEY,
	idobj INTEGER NOT NULL,
	idvendeur INTEGER NOT NULL,
	datedebut DATE DEFAULT now(),
	datefin DATE CHECK (datefin > datedebut OR datefin IS NULL),
	description VARCHAR(255),
	prix MONEY CHECK (prix >= cast(0.0 AS MONEY)),
	qte INTEGER CHECK (qte >= 0),
	FOREIGN KEY(idobj) REFERENCES projet.objet(idobj),
	FOREIGN KEY(idvendeur) REFERENCES projet.utilisateur(iduser)
);

CREATE TABLE projet.partage (
	PRIMARY KEY(idacheteur, idannonce, date),
	idacheteur INTEGER,
	idannonce INTEGER,
	date DATE,
	FOREIGN KEY(idacheteur) REFERENCES projet.utilisateur(iduser),
	FOREIGN KEY(idannonce) REFERENCES projet.annonce(idannonce)
);

COMMIT;

/*Data*/
BEGIN;

/*Categorie*/
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Électronique', NULL);
INSERT INTO projet.categorie (ncat,pcat) VALUES ('PC','Électronique');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Accessoires PC','PC');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Mobile','Électronique');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Accessoires Mobile','Mobile');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Chargeur','Accessoires Mobile');
INSERT INTO projet.categorie (ncat,pcat) VALUES ('Portable','Électronique');

/* Objet */
INSERT INTO projet.objet (idobj,name,ncat,odesc) 
VALUES 
(1,'Ordinateur Aspire GX d''Acer (Core i7-7700 Intel/DD 2 To/RAM 12 Go/GeForce GTX1050 NVIDIA/Win 10)', 'PC', '<h4>Survol</h4>Conçu pour les tâches graphiques exigeantes et l''informatique au quotidien, l''ordinateur de bureau Aspire GX d''Acer est optimisé par un processeur Core i7-7700 d''Intel avec une mémoire vive DDR4 de 12 Go et une carte graphique GeForce GTX1050 de NVIDIA. Il est idéal pour les jeux, le montage vidéo et d''autres tâches quotidiennes. Et quand vous voulez vous reposer, cet ordinateur est parfait pour regarder des films en 4K à couper le souffle.<h4>En savoir plus</h4><ul><li>Processeur quadruple coeur Core i7-7700 d''Intel avec 12 Go de mémoire vive DDR4 offrant amplement de puissance pour les tâches quotidiennes, la navigation sur le web, l''édition, etc. </li> <li>Disque dur de 2 To offrant amplement d''espace de stockage pour vos photos, vos fichiers et vos applications</li> <li>Carte graphique GeForce GTX1050 de NVIDIA idéale pour les jeux et les tâches quotidiennes</li> <li>Port Ethernet 10/100/1000 permettant d''établir une connexion câblée fiable à Internet sur un réseau local pour des téléversements et téléchargements plus rapides</li> <li>Wi-Fi 802.11ac vous offrant la possibilité de profiter d''une connexion sans fil avec votre réseau résidentiel</li> <li>Lecteur optique 8x DVD+/-RW lisant vos films préférés et enregistrant du contenu</li> <li>Comprend 8 ports USB, y compris un port USB 3.1 de type C</li> <li>Équipé du système d''exploitation Windows 10 de 64 bits bilingue </li></ul>'),
(2,'Portable MacBook Pro de 13,3 po d''Apple (Core i5 2,3GHz d''Intel/SSD 128 Go/RAM 8 Go) - Gris -Anglais', 'Portable', '<h4>Survol</h4>Le nouveau MacBook Pro est ultramince, léger et maintenant plus rapide et plus puissant qu''avant. Son écran est le plus lumineux et le plus coloré des écrans de portable Mac. Et il offre jusqu''à 10 heures d''autonomie.* C''est un portable conçu pour le travail quotidien. Il est prêt à vous suivre dans tous vos projets innovants.<h4>En savoir plus</h4><ul><li>Écran Retina éclatant </li> <li>Bicoeur Core i5 de 7e génération d''Intel</li> <li>Iris Plus Graphics 640 d''Intel</li> <li>Disque SSD ultrarapide</li> <li>Deux ports Thunderbolt 3 (USB-C) </li> <li>Offre jusqu''à 10 h d''autonomie*</li> <li>Wi-Fi 802.11ac</li> <li>Pavé tactile Force Touch</li></ul><p>*L''autonomie de la batterie varie selon l''utilisation et la configuration. Pour en savoir plus, consultez le site www.apple.com/ca/fr/batteries.</p>'),
(3,'Portable de jeu de 15,6 po d''ASUS - Noir (Core i5-7300HQ d''Intel/DD 1 To/RAM 12 Go/Windows 10)','Portable', '<h4>Survol</h4> Ouvrez la porte à de meilleures expériences de jeu avec ce portable de jeu de 15,6 po d''ASUS. Il est doté d''un processeur quadruple coeur Core i5 d''Intel, de 12 Go de mémoire vive, d''un disque dur de 1 To et d''une carte graphique GeForce GTX 1050, ce qui vous permet de profiter d''expériences de jeu supérieures à la maison ou ailleurs.<h4>En savoir plus</h4><ul> <li>Processeur quadruple coeur Core i5-7300HQ à 2,5 GHz d''Intel et 12 Go de mémoire vive offrant une performance rapide et fiable pour vous permettre de profiter d''expériences de jeu supérieures </li> <li>Disque dur de 1 To offrant tout l''espace dont vous avez besoin pour vos jeux et vos fichiers multimédias </li> <li>Carte graphique GeForce GTX 1050 de NVIDIA avec mémoire vidéo dédiée de 4 Go pour des jeux fluides sans flous </li> <li>Écran HD intégrale de 15,6 po avec résolution native de 1920 x 1080 pixels affichant très clairement des images, vidéos, applications et autres de façon clairement détaillée </li> <li>Connectivité Wi-Fi 802.11ac pour une connexion sans fil très rapide à votre réseau Wi-Fi et aux points d''accès Wi-Fi publics</li> <li>Port Ethernet 10/100/1000 pour une connexion câblée fiable et sécurisée permettant une vitesse de téléchargement potentiellement plus rapide </li> <li>Connectivité Bluetooth 4.1 et 3 ports USB (1 port USB 2.0 et 2 ports USB 3.0) permettant de connecter facilement une variété de périphériques supplémentaires comme une imprimante ou des écouteurs sans fil</li> <li>Sortie HDMI vous offrant la possibilité de brancher votre portable à un téléviseur HD ou un moniteur HD pour une utilisation comme deuxième écran </li> <li>Fourni avec le système d''exploitation Windows 10 préinstallé, qui propose un navigateur Internet peaufiné, un menu Démarrer amélioré, un assistant numérique nommé Cortana, des applications Windows universelles et plus</li></ul>'),
(4,'Corsair Gaming K70 LUX RGB Mechanical Keyboard, Backlit RGB LED, Cherry MX Red','Accessoires PC','<ul><li>Aircraft-grade anodized brushed aluminum frame for superior durability, Advanced lighting control and large font keycaps deliver dynamic, vibrant backlighting</li><li>CUE support enables advanced macro and lighting programming for virtually unlimited game customization</li><li>100-Percent anti-ghosting with full key rollover on USB, Detachable soft-touch wrist rest and dedicated multimedia controls</li><li>Dimension(mm):438 x 163 x 24</li></ul>'),
(5,'Logitech G600 MMO Gaming Mouse, Black','Accessoires PC', '<ul><li>20 MMO-tuned buttons: includes unique 12-button thumb panel designed for quick, no-look navigation</li><li>G-Shift ring-finger button: instantly double the number of actions you can perform with every button</li><li>Built for comfort: sculpted shape and tuned buttons reduce click fatigue during marathon multiplayer sessions. G8-Cycle modes</li><li>Total personalization: set it up your way with customizable thumb panel lighting colors, dpi levels or button assignments</li><li>Made for pc gaming: compatible with windows vista, windows 7 and windows 8</li></ul>'),
(6, 'Samsung Galaxy A8', 'Mobile', '<h4>Survol</h4>Profitez pleinement de chaque moment avec le Galaxy A8, de Samsung. Tirez le meilleur parti des deux appareils avant et prenez de superbes égoportraits, même en situation de faible luminosité. Grâce à la mise au point en direct, vous pouvez ajuster le flou de l’arrière-plan pour parfaire chaque portrait. Certifié IP682, l’indice de protection contre l’eau et la poussière, le Galaxy A8 est un excellent choix pour immortaliser des moments sous la pluie ou au bord d’une piscine. L’écran Infinity Display s’étend sur toute la surface de l’appareil pour vous offrir une expérience de visionnement immersive. Passez au niveau supérieur dans votre utilisation quotidienne d’un téléphone intelligent grâce aux fonctionnalités haut de gamme du Galaxy A8, de Samsung.<h4>En savoir plus</h4><ul><li>Taille de l''écran de 5,6 po</li><li>Résolution 2220x1080 px</li><li>Appareil photo frontal de 16 et 8 Mpx</li><li>Appareil photo arrière de 16 Mpx</li><li>Mémoire RAM de 4 Go</li><li>Mémoire Interne de 32 Go</li><li>Processeur octocoeur Samsung Exynos 7885</li><li>Batterie 3000 mAh non amovible</li></ul>'),
(7, 'Transcend JetFlash 300 16 GB', 'Accessoires PC', '<ul><li>Flash Drive</li><li>USB 2.0</li><li>16GB</li><li>Write speed 10Mbps</li></ul>'),
(8, 'Ecko Unltd. Chaos 2 Ear Buds', 'Accessoires Mobile', '<h4>Overview</h4>We all know that living with bad headphones isn''t living at all. Come breathe new life with one of our new selections. Classic style of headphones with logos on outer surface of earbuds. One meter cable with inline microphone and volume control compatible with iPods, iPhones and Android smartphones. Comes with three sizes of ear-piece gels.'),
(9, 'BenQ GW Series 21.5”', 'Accessoires PC', '<ul><li>21.5 in</li><li>LED</li><li>Flat Panel</li><li>Maximum resolution 1920x1080</li><li>1 VGA Port</li><li>1 DVI-D Port</li></ul>'),
(10, 'P710e Mobile Speakerphone', 'Accessoires Mobile', '<h4>Overview</h4>Transform any workspace into an instant conference room with the Logitech® P710e mobile speakerphone and your own smartphone or tablet. Ideal for users who work remotely from hotel rooms, home offices, or non-traditional workplace settings, as well as workers inside the enterprise, the P710e mobile speakerphone provides flexibility to conduct conference calls wherever you are. The integrated stand positions your mobile phone or tablet at just the right angle for shake-free video calls and hands-free access to the mobile screen'),
(11, 'Asus VE278Q 27"', 'Accessoires PC', '<ul><li>Widescreen LED</li><li>27 in</li><li>Maximum resolution 1920x1080</li><li>Built-in Speakers</li><li>1 DVI port</li><li>1 HDMI port</li><li>1 VGA port</li></ul>'),
(12, 'Kensington Pro Fit Wired Full-Size Mouse', 'Accessoires PC', '<h4>Overview</h4>Performance, comfort and reliability are critical in any office environment, the Pro Fit™ Wired Full-Size Mouse delivers this every working day. The full-size right-handed ergonomic design makes it ideal for prolonged use. Conveniently located browser navigation buttons and scrollwheel help users complete tasks quicker. Plug and Play wired USB or PS2 avoids setup pains.'),
(13, 'THINKPAD 90W AC ADAPTER-X1CARBON', 'Chargeur', '<ul><li>Input Voltage: AC 100-240V</li><li>Fequency Required: 50/60 Hz</li><li>Power Capacity: 90 Watt</li></ul>'),
(14, 'Lenovo ThinkPad E570', 'Portable', '<h4>Survol</h4>Puissant et résistant, le ThinkPad E570 est assez léger pour vous emmener partout où vous faites affaires. Conçu pour améliorer la productivité, le portable de 15,6 po est lisse et doté d''un processeur rapide, d''un écran haute résolution et d''un clavier ergonomique en standard. Il peut également être configuré pour répondre au mieux à vos besoins d''affaires en matière de stockage, de mémoire, de graphiques et de budget.<h4>En savoir plus</h4><ul><li>processeur Intel® Core™ i5-7200U de 7e génération (cache de 3 Mo, jusqu''à 3,10 GHz)</li><li>Graphiques HD Intel® 620</li><li>Caméra de 720p</li><li>Jusqu''à 16 Go DDR4, 2133 MHz</li><li>500 Go, 7200 trs/min</li><li>256 GB PCIe SSD OPAL2.0</li><li>Écran HD de 15,6 po (1366 x 768) TN, non tactile</li></ul>'),
(15, 'Ordinateur portable HP 255 G6', 'Portable', '<h4>Survol</h4>Travaillez en toute confiance grâce à l’ordinateur portable durable HP 255. Il est équipé pour le travail en entreprise et est prêt pour les déplacements, grâce à Windows 10 Professionnel1 et des APU AMD incroyablement puissants APU AMD. Profitez de cet ordinateur à un prix compétitif, doté d’outils de collaboration essentiels.<h4>En savoir plus</h4><ul><li>Windows 10</li><li>APU A6 AMD</li><li>8 Go RAM DDR4</li><li>Disque dur 5400tr/min de 500 Go</li><li>Écran de 15,6 po 1366x768</li></ul>'),
(16, 'Adesso AKB-310UB Mini Keyboard - Optical Trackball', 'Accessoires PC', '<h4>Overview</h4>The Adesso AKB-310UB Mini Keyboard, combined with an integrated optical trackball, gives users control of their desktop. The integrated optical trackball delivers superior precision and smooth motion with virtually no maintenance or cleaning required. Measuring less than 12" wide and equipped with an embedded numeric keypad, the Adesso AKB-310UB Mini Keyboard is a great space saver for desktops in homes or offices. It is ideal for use in POS, kiosks, warehouses, manufacturing environments or in any small working area.'),
(17, 'ThinkCentre M810z tout-en-un', 'PC', '<h4>Survol</h4>Puissant, fiable, intuitif. Grâce à une technologie rapide comme l''éclair, le ThinkCentre M810z gère les images, vidéos et gros fichiers sans difficulté. Conçu pour l''utilisateur, ce tout-en-un de 21,5 po procure une expérience supérieure au quotidien. Affichez un contenu d''une grande limpidité grâce à la technologie antireflets. Placez l''écran comme il vous sied, grâce aux supports polyvalents qui conviennent à votre style de travail. Soyez rassuré en sachant que vos données importantes sont protégées. Économisez temps et argent grâce à des réparations rapides et sans outil. Choisissez ce ThinkCentre tout-en-un professionnel pour une performance d''ensemble fiable en une seule et même solution.<h4>En savoir plus</h4><ul><li>Processeur Intel Core i7-7700</li><li>Windows 10</li><li>Mémoire RAM de 16 Go	DDR4 2400 MHz</li><li>Disque dur 7200tr/min de 500 Go</li><li>Écran tout-en-un multipoint de 21,5 po avec caméra 1080P</li></ul>'),
(18, 'Wacom Intuos Draw Small', 'Accessoires PC', '<h4>Overview</h4>Ignite your imagination with the Intuos Draw, which includes Wacom''s leading pen tablet technology. Whether your dream is crafting amazing sketches, sharing your work with friends, or starting a portfolio, Intuos Draw has everything you need to start creating right away.');

INSERT INTO projet.feature (idobj,fname,fvalue) 
VALUES 
(1,'Type de processeur','Core i7-7700 d''Intel'),
(1,'Nombre de Coeurs du processeur','4'),
(1, 'Capacité du Disque dur', '2 To'),
(1, 'Couleur', 'Noir'),
(1, 'Système d''exploitation','Windows 10 Édition Familiale 64 bits'),
(1, 'Mémoire Vive', '12 Go DDR4 à 2400 MHz'),
(2,'Type de processeur','Core i5 d''Intel'),
(2,'Résolution d''écran native','2560 x 1600'),
(2,'Nombre de Coeurs du processeur','2'),
(2, 'Capacité du Disque SSD', '128 Go'),
(2, 'Couleur', 'Gris cosmique'),
(2, 'Système d''exploitation','macOS High Sierra'),
(2, 'Mémoire Vive', '8 Go LPDDR3 à 2133 MHz'),
(3,'Type de processeur','Core i5-7300HQ d''Intel'),
(3,'Résolution d''écran native','1920 x 1080'),
(3,'Nombre de Coeurs du processeur','4'),
(3, 'Capacité du Disque dur', '1 To'),
(3, 'Couleur', 'Noir'),
(3, 'Système d''exploitation','Windows 10 (64 bits)'),
(3, 'Mémoire Vive', '12 Go DDR4'),
(4,'Numéro de Modèle', 'CH-9101010-NA'),
(4,'Poids de livraison', '1.7 Kg'),
(5,'Numéro de Modèle', '910-002864'),
(5,'Poids de livraison', '268 g'),
(6,'Processeur','2.2GHz Octo-Core'),
(6,'Résolution d''écran','2220x1080 (FHD+)'),
(6,'Appareil photo', '16.0 MP + 8.0 MP'),
(6,'Mémoire RAM', '4 Go'),
(6,'Stockage', '32 Go'),
(7,'Poids de livraison', '40,82g'),
(7,'Stockage', '16 Go'),
(8,'Poids de livraison', '58,98g'),
(8,'Manufacturier', 'Mizco'),
(9, 'Résolution d''écran', '1920x1080'),
(9, 'Taille de l''écran', '21,5 pouces'),
(10,'Manufacturier', 'Logitech'),
(10,'Poids de livraison', '431g'),
(10,'Microphone', 'MIcrophone omnidirectionnel, couverture 360 degrés'),
(10,'Autonomie', '15 heures'),
(11,'Manufacturier', 'Asus'),
(11,'Taille de l''écran', '27 pouces'),
(11,'LED Backlight', 'oui'),
(11,'Résolution d''écran', '1920x1080'),
(11,'Port DVI', '1'),
(11,'Port HDMI', '1'),
(11,'Port DisplayPort', '1'),
(12,'Manufacturier', 'Kensington'),
(12,'Connectivité', 'avec fil'),
(12,'Senseur', 'Optique'),
(13,'Manufacturier', 'Lenovo'),
(13,'Poids de livraison', '499g'),
(14,'Manufacturier', 'Lenovo'),
(14,'Système d''exploitation', 'Windows 10'),
(14,'Graphiques', 'Graphiques HD Intel 620'),
(14,'Webcam', 'Caméra de 720p'),
(14,'Mémoire RAM', '16 Go DDR4'),
(14,'Stockage', '500 Go, 7200 trs/min'),
(14,'Taille d''écran', '15.6 po'),
(14,'Résolution d''écran', '1366x768'),
(15,'Manufacturier', 'HP'),
(15,'Processeur', 'APU AMD E2-9000e'),
(15,'Stockage', '500 Go, 5400 trs/min'),
(15,'Graphiques', 'AMD Radeon R2'),
(16,'Manufacturier', 'Adesso'),
(16,'Connectivité', 'Câble'),
(16,'Couleur', 'Noir'),
(17,'Manufacturier', 'Lenovo'),
(17,'Système d''exploitation', 'Windows 10'),
(17,'Processeur', 'Intel Core i7-7700'),
(17,'Mémoire RAM', '16 Go DDR4 2400 MHz'),
(17,'Stockage', '500 Go, 7200 trs/min'),
(17,'Graphiques', 'Intel HD intégré'),
(17,'Taille de l''écran', '21,5 pouces'),
(17,'Caméra', '1080p avec double microphone matriciel numérique'),
(18,'Manufacturier', 'Wacom'),
(18,'Type', 'Sensible à la pression, sans fil et sans pile'),
(18,'Surface active', 'Petit: 152 x 95 mm');

INSERT INTO projet.utilisateur (prenom, nom, email, adresse) VALUES
('Leon', 'Dietrich', 'leondietrich@armyspy.com', '3422 Sixth Street, New Westminister, BC, Canada'),
('Stephan', 'Fassbinder', 'stephanfassbinder@jourrapide.com', '440 chemin du Lac, Boucherville, QC, Canada'),
('Apolline', 'Gadbois', 'apollinegadbois@dayrep.com', '825 Lynden Road, ON, Canada'),
('Thorsten', 'Gottlieb', 'thorstengottlieb@dayrep.com', '1765 Brew Creek Rd, Squamish, BC, Canada'),
('Sebastian', 'Rothstein', 'sebastianrothstein@rhyta.com', '2063 Islington Ave, Toronto, ON, Canada'),
('Tiffany', 'Wood', 'tiffanykwood@armyspy.com', '3086 George Street, Peterborough, ON, Canada'),
('Naomi', 'Sanders', 'naomisanders@armyspy.com', '3992 Poplar Street, Alberton, PE, Canada'),
('Sadlq', 'Bahar', 'sadiqjulbahar@teleworm.us', '3493 St John Street, Bengough, SK, Canada'),
('Evle', 'Pethard', 'eviepethard@dayrep.com', '3800 Eglinton Avenue, Toronto, ON, Canada'),
('Rhys', 'Potter', 'rhyspotter@armyspy.com', '2838 St Jean Baptiste, St-Yamachiche, QC, Canada'),
('Nlamh', 'Gallagher', 'niamhgallagher@dayrep.com', '3671 Dundas Street, Toronto, ON, Canada'),
('Yvon', 'Dubé', 'yvondube@armyspy.com', '2744 Robson Street, Vancouver, BC, Canada'),
('Raoul', 'Benoit', 'raoulbenoit@armyspy.com', '3578 Pitt Street, Cornwall, ON, Canada'),
('Llona', 'Caraballo', 'llonacaraballo@teleworm.us', '1491 Port Washington Road, Coaldale, AB, Canada'),
('Orleta', 'Zaragoza', 'orietazaragozanieto@teleworm.us', '438 avenue de Port-Royal, Bonaventure, QC, Canada'),
('Paulette', 'Bonneville', 'paulettebonneville@dayrep.com', '798 Township Road, Lloydminster, AB, Canada'),
('Sabine', 'Dumoulin', 'sabinedumoulin@jourrapide.com', '1684 Saskatchewan Dr, Quebec, QC, Canada'),
('Joeffroi', 'Bordeleau', 'jeoffroibordeleau@armyspy.com', '1227 Heritage Drive, Calgary, AB, Canada'),
('Christopher', 'Allen', 'christopherdallen@armyspy.com', '3954 Bridgeport Road, Hamilton, ON, Canada'),
('Maryse', 'Bordeaux', 'marysebordeaux@dayrep.com', '2029 De la Providence Avenue Hull, QC, Canada'),
('Louis', 'Cailot', 'louiscailot@teleworm.us', '1597 St. John Street, Invermay, SK, Canada'),
('Abel', 'Bernal', 'abelmbernal@teleworm.us', '979 Blanshard, Victoria, BC, Canada'),
('Angie', 'Perterson', 'angierpeterson@teleworm.us', '471 Boulevard Cremazie, Quebec, QC, Canada'),
('Dominic', 'Quenneville', 'dominicquenneville@jourrapide.com', '2877 St Jean Baptiste, Saint-Cap-aux-Meules, QC, Canada');

INSERT INTO projet.prefere (iduser, ncat) VALUES
(1, 'Électronique'),
(2, 'Portable'),
(2, 'Mobile'),
(3, 'Accessoires PC'),
(4, 'Électronique'),
(5, 'Accessoires Mobile'),
(5, 'Accessoires PC'),
(6, 'PC'),
(7, 'Mobile'),
(8, 'Portable'),
(9, 'PC'),
(10, 'PC'),
(11, 'Électronique'),
(12, 'Portable'),
(12, 'Chargeur'),
(13, 'Accessoires PC'),
(14, 'Accessoires Mobile'),
(15, 'PC'),
(16, 'Chargeur'),
(17, 'Portable'),
(17, 'PC'),
(18, 'Électronique'),
(19, 'Accessoires PC'),
(20, 'PC'),
(21, 'Mobile'),
(22, 'Électronique'),
(23, 'Électronique'),
(24, 'Mobile');

INSERT INTO projet.annonce (idobj, idvendeur, datedebut, datefin, prix, qte)
VALUES
(1, 1, '2018-05-04', '2018-05-10', 1300.0, 1),
(2, 5, '2018-05-01', '2018-05-07', 1500.0, 2),
(3, 17, '2018-04-29', '2018-05-03', 820.99, 5),
(4, 12, '2018-05-03', '2018-05-09', 0.0, 1),
(5, 2, '2018-05-04', '2018-05-10', 50.0, 3),
(6, 3, '2018-04-05', '2018-04-11', 150.0, 1),
(7, 1, '2018-04-15', '2018-04-21', 0.0, 1),
(8, 15, '2018-05-01', '2018-05-07', 0.0, 1),
(9, 20, '2018-05-02', '2018-05-08', 50.99, 3),
(10, 21, '2018-04-27', '2018-05-01', 12.0, 2),
(11, 4, '2018-05-04', '2018-05-10', 125.0, 1),
(12, 16, '2018-05-02', '2018-05-08', 25.0, 2),
(13, 2, '2018-05-02', '2018-05-08', 32.0, 1),
(14, 1, '2018-05-04', '2018-05-10', 550.0, 1),
(15, 7, '2018-05-03', '2018-05-09', 450.99, 5),
(16, 8, '2018-04-28', '2018-05-03', 19.99, 10),
(17, 5, '2018-04-22', '2018-04-30', 1299.99, 1),
(18, 12, '2018-05-01', '2018-05-07', 60.0, 2);

INSERT INTO projet.partage (idacheteur, idannonce, date)
VALUES
(20, 3, '2018-04-30'),
(15, 5, '2018-05-04'),
(14, 3, '2018-04-29'),
(16, 7, '2018-04-29'),
(13, 18, '2018-05-06'),
(1, 10, '2018-04-28'),
(8, 14, '2018-05-09'),
(8, 1, '2018-05-04'),
(12, 10, '2018-04-28');
COMMIT;

/*SET SERIAL BACK AFTER ADDING DATA*/
BEGIN;

/*Objet*/
CREATE SEQUENCE projet.objet_id_seq;
ALTER TABLE projet.objet ALTER COLUMN idobj SET DEFAULT nextval('projet.objet_id_seq');
ALTER SEQUENCE projet.objet_id_seq OWNED BY projet.objet.idobj;
SELECT setval('projet.objet_id_seq', 5); --Set this to MAX(id)

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

CREATE VIEW projet.annonce_actif AS
SELECT a.*, a.qte - COUNT(p.idannonce) as "qteleft"
FROM projet.annonce as "a"
LEFT JOIN projet.partage as "p" ON a.idannonce = p.idannonce
WHERE (datefin IS NULL OR now() < a.datefin)
GROUP BY (a.idannonce)
HAVING COUNT(p.idannonce) < a.qte;

/*
Connection string
serveur : postgres.iro.umontreal.ca
port : 5432
user : belislek_app
passwd : Projet_final_groupe_14
*/
