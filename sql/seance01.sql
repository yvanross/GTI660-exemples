
drop table Pret
/
drop table Compte
/
drop table Client
/

CREATE TABLE Client(noClient			INTEGER PRIMARY KEY,
 nomClient 		VARCHAR(15),
 adresseClient		VARCHAR(20),
 noTelephone 		VARCHAR(15))
/

CREATE TABLE Compte(noCompte 			INTEGER PRIMARY KEY,
 solde	 		DECIMAL(10,2) CHECK (solde >= 0),
 dateOuverture 		DATE,
 noClient			INTEGER REFERENCES Client)
/

CREATE TABLE Pret(noPret 			INTEGER PRIMARY KEY,
 montantPret 		DECIMAL(10,2),
 dateDebut 		DATE,
 tauxInteret		DECIMAL(8,2),
 frequencePaiement	INTEGER,
 noClient			INTEGER REFERENCES Client)
/

INSERT INTO Client VALUES(10,'Luc Sansom','Ottawa','(999)999-9999')
/

INSERT all
    INTO Client VALUES(20,'Dollard Cash','Montréal','(888)888-8888')
    INTO Client VALUES(30,'Ye San Le Su', 'Montréal','(777)777-7777')
    select * from dual
/

INSERT ALL
    INTO Compte VALUES(100,1000.00,TO_DATE('5/05/1999','DD/MM/YYYY'),10)
    INTO Compte VALUES(200,2000.00,TO_DATE('10/10/1999','DD/MM/YYYY'),20)
    INTO Compte VALUES(300,1000.00,TO_DATE('10/10/1999','DD/MM/YYYY'),10)
    INTO Compte VALUES(400,5.00,TO_DATE('20/7/2000','DD/MM/YYYY'),30)
    INTO Compte VALUES(600,10.00,TO_DATE('15/10/2000','DD/MM/YYYY'),30)
    select * from dual
/

INSERT ALL
    INTO Pret VALUES(1000,10000.00,TO_DATE('10/6/2000','DD/MM/YYYY'),10,12,10)
    INTO Pret VALUES(2000,20000.00,TO_DATE('20/7/2000','DD/MM/YYYY'),12,52,30)
    INTO Pret VALUES(3000,5000.00,TO_DATE('15/8/2000','DD/MM/YYYY'),12,12,10)
    SELECT * FROM dual
/
    
select * from Client
/
select * from Compte
/
select * from Pret
/

INSERT INTO Client VALUES(10,'Jean Leconte','Montréal','(666)666-6666')
/

select noCompte, solde From Compte where noClient = 10
/

SELECT  nomClient, noCompte, solde
    FROM   Client, Compte
    WHERE  Client.noClient = Compte.noClient AND
       dateOuverture = TO_DATE('10/10/1999','DD/MM/YYYY')
/

UPDATE Compte SET solde = solde - 100 WHERE noCompte = 100
/
UPDATE Compte  SET solde = solde + 100  WHERE noCompte = 300
/

select noCompte, solde From Compte where noClient = 10
/

DELETE FROM Compte WHERE noCompte = 100
/

SELECT * FROM Compte
/

CREATE INDEX indexNoClientCompte ON Compte(noClient)
/


SELECT TABLE_NAME FROM USER_TABLES
/

SELECT COLUMN_NAME   FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'CLIENT'
/

SELECT TABLESPACE_NAME, EXTENTS, BLOCKS
    FROM USER_SEGMENTS
    WHERE SEGMENT_NAME = 'CLIENT'
/



