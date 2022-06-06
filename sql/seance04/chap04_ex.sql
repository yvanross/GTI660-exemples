/*=================================================
Chapter 4 Practical Exercises
	This file contains a number of distinct SQL statements. When the statement is described in the textbook by name this is displayed below the statement on the right hand side of the screen. The names are not part of the SQL statement and they are simply comments to aid identification. 

 To locate a specific1 statement either scroll through the text or search for the name using FIND.

 Note that the statements can be pasted into the SQL editor following the instructions set out in the Introduction to the CD-ROM but you need to add a semicolon if you want to execute the statement immediately.					
=====================================================*/

DROP TABLE part;

CREATE TABLE part
(partno  	CHAR(4),				
descrip		VARCHAR2(120),
part_name    	VARCHAR2(25),
cost      		NUMBER(6,2),
PRIMARY KEY (part_number));


CREATE TABLE employee
(employee_number	CHAR(4),
employee_name	VARCHAR2(30),
salary		NUMBER(6,2),
start_date		DATE);

--									emp_table
CREATE TABLE department
(department_number	CHAR(4),
department_name	VARCHAR2(10 ),
PRIMARY KEY (department_number));

DROP TABLE department;

CREATE TABLE department
(department_number	CHAR(4) CONSTRAINT prim_dept PRIMARY KEY,
department_name	VARCHAR2(10 ));			

--									prim_dept

ALTER TABLE employee
	ADD (CONSTRAINT prim_emp PRIMARY KEY(employee_number));
--									prim_emp

ALTER TABLE employee
	ADD (department_number CHAR(4));
    
--								add_column


INSERT INTO department 
 VALUES ('1234', 'Computing');
 
INSERT INTO department 
VALUES ('3010', 'Accounts');

INSERT INTO employee
VALUES('1001', 'John Smith', null,'12-May-2001','1234');

INSERT INTO employee
VALUES('1002', 'Marie Jones', 650.00,'15-Jun-2001','1234');


ALTER TABLE employee 
ADD (CONSTRAINT emp_dep_fkey FOREIGN KEY(department_number) REFERENCES 
department(department_number))

--									add_referential


INSERT INTO employee
(employee_number, employee_name, salary, start_date, department_number)
VALUES ('7902', 'FORD', 175.66, '12-May-1991', '3010');

-- You will need to drop the table and create again to try this
ALTER TABLE employee ADD ( CONSTRAINT emp_dep_fkey FOREIGN 
KEY(department_number) REFERENCES 
department(department_number) ON DELETE CASCADE);

DROP TABLE wine_list;

CREATE TABLE wine_list
( 	wine_code	CHAR(6),
    wine_name 	VARCHAR2(30) NOT NULL,
	region 	VARCHAR2(20) NOT NULL,
	year 		NUMBER(4),
	category	VARCHAR2(20),
	grape		VARCHAR2(20),
	price		NUMBER(5,2),
	bottle_size	NUMBER(4),
	character	VARCHAR2(50),
	note		CLOB DEFAULT EMPTY_CLOB(),
	pronunciation	BLOB DEFAULT EMPTY_BLOB(),
	picture		BFILE, 
    CONSTRAINT prim_wine PRIMARY KEY (wine_code));

--									first_wine

/* the following code is for DB2

DROP TABLE wine_list;

-- TODO: must try to fix this script
CREATE TABLE wine_list
( 	wine_code	CHAR(6) NOT NULL,
    wine_name 	VARCHAR(30) NOT NULL,
    region 	VARCHAR(20) NOT NULL,
	year		NUM(4),
	category	VARCHAR(20),
	grape		VARCHAR(20),
	price		DECIMAL(5,2),
	bottle_size	NUM(4),
	character	VARCHAR(50),
	note		CLOB(5123),
	picture	BLOB(10240), CONSTRAINT prim_wine PRIMARY KEY (wine_code));*/

--									new_wine

INSERT INTO wine_list (wine_code ,wine_name, region, category, grape, price, character)
VALUES ('003401','Errazuriz','Chile','white','Chardonnay',9.95,
' Buttery palette, Dry, Ready, but will keep');


SELECT 	wine_name, price
FROM 	wine_list;					
--								select_wineprice



SELECT 	wine_name, price
FROM 		wine_list
WHERE 	region = 'Chile';
--								france_wineprice

SELECT 	wine_name, price
FROM 	wine_list
WHERE 	region = 'Chile'
ORDER BY 	price;
--								order_wineprice

delete from wine_list where wine_code = '43107B';
INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
VALUES ('43107B', 'Ch.Haut-Rian', 'Bordeaux',2000,'red',' Sauv-Blanc/Semillon',5.75,75,
' Light-Medium Bodied, Dry, Ready, but will keep');
--									wine_clob1
UPDATE wine_list
SET note = 'Ideal as an aperitif but would also go well with fish dishes'
WHERE wine_name ='Ch.Haut-Rian';

--								update_wine_clob1

--Solution to Exercise 4.4

INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
VALUES ('40484', 'Reisling Trimbach','Alsace',1996,'white','Reisling', 22.50, 75, 'Medium bodied dry ready but will improve');

delete from wine_list where wine_code = '41482B';
INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
VALUES ('41482B', 'Chablis Billaud-Simon','France',1999,'white','Chardonay', 9.45, 75, 'Light-Medium bodied dry ready but will improve');

-- end of solution 4.4

UPDATE wine_list
SET note = ' From the glorious 2000 vintage Haut-Rian Sec is a blend of 70% Sémillon and 30% Sauvignon Blanc.'
WHERE wine_name ='Ch.Haut-Rian';

SELECT 	wine_code, SUBSTR(wine_name,1,5)
FROM		wine_list;

CREATE OR REPLACE FUNCTION fun_sum (first INTEGER, second INTEGER)
RETURN NUMBER
AS
    result NUMBER;
BEGIN
    result := first + second;
    RETURN result;
END;

SELECT fun_sum(2,9) FROM dual;

CREATE OR REPLACE FUNCTION  wine_price (my_wine IN VARCHAR2)
RETURN NUMBER
AS
my_price NUMBER(5,2);
BEGIN
SELECT price INTO my_price
FROM wine_list
WHERE wine_name = my_wine;
RETURN my_price;
END;		
--							fun_wine_price

  SELECT wine_price('Ch.Haut-Rian')
 FROM wine_list;

SET SERVEROUTPUT ON;
SELECT fun_sum(2,9) from DUAL;



CREATE OR REPLACE PROCEDURE proc_price
(my_wine IN VARCHAR,
 my_price OUT NUMBER)
AS
BEGIN
 SELECT price
 INTO my_price
 FROM wine_list
 WHERE wine_name = my_wine;
END;
--								create_proc_price

-- you need to create the variable for the OUT parameter


VARIABLE new_price NUMBER;
EXECUTE proc_price ('Reisling Trimbach',:new_price);
set serveroutput on;
execute DBMS_OUTPUT.PUT_LINE('The price is ' ||  to_char(:new_price));

  
CREATE TABLE MESSAGES
(
NUMCOL1  NUMBER (9, 2),
 NUMCOL2  NUMBER (9, 2),
 CHARCOL1  VARCHAR2(60),
 CHARCOL2  VARCHAR2(60),
 DATECOL1  DATE,
 DATECOL2  DATE);

-- you cannot really execute this procedure get_wine_detail in SQLPLUS as the output includes LOBs
CREATE OR REPLACE PROCEDURE get_wine_detail
(wine_name IN wine_list.wine_name%TYPE,
wine_row OUT wine_list%ROWTYPE) AS
BEGIN
 SELECT * INTO wine_row
 FROM wine_list
 WHERE wine_name = wine_name;
END;

/* ne fonctionne pas
CREATE OR REPLACE example_proc ( 
	v_message 	char(10);
	v_prodno	number(6);
	v_review	boolean;
	v_items	number(4);

BEGIN
	v_message := 'This is it';
	v_items    := 1234;
END;

*/

-- to try the next procedure example you need to create some tables

CREATE TABLE wine_inventory
(wine_code CHAR(6),
 quantity  NUMBER(4));

INSERT INTO wine_inventory VALUES ('40484', 666);

CREATE TABLE wine_purchase
 (purchase VARCHAR(20),
  issue_date DATE);
  
  
--SELECT * FROM WINE_INVENTORY;
--SELECT * FROM WINE_PURCHASE;
--SELECT * FROM ERRORTABLE;
-- Erreur de compilation
CREATE OR REPLACE PROCEDURE example2_proc IS
qty_on_hand	wine_inventory.quantity%TYPE;
BEGIN
    SELECT quantity INTO qty_on_hand	
    FROM wine_inventory 	
    WHERE wine_code ='40484' ;
    IF qty_on_hand >0 THEN UPDATE wine_inventory
        SET quantity = quantity - 1
        WHERE wine_code ='40484' ;
    ELSE	
        INSERT INTO wine_purchase VALUES
         ('Out of product 40484', SYSDATE) ;
    END IF;		
    COMMIT;
EXCEPTION
    WHEN no_data_found   THEN
    INSERT INTO errortable
    VALUES ('wine_code 40484 NOT FOUND ');
END;


CREATE OR REPLACE PROCEDURE WINE_clob2a IS
   lob_loc  	CLOB; -- to hold lob locator
   reftext  	VARCHAR2(32767) := 'Bernard Billaud and his nephew Samuel produce benchmark ';
   amount   	NUMBER;
   offset   	INTEGER;
BEGIN
	SELECT note
	INTO Lob_loc
	FROM wine_list
	WHERE wine_name = 'Errazuriz' FOR update;

    	Offset	:= DBMS_LOB.GETLENGTH(Lob_loc)+2;
 	Amount	:= LENGTH(reftext);
	DBMS_LOB.WRITE(lob_loc,amount,offset,reftext);

   /* Read data: */
  /*  */
   	 INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 	VALUES (amount,offset,'CLOB data');
 	COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('COPY operation has some problems');
END;


CREATE OR REPLACE PROCEDURE WINE_clob2b IS
   Lob_loc  CLOB; -- TO HOLD LOB LOCATOR
   reftext  VARCHAR2(32767) := 'It is pure and aromatically fresh on the nose leading on to a crisp palate with hints of citrus fruits and gooseberries. Ideal as an aperitif but would also go well with fish dishes. ';
   amount   NUMBER;
   offset   INTEGER;
BEGIN
	SELECT note
	INTO Lob_loc
	FROM wine_list
	WHERE wine_name = 'Ch.Haut-Rian' FOR update;
    	Amount	:= LENGTH(reftext);
	DBMS_LOB.WRITEAPPEND(lob_loc,amount,reftext);
   /* Read data: */
  /*  */
    INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 	VALUES (amount,offset,'CLOB data');
 COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('COPY operation has some problems');
END;



-- pas réussi à compiler
CREATE OR REPLACE FUNCTION region_name (region_no CHAR)
RETURN VARCHAR AS
BEGIN
	CASE region_no
		WHEN '1' THEN RETURN 'Bordeaux';
		WHEN '2' THEN RETURN 'California';
		WHEN '3' THEN RETURN 'New Zealand';
		WHEN '4' THEN RETURN 'Alsace';
		ELSE RETURN NULL;
	END CASE;
END;
/
show errors

select region_name('1') from dual;
--

/* NE COMPILE PAS
VARIABLE return_code NUMBER;

BEGIN
	SELECT (WINE_PRICE12) - 0.05 
	into	:return_code
    FROM wine_list
	WHERE WINE_NAME ='MMM';
END;

PRINT return_code 
SET SERVEROUTPUT ON

BEGIN
	SELECT (WINE_PRICE*12) - 0.05 
	into	return_code
	WHERE WINE_NAME ='MMM';
dbms_OUTPUT.PUT_LINE(The price after discount is'||to_char(return_code));
END;
*/

-- fonction qui retourn un row
/* ne compile pas
CREATE OR REPLACE PROCECURE get_wine_detail (
    v_name IN wine_list.wine_name%TYPE,
    wine_row OUT wine_list%ROWTYPE
) 
AS BEGIN
	SELECT * INTO wine_row FROM wine_list WHERE wine_name = v_name;
END;
show errors
*/

/* ne compile pas

CREATE OR REPLACE example_proc ( qty_on_hand OUT 	NUMBER)
AS
BEGIN
	SELECT quantity INTO qty_on_hand	
			FROM inventory 	WHERE wine_code ='44010' ;
	IF qty_on_hand >0 THEN UPDATE wine_inventory
				SET quantity = quantity - 1
				WHERE wine_code ='44010' ;
		ELSE	
				INSERT INTO wine_purchase VALUES
				 ('Out of product 44010', SYSDATE) ;
		END IF;		
			COMMIT;
		EXCEPTION
			WHEN no_data_found   THEN
			INSET INTO errortable
			VALUES ('wine_code 44010 NOT FOUND ');
END;
*/

DROP TABLE grape;
CREATE TABLE grape 
( 	grape_name	VARCHAR2(30),
	grape_text	CLOB DEFAULT EMPTY_CLOB(),
	picture	BLOB DEFAULT EMPTY_BLOB(),
	CONSTRAINT prim_grape PRIMARY KEY (grape_name));



CREATE OR REPLACE PROCEDURE retrieve_lob IS
	Grape_pic 	BLOB;
BEGIN
	SELECT picture
	INTO 	grape_pic
	FROM 	grape
	WHERE 	grape_name = 'Chardonnay';
END;



UPDATE grape
SET grape_text = EMPTY_CLOB()
WHERE grape_name = 'Chardonnay';

DROP TABLE grape;

CREATE TABLE grape 
( 	grape_name	VARCHAR2(30),
	grape_text	CLOB,
	picture	BFILE,
	CONSTRAINT prim_grape PRIMARY KEY (grape_name));

-- as SYS user
CREATE DIRECTORY “PHOTO_DIR” AS 'C:\Images';

GRANT READ ON DIRECTORY “PHOTO_DIR” TO scott;

-- We can now use INSERT and UPDATE statements using the BFILENAME function.

INSERT INTO grape (grape_name, picture)
VALUES('Chardonnay', BFILENAME('PHOTO_DIR', 'chardonnay.jpg'))


UPDATE grape
SET picture = BFILENAME('PHOTO_DIR', 'chardonnay.jpg');

-- It is likely that we will want to create different directories for different kinds of media data as follows
CREATE DIRECTORY “AUDIO_DIR” AS 'C:\Audio';
GRANT READ ON DIRECTORY “AUDIO_DIR” TO scott;

CREATE DIRECTORY “FRAME_DIR” AS 'C:\Images';
GRANT READ ON DIRECTORY “FRAME_DIR” TO scott;

SELECT grape_name, DBMS_LOB.GETLENGTH(grape_text),  DBMS_LOB.SUBSTR(grape_text, 10,10)   
FROM grape;

--create procedure called wine_read_bfile
CREATE OR REPLACE PROCEDURE wine_read_bfile
IS
    Lob_loc       BFILE := BFILENAME('PHOTO_DIR', 'chardonnay.jpg');
    Amount        INTEGER := 32767;
    Position      INTEGER := 1;
    Buffer        RAW(32767);
BEGIN
    /* Open the BFILE: */
    DBMS_LOB.OPEN(Lob_loc, DBMS_LOB.LOB_READONLY);
    /* Read data: */
    DBMS_LOB.READ(Lob_loc, Amount, Position, Buffer);
    /* Close the BFILE: */
    DBMS_LOB.CLOSE(Lob_loc);
END;

--create procedure called wine_read_bfile

CREATE OR REPLACE PROCEDURE wine_read_bfile
IS
    Lob_loc       BFILE;
    Amount        INTEGER := 32767;
    Position      INTEGER := 1;
    Buffer        RAW(32767);
BEGIN
    /* Select the LOB: */
    SELECT picture INTO Lob_loc FROM grape
       WHERE grape_name = 'chardonnay';
    /* Open the BFILE: */
    DBMS_LOB.OPEN(Lob_loc, DBMS_LOB.LOB_READONLY);
    /* Read data: */
    DBMS_LOB.READ(Lob_loc, Amount, Position, Buffer);
    /* Close the BFILE: */
    DBMS_LOB.CLOSE(Lob_loc);
END;


--create procedure called grape_cloba

CREATE OR REPLACE PROCEDURE grape_cloba IS
   lob_loc  CLOB; -- TO HOLD LOB LOCATOR
   newtext  VARCHAR2(32767) := ' It is the mainstay of white wine production in California and Australia, is widely planted in Chile and South Africa, and is now the most widely planted grape in New Zealand.';
   amount 	NUMBER;
   offset  	INTEGER;
BEGIN
	SELECT grape_text
	INTO Lob_loc
	FROM grape
	WHERE grape_name = 'Chardonnay' FOR UPDATE;
    	OFFSET:= DBMS_LOB.GETLENGTH(Lob_loc)+2;
 	AMOUNT:= LENGTH(newtext);
	DBMS_LOB.WRITE(lob_loc,amount,offset,newtext);
   /* Read data: */
  /*  */
    INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 VALUES (amount,offset,'CLOB data');
 COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('COPY operation has some problems');
END;

EXECUTE wine_clob2a;

CREATE OR REPLACE PROCEDURE grape_clobb IS
   lob_loc  CLOB; -- TO HOLD LOB LOCATOR

   newtext  VARCHAR2(32767) := ' In warm climates Chardonnay has a tendency to develop very high sugar levels during the final stages of ripening and this can occur at the expense of acidity. Late picking is a common problem and can result in blowsy and flabby wines that lack structure and definition. Recently in the New World, we have seen a move towards more elegant, better- balanced and less oak-driven Chardonnays, and this is to be welcomed.';

   amount   NUMBER;
   offset   INTEGER;
BEGIN
	SELECT grape_text
	INTO Lob_loc
	FROM grape
	WHERE grape_name = 'Chadonnay' FOR UPDATE;
    	AMOUNT:= LENGTH(newtext);
	DBMS_LOB.WRITEAPPEND(lob_loc,amount,newtext);
   /* Read data: */
  /*  */
    INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 VALUES (amount,offset,'CLOB data');
 COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('write operation has some problems');
END;



DROP TABLE grape;
CREATE TABLE grape 
( 	grape_name	VARCHAR2(30),
	grape_text	CLOB,
	picture	BLOB,
	CONSTRAINT prim_grape PRIMARY KEY (grape_name));

DROP TABLE grape;

CREATE TABLE grape 
( 	grape_name	VARCHAR2(30),
	grape_text	CLOB,
	picture	BFILE,
	CONSTRAINT prim_grape PRIMARY KEY (grape_name));

-- SOLUTION 4.4

INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
VALUES('41482B', 'Chablis Billaud-Simon', 'Burgundy', 1999 , 'White', 'Chardonnay', 9.45, 75, 'Light-medium bodied dry ready but will improve');

INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
VALUES
 ('40484B', 'Reisling Trimbach', 'Alsace', 1996, 'White', 'Reisling',22.50, 75, 'Medium bodied dry ready but will improve');

CREATE OR REPLACE PROCEDURE exercise45_proc
AS
   v_bool1         BOOLEAN;
   v_bool2         BOOLEAN;
   v_char          VARCHAR2 (20) := '42 is the answer';
   v_num           NUMBER;
BEGIN
   v_num           := TO_NUMBER(SUBSTR(v_char,1,2));
   IF v_num < 100 THEN
           v_bool1 :=TRUE;
           v_bool2 :=FALSE;
   ELSE
           v_bool1 :=FALSE;
           v_bool2 :=TRUE;
   END IF;
   INSERT INTO messages (CHARCOL1, NUMCOL1)
   VALUES ( v_char, v_num);
END;
