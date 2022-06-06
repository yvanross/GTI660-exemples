--Chapter 10 Practical Exercises
-- to deal with text documents we need to create a directory object
-- In the examples in this set of exercises tables and objects have been specified using the CLOB or BLOB data type in order to keep the procedural code simple. The data type available in ORDSYS (see Appendix F) could have been used which would also allow use of the ORDSYS methods . */
CREATE DIRECTORY "TEXT_DOCUMENTS" AS 'C:\TEXT_DOCUMENTS'
/
GRANT READ ON DIRECTORY TEXT_DOCUMENTS TO SCOTT
/
drop table t_employee;
/
CREATE TABLE t_employee
(employee_number CHAR(4),
employee_name VARCHAR2(30),
salary   NUMBER(6,2),
start_date  DATE,
department_number CHAR(4) NOT NULL REFERENCES department(department_number),
CONSTRAINT prim_t_emp PRIMARY KEY(employee_number)
)
/
INSERT INTO t_employee
(employee_number, employee_name, salary, start_date, department_number)
VALUES ('7902', 'FORD', 175.66, '12-May-1991', '1234')
/
INSERT INTO t_employee
(employee_number, employee_name, salary, start_date, department_number)
VALUES
('7903', 'John Smith', null,'12-May-2001','1234')
/

INSERT INTO t_employee
(employee_number, employee_name, salary, start_date, department_number)
VALUES
('7904', 'Marie Jones', 650.00,'15-Jun-2001','1234')
/

SELECT employee_number, employee_name, department_number 
FROM t_employee
/
ALTER TABLE t_employee
	ADD (cv CLOB DEFAULT EMPTY_CLOB())	
/
--									                  add_cv
select * from t_employee;
/
    
--											initial_cv
UPDATE t_employee
SET cv = 'An excellent employee with a good range of professional qualifications'
WHERE employee_number = '7904'
/
--											update_cv
--UPDATE t_employee
--SET cv = EMPTY_CLOB()
--WHERE employee_number = '7904'
--/
--                                              clear cv

-- must have access to text_documents directory first...  asked to tech
CREATE OR REPLACE PROCEDURE load_cv
(my_employee_number t_employee.employee_number%TYPE,
  my_file_extension VARCHAR2 DEFAULT '.doc' )
AS
    v_document   	BFILE;
    v_cv   		employee.cv%TYPE;
BEGIN
  v_document  :=BFILENAME('TEXT_DOCUMENTS', 'my_employee_number'|| '.'||'my_file_extension');
 IF DBMS_LOB.FILEEXISTS(v_document) =1 THEN
   SELECT  cv
   INTO  v_cv
   FROM  employee
   WHERE employee_number = my_employee_number
   FOR UPDATE;
   DBMS_LOB.OPEN(v_document, DBMS_LOB.LOB_READONLY);
   DBMS_LOB.LOADFROMFILE(v_cv, v_document,DBMS_LOB.GETLENGTH(v_document) );
   DBMS_LOB.CLOSE(v_document);
 END IF;
EXCEPTION
 	WHEN OTHERS THEN
  	IF DBMS_LOB.ISOPEN(v_document)=1 THEN
 	DBMS_LOB.CLOSE(v_document);
 END IF;
END
/
-- A FILE CALLED 7903.DOC MUST EXIST IN THE TEXT_DIRECTORY
EXECUTE load_cv('7903');
-- note these are just word documents not actual CV’s
SELECT employee_number, DBMS_LOB.GETLENGTH(cv)
FROM t_employee
/



select table_name,num_rows from dba_tables where owner = 'EQUIPE235' order by num_rows desc
/

select * from student

--										in_query
SELECT student_name, SOUNDEX(student_name) 
FROM student
WHERE SOUNDEX (student_name) = SOUNDEX ('WNdi Jones')
/
--									sounding
 
drop table wine_list
/
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
    
INSERT INTO wine_list (wine_code ,wine_name, region, category, grape, price, character)
    VALUES ('003401','Errazuriz','Chile','white','Chardonnay',9.95,'Buttery palette, Dry, Ready, but will keep');
INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
    VALUES ('43107B', 'Ch.Haut-Rian', 'Bordeaux',2000,'red',' Sauv-Blanc/Semillon',5.75,75,'Light-Medium Bodied, Dry, Ready, but will keep');
INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
    VALUES ('40484', 'Reisling Trimbach','Alsace',1996,'white','Reisling', 22.50, 75, 'Medium bodied dry ready but will improve');
INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
    VALUES ('41482B', 'Chablis Billaud-Simon','France',1999,'white','Chardonay', 9.45, 75, 'Light-Medium bodied dry ready but will improve');
INSERT INTO wine_list (wine_code, wine_name, region, year, category, grape, price, bottle_size, character)
    VALUES ('40484B', 'Reisling Trimbach', 'Alsace', 1996, 'White', 'Reisling',22.50, 75, 'Medium bodied dry ready but will improve');

UPDATE wine_list
SET note = 'Ideal as an aperitif but would also go well with fish dishes'
WHERE wine_code ='003401';

UPDATE wine_list
SET note = ' From the glorious 2000 vintage Haut-Rian Sec is a blend of 70% Sémillon and 30% Sauvignon Blanc.'
WHERE wine_name ='Ch.Haut-Rian';

UPDATE wine_list
SET note = 'bonjour mon coco ce vin comporte poise, elegance and balance'
WHERE wine_code ='43107B';

update wine_list set note = 'contains citrus fruits and gooseberries' where wine_code = '40484B';

SELECT * FROM wine_list;
--									position
-- the next query should fail because of inconsistent datatypes
SELECT DISTINCT category
FROM wine_list
WHERE note LIKE '%Ideal as an aperitif%'
/
SELECT DISTINCT category
FROM wine_list
WHERE DBMS_LOB.INSTR(note, 'Ideal as an aperitif')>0
/
SELECT wine_name, SUBSTR(wine_name,1,3)
FROM wine_list
/
--								substring
SELECT wine_name, character,
SUBSTR(character, INSTR(character, 'Medium Bodied'),300) AS cut_out
FROM wine_list	
/
--							cut_out
SELECT note,DBMS_LOB.SUBSTR(note,10,5) cut_out
FROM wine_list
/
--									cut_out_LOB
SELECT wine_name,note, 
DBMS_LOB.SUBSTR(note, 80,DBMS_LOB.INSTR(note, 'citrus fruits and gooseberries')) cut_out
FROM wine_list
WHERE DBMS_LOB.INSTR(note, 'citrus fruits and gooseberries')>0
/
--											cut_out_clob
SELECT wine_name,DBMS_LOB.GETLENGTH(note)
 FROM  wine_list
/
SELECT *
FROM wine_list
WHERE note IS NULL 	-- is null on blob is not working, verify blog length
/
--											is_null

SELECT wine_name
FROM wine_list
WHERE picture IS NULL 
/
SELECT wine_name,pronunciation
 FROM wine_list
 WHERE pronunciation is not null	
/			
--											isnt_null
--
--SELECT 	wine_name
--FROM 	wine_list
--WHERE CONTAINS (note, 'HASPATH(/Media/Documents)' )>0
drop index index_note;

CREATE INDEX index_note ON
wine_list(note)
INDEXTYPE IS ctxsys.context
/


SELECT wine_code
FROM wine_list
WHERE CONTAINS (note, 'aperitif')>0  -- column note must be indexed
/

select * from t_employee
/
CREATE INDEX index_cv ON
t_employee(cv)
INDEXTYPE IS ctxsys.context
/
SELECT cv,SCORE(1) 
FROM t_employee 
WHERE CONTAINS(cv, 'professional', 1) > 0

--SELECT SCORE(10)
--from wine_list
--WHERE CONTAINS(note, 'aperitif)', 10) > 0;

--SELECT wine_code, note
--FROM wine_list
--WHERE CONTAINS (note, 'aperitif' AND 'medium')>0
--
--SELECT wine_code
--FROM wine_list
--WHERE CONTAINS (note, 'aperitif ACCUM medium')>0
--SELECT wine_name
--FROM wine_list
--WHERE CONTAINS (note, 'ABOUT(fruit)') >0
--SELECT score(1), wine_name
--FROM wine_list
--WHERE CONTAINS (note, 'vintage NEAR Sauvignon', 1)>1
--ORDER BY score(1) DESC
--EXEC ctx_ddl.sync_index()
--EXEC ctx_ddl.sync_index( ‘text_idx’,’2M’, ‘part_one’ )
--/

CREATE TABLE queries
(	username 	VARCHAR2(10),
	query_string	VARCHAR2(80) )
/
INSERT INTO queries
VALUES ('JSMITH', 'text indexing')
/
select * from queries
/
CREATE INDEX queryx ON queries(query_string)
INDEXTYPE IS CTXSYS.CTXRULE
/
-- CTXSYS.CTXRULE must use matches for search
SELECT username, query_string
FROM queries
WHERE MATCHES (query_string, :note_text)>0  -- only exact text work
/

describe check_cv2;
/
-- TODO: this script fail must fix
CREATE OR REPLACE PROCEDURE check_cv2
( my_employee_number employee.employee_number%TYPE)
AS
   v_document   BFILE;
   v_cv   employee.cv%TYPE;
   lob_loc  CLOB; -- TO HOLD LOB LOCATOR
   v_amount   NUMBER;
    cv_amount   INTEGER;
BEGIN
  v_document  :=BFILENAME('TEXT_DOCUMENTS', 'my_employee_number'|| '.'||'my_file_extension');
 IF DBMS_LOB.FILEEXISTS(v_document) =1 THEN
   v_amount := DBMS_LOB.GETLENGTH(v_document);
   SELECT  cv
   INTO  lob_loc
   FROM  employee
   WHERE employee_number = my_employee_number;
   DBMS_LOB.OPEN(v_document, DBMS_LOB.LOB_READONLY);
   cv_amount := DBMS_LOB.GETLENGTH(Lob_loc);
   DBMS_LOB.CLOSE(v_document);
 INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 VALUES (v_amount,cv_amount,'compare BLOB data');
 COMMIT;
 DBMS_LOB.CLOSE(v_document);
  END IF;
 EXCEPTION
 WHEN OTHERS THEN
  IF DBMS_LOB.ISOPEN(v_document)=1 THEN
 DBMS_LOB.CLOSE(v_document);
 END IF;
END;
/

EXECUTE check_cv2('1002');
/
SELECT wine_name
FROM wine_list
WHERE  character LIKE ('%bod%')
/
SELECT wine_name
FROM wine_list
WHERE  character LIKE ('%body%') OR character LIKE ('%bodied%')
/
select * from wine_list;
SELECT 	wine_name
FROM 		wine_list
WHERE 	INSTR(character, 'Medium bodied') >0
/
drop procedure CHECK_CV2;
/
select * from t_employee;
/
show errors;

SELECT 	employee_number,cv
FROM 		t_employee
WHERE 	DBMS_LOB.INSTR (cv, 'range') >0
/

-- TODO: grant acces to directory
CREATE OR REPLACE PROCEDURE load_cv
(my_employee_number employee.employee_number%TYPE,
  my_file_extension VARCHAR2 DEFAULT '.doc' )
AS
 v_document   BFILE;
 v_cv   employee.cv%TYPE;
BEGIN
  v_document  :=BFILENAME('TEXT_DOCUMENTS', 'my_employee_number'|| '.'||'my_file_extension');
 IF DBMS_LOB.FILEEXISTS(v_document) =1 THEN
   SELECT  cv
   INTO  v_cv
   FROM  employee
   WHERE employee_number = my_employee_number
   FOR UPDATE;
   DBMS_LOB.OPEN(v_document, DBMS_LOB.LOB_READONLY);
DBMS_LOB.LOADFROMFILE(v_cv, v_document,DBMS_LOB.GETLENGTH(v_document) );
   DBMS_LOB.CLOSE(v_document);
 END IF;
EXCEPTION
 WHEN OTHERS THEN
  IF DBMS_LOB.ISOPEN(v_document)=1 THEN
 DBMS_LOB.CLOSE(v_document);
 END IF;
END;
/
EXECUTE load_cv('1002','doc');
CREATE OR REPLACE PROCEDURE load_cv3
AS
 	v_document   BFILE;
 	lob_loc  BLOB; -- TO HOLD LOB LOCATOR
	amount   NUMBER;
   	OFFSET   INTEGER;

BEGIN
  	v_document  :=BFILENAME('TEXT_DOCUMENTS','1234.doc');
   	SELECT  cv
   	INTO  lob_loc  
   	FROM  employee2
   	WHERE employee_number = my_employee_number
   	FOR UPDATE;
   	DBMS_LOB.OPEN(v_document, DBMS_LOB.LOB_READONLY);
   	OFFSET:= DBMS_LOB.GETLENGTH(Lob_loc)+2;
	amount := DBMS_LOB.GETLENGTH(v_document);
	DBMS_LOB.LOADFROMFILE(lob_loc,v_document,DBMS_LOB.GETLENGTH(v_document), OFFSET );
   	DBMS_LOB.CLOSE(v_document);
	INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 	VALUES (amount,offset,'BLOB data');
 COMMIT;

 END IF;
EXCEPTION
 WHEN OTHERS THEN
  IF DBMS_LOB.ISOPEN(v_document)=1 THEN
 DBMS_LOB.CLOSE(v_document);
 END IF;
END;
/
CREATE OR REPLACE PROCEDURE check_cv2
( my_employee_number employee.employee_number%TYPE)
AS
   v_document   BFILE;
   v_cv   employee.cv%TYPE;
   lob_loc  BLOB; -- TO HOLD LOB LOCATOR
   v_amount   NUMBER;
    cv_amount   INTEGER;
BEGIN
  v_document  :=BFILENAME('TEXT_DOCUMENTS', 'my_employee_number'|| '.'||'my_file_extension');
 IF DBMS_LOB.FILEEXISTS(v_document) =1 THEN
   v_amount := DBMS_LOB.GETLENGTH(v_document);
   SELECT  cv
   INTO  lob_loc
   FROM  employee
   WHERE employee_number = my_employee_number;
   DBMS_LOB.OPEN(v_document, DBMS_LOB.LOB_READONLY);
   cv_amount := DBMS_LOB.GETLENGTH(Lob_loc);
   DBMS_LOB.CLOSE(v_document);
 INSERT INTO MESSAGES (numcol1, numcol2,charcol1)
 VALUES (v_amount,cv_amount,'compare BLOB data');
 COMMIT;
 DBMS_LOB.CLOSE(v_document);
  END IF;
 EXCEPTION
 WHEN OTHERS THEN
  IF DBMS_LOB.ISOPEN(v_document)=1 THEN
 DBMS_LOB.CLOSE(v_document);
 END IF;
END;
/
EXECUTE check_cv2('1002');

CREATE OR REPLACE PROCEDURE check_cv3
( my_employee_number employee2.employee_number%TYPE)
AS
v_cv   employee2.cv%TYPE;
BEGIN
   --SET SERVEROUTPUT ON
   SELECT  cv
   INTO  v_cv
   FROM  employee2
   WHERE employee_number = my_employee_number;
--DBMS_OUTPUT.PUTLINE('* CLOB is :'||dbms_lob.getlength(v_cv));
INSERT INTO MESSAGES (charcol1)
 VALUES ('* CLOB is :'||dbms_lob.getlength(v_cv));
END;
/
SELECT DBMS_PROFILER.START_PROFILER('test_1')
FROM dual

EXECUTE  C:\Ora8i\plsql\DEMO\profsum.sql

SELECT DBMS_PROFILER.START_PROFILER('test_2')
FROM dual

EXECUTE scott.load_cv('1002','doc');

SELECT DBMS_PROFILER.STOP_PROFILER
FROM dual

SELECT RUNID,RUN_DATE,RUN_TOTAL_TIME
FROM plsql_profiler_runs;

SELECT unit_type,total_time
 FROM plsql_profiler_units;

SELECT UNIT_NUMBER,LINE#,TOTAL_OCCUR,MIN_TIME,MAX_TIME,TOTAL_TIME
 FROM plsql_profiler_data;
/========

CREATE OR REPLACE PROCEDURE clob2 IS
   Lob_loc      CLOB; -- TO HOLD LOB LOCATOR
   reftext 	VARCHAR2(32767) := 'The British bird survey says they can live anywhere';
   amount	NUMBER;
   OFFSET      INTEGER;
BEGIN
   /* Select the LOB: */
   	SELECT text
	INTO Lob_loc
	FROM publications
      	WHERE id = 1008 FOR update;
   /*offset and amount parameters always refer to characters in CLOBS  */
	
   	OFFSET:= DBMS_LOB.GETLENGTH(Lob_loc)+2;
	AMOUNT:= LENGTH(reftext);
   /* Read data: */

  /* 	*/
  
   	INSERT INTO MESSAGES VALUES (amount,'CLOB data','',offset);
	COMMIT;
EXCEPTION
    when no_data_found
    then dbms_output.put_line('COPY operation has some problems');
END;
/

--CREATE OR REPLACE PROCEDURE copyLOB_proc IS
--lob_loc		CLOB;
--clobs 		CLOB;
--dest_offset	INTEGER := 1;
--source_offset	INTEGER := 1;
--amount 	INTEGER := 3000;
--BEGIN
--
--/* Select the CLOB, get the destination LOB locator: */
--//================
--
--
--/--==========
--CREATE TABLE publications
--(id NUMBER(4) PRIMARY KEY,
--first_author VARCHAR2(20) NOT NULL,
--other_authors VARCHAR2(80),
--author_email	VARCHAR2(40),
--keywords	VARCHAR2(80),
--title		VARCHAR2(120),
--journal		VARCHAR2(20),
--year		NUMBER(4)NOT NULL,
--source		CHAR(6),
--abstract	VARCHAR2(400),
--text		CLOB,
--paper		BFILE)
--/
--
--CREATE OR REPLACE PROCEDURE displayCLOB_proc IS
--Lob_loc CLOB;
--Buffer RAW(1024);
--Amount BINARY_INTEGER := 1024;
--Position INTEGER := 1;
--BEGIN
-- /* Select the LOB: */
--SELECT text INTO Lob_loc
--FROM publications p WHERE ID = 1008;
-- /* Opening the LOB is optional: */
--DBMS_LOB.OPEN (Lob_loc, DBMS_LOB.LOB_READONLY);
--LOOP
--DBMS_LOB.READ (Lob_loc, Amount, Position, Buffer);
--/* Display the buffer contents: */
--Position := Position + Amount;
--END LOOP;
--/* Closing the LOB is mandatory if you have opened it: */
--DBMS_LOB.CLOSE (Lob_loc);
--EXCEPTION
--WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('End of data');
--END;
--
---- todo: m
--select * from publications;
--/
--
--SELECT text INTO lob_loc
--FROM publications WHERE ID = 1010 FOR UPDATE;
--
--SELECT text INTO clobs
--FROM publications WHERE ID = 1009;
--
--DBMS_LOB.COPY(lob_loc, clobs, amount, dest_offset,source_offset);	
--
--INSERT INTO messages
--VALUES (
--	dest_offset,
--	'COPY OK ',' ',
--	source_offset);
--COMMIT;
--
--END;
--/

