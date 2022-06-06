
drop table Pret
/
drop table Compte
/
drop table Client
/

SELECT SYSDATE FROM DUAL
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS'
/
SELECT SYSDATE FROM DUAL
/

SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY') FROM DUAL
/


' Recherche d'une table du dictionnaire de données
SELECT * FROM DICTIONARY
/
SELECT * FROM DICTIONARY WHERE COMMENTS LIKE '%user%'
/

SELECT Table_name from Dictionary where Table_name like '%TABLE%'
/


CREATE TABLE Client(id_client			INTEGER PRIMARY KEY,
     Nom 		VARCHAR(15),
 Naissance DATE,
 NAS 		VARCHAR(9))
/


INSERT ALL
    INTO Client VALUES(1,'Sanlessou',TO_DATE('01/01/1950','DD/MM/YYYY'),'11111111')
    INTO Client VALUES(2,'Chaiquenboi',TO_DATE('01/01/1960','DD/MM/YYYY'),'121')
    INTO Client VALUES(3,'Senzintérêt',TO_DATE('01/01/1950','DD/MM/YYYY'),NULL)
    SELECT * from dual
/

select * from Client
/

' visualiser une contrainte
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'CLIENT'
/


'*****************************************************************************
DROP TABLE Affectation;
DROP TABLE Project;
DROP TABLE Employe;


CREATE TABLE Employe(id_employe INTEGER PRIMARY KEY,
    no_employe INTEGER NOT NULL,
    matricule varchar(24) NOT NULL,
    nom VARCHAR(24) NOT NULL,
    prenon VARCHAR(24) NOT NULL,
    taux_horaire integer NOT NULL);

CREATE SEQUENCE employe_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

    
CREATE TABLE Project( id_project INTEGER PRIMARY KEY,
    nom VARCHAR(24),
    statut varchar(16),
    id_responsable INTEGER REFERENCES Employe(id_employe));

CREATE SEQUENCE project_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE TABLE Affectation (id_projet INTEGER REFERENCES Project,
	id_employe	INTEGER REFERENCES Employe  ON DELETE CASCADE,
	taux	 	NUMERIC(5,2) NOT NULL CHECK (taux > 0),
	PRIMARY KEY (id_projet, id_employe));

CREATE SEQUENCE affectation_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
delete from employe;
INSERT  INTO Employe VALUES(employe_seq.nextval,1234,'12345A','Ross','Yvan',10);
INSERT  INTO Employe VALUES(employe_seq.nextval,1234,'12345A','Ross','Yvan',10);
select * from employe;


-- division ensembliste
create table article(noArticle integer primary key,nom varchar(12));
create table commande(noCommande integer primary key,nom varchar(12));
create table LigneCommande( noCommande integer references commande,noArticle integer references article);

insert into article values(10,'ar10');
insert into article values(20,'ar20');
insert into article values(40,'ar40');
insert into article values(50,'ar50');
insert into article values(70,'ar70');
insert into article values(90,'ar90');
insert into article values(95,'ar95');

insert into commande values(1,'c1');
insert into commande values(2,'c2');
insert into commande values(3,'c3');
insert into commande values(4,'c4');
insert into commande values(5,'c5');
insert into commande values(6,'c6');
insert into commande values(7,'c7');

insert into lignecommande values(1,10);
insert into lignecommande values(1,70);
insert into lignecommande values(1,90);
insert into lignecommande values(2,40);
insert into lignecommande values(2,95);
insert into lignecommande values(3,20);
insert into lignecommande values(4,40);
insert into lignecommande values(4,50);
insert into lignecommande values(5,70);
insert into lignecommande values(5,10);
insert into lignecommande values(5,20);
insert into lignecommande values(6,10);
insert into lignecommande values(6,40);
insert into lignecommande values(7,50);
insert into lignecommande values(7,95);

select noCommande from commande;
select noArticle from article where noarticle in (10,70);


-- semaine_02 diapositive 67 ne fonctionne pas
select noCommande from commande where not exists ((select noArticle from article where noArticle in (10,70) ) except (select noArticle from LigneCommande where noCommande = Commande.noCommande));

