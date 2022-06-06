-- définition de vos propre type de données
CREATE OR REPLACE TYPE adresse_t AS OBJECT
(norue 		INTEGER,
rue 			VARCHAR2(50),
cite 			VARCHAR2(30),
ville 		VARCHAR2(30),
province 		VARCHAR2(30),
code_postal 	CHAR(6));

CREATE OR REPLACE TYPE person_t AS OBJECT
(id 			INTEGER,
nom 			VARCHAR2(30),
prenom 		VARCHAR2(30),
date_nais 		DATE,
sexe			CHAR(1),
tel			INTEGER,
mail			VARCHAR2(30),
adresse 		adresse_t) NOT FINAL;

CREATE OR REPLACE TYPE multimedia_t AS OBJECT
(path_name 	VARCHAR2(500)) NOT FINAL;

--
CREATE OR REPLACE TYPE multimedia_table AS TABLE OF multimedia_t;

---audio
CREATE OR REPLACE TYPE codec_t AS OBJECT
(id		INTEGER,
 type	CHAR(1),
 nom	VARCHAR2(255));

CREATE OR REPLACE TYPE audio_t UNDER multimedia_t
(num_audio 	INTEGER,
freq_echant 	FLOAT,
bit_echant 	INTEGER,
nb_ca 		INTEGER,
audio		BLOB,
codec 		REF codec_t,
duree		FLOAT(126))
FINAL;

-- video
CREATE OR REPLACE TYPE video_t under multimedia_t
(num_video	INTEGER,
taille 		FLOAT,
nb_bits_p 	INTEGER,
format 		VARCHAR2(20),
video 		BLOB,
codec		REF codec_t,
duree		FLOAT(126),
freq_echant	FLOAT(126)) FINAL;

select * from user_types;
select * from user_source;


-- diapo 23 exemple de fonction
CREATE OR REPLACE FUNCTION normale (x NUMBER) 
	RETURN NUMBER
	AS result NUMBER;
BEGIN
	result := exp(-x**2);
	RETURN result;           
END;


SELECT normale(1) FROM DUAL;
SELECT normale(2) FROM DUAL;


-- diapo 26 tranfert d'une valeur de colonne d,un select
drop Commande3;
create table Commande3(noCommande integer, dateCommande date, noClient integer);
insert into Commande3 values(50,to_date('09/05-2005','DD/MM-YYYY'),64598);

insert into Commande3 values(51,to_date('10/05-2005','DD/MM-YYYY'),24538);
select * from Commande3;

-- diapo 27 if then end if
set serveroutput on;
DECLARE
    leNoCommande integer := 51;
    leNoClient integer;
    laDateCommande date;
BEGIN
    SELECT		noClient, dateCommande
	INTO		leNoClient, laDateCommande
	FROM		Commande3
    WHERE		noCommande = leNoCommande;
    
    dbms_output.Put_line(leNoCommande); --display
    dbms_output.Put_line(leNoClient); --display
    dbms_output.Put_line(laDateCommande); --display

    IF leNoClient = '24538' then
        dbms_output.Put_line('It work'); --display    
    else
        dbms_output.Put_line('It do not work'); --display
    end if;
END;

-- diapo 28

begin
    for i in 1..100 loop
        dbms_output.Put_line(i);
    end loop;
end;
    
    
-- diapo 30
select * from commande3;

set serveroutput on;
DECLARE
    leNoCommande integer;
    laDateCommande date;
    leNoClient integer;
    CURSOR lignesCommande(unNoCommande Commande.noCommande%TYPE) is 
        SELECT * FROM commande3;
    -- where commande3.xxx = unNoCommande
BEGIN
    open lignesCommande(10);
    LOOP 
        fetch lignesCommande into leNoCommande,laDateCommande,leNoClient;        
        exit when lignesCommande%NOTFOUND;
        dbms_output.Put_line(leNoCommande);
        dbms_output.Put_line(laDateCommande);
        dbms_output.Put_line(leNoClient);
        dbms_output.Put_line('--------------------------'); --display    
    END LOOP;
    close lignesCommande;
END;
--SHOW ERRORS;


-- diapo 37

create or replace procedure delete_commande3 is
begin
    delete from Commande3;
    --message := 'allo mon coco';
end;


set serveroutput on;
execute delete_commande3;
select * from commande3;


-- Diapo 38
CREATE OR REPLACE PROCEDURE pNouveauNom
(unNoMus IN integer, leNom OUT varchar) IS
BEGIN
  leNom := TO_CHAR(unNoMus) + '+++';
END pNouveauNom;g

set serveroutput on;
DECLARE 
    result varchar2(10);
BEGIN
    execute pNouveauNom(1,result);
    dbms_output.Put_line(result);
END;


-- diapo 78 read bfile
CREATE DIRECTORY "PHOTO_DIR" AS '~/photos';  --  privilèges insuffisants

CREATE OR REPLACE PROCEDURE read_bfile
IS
    Lob_loc       BFILE := BFILENAME('PHOTO_DIR', '242894827_577510796816476_6568756763166349389_n.jpg');
    Amount        INTEGER := 32767;
    Position      INTEGER := 1;
    Buffer        RAW(32767);

BEGIN
   DBMS_LOB.OPEN(Lob_loc, /*Open BFILE:*/	DBMS_LOB.LOB_READONLY);
    
   DBMS_LOB.READ(Lob_loc, /*Read data:*/ 		Amount, Position, Buffer);

   DBMS_LOB.CLOSE(Lob_loc);/*Close BFILE:*/
 END;


-- A essayer input from user keyboard
DECLARE
  a NUMBER;
  b NUMBER;
BEGIN
  a := &aa; --this will take input from user
  b := &bb;
  DBMS_OUTPUT.PUT_LINE('a = '|| a);
  DBMS_OUTPUT.PUT_LINE('b = '|| b);
END;

-- 


--- TP#2
INSERT INTO table1 ( column1, column2, someInt, someVarChar )
SELECT  table2.column1, table2.column2, 8, 'some string etc.'
FROM    table2
WHERE   table2.ID = 7;