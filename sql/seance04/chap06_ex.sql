--Chapter 6 Practical Exercises - Gestion des contraintes

DROP TABLE department;

CREATE TABLE department
(department_number	CHAR(4) CONSTRAINT prim_dept PRIMARY KEY,
department_name	VARCHAR2(10 ))

insert into department values ('1234','dept1');

DROP TABLE employee;

CREATE TABLE employee
(employee_number	CHAR(4),
employee_name	VARCHAR2(30),
salary		NUMBER(6,2),
start_date		DATE,	
department_number CHAR(4) CONSTRAINT emp_dep_fkey NOT NULL REFERENCES department,
CONSTRAINT prim_emp PRIMARY KEY(employee_number));

-- liste des containte associés à la table employee
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEE';

-- if departement does not exist, we cannot add employe
INSERT INTO employee
(employee_number, employee_name, salary, department_number)
VALUES ('7902', 'FORD', 17.56,'1234');
show errors;

-- ORA-02291: violation de contrainte d'intégrité (EQUIPE235.SYS_C00469083) - clé parent introuvable
UPDATE employee
SET department_number = '3010'
WHERE employee_number = '7902';

-- ORA-02291: violation de contrainte d'intégrité (EQUIPE235.SYS_C00469083) - clé parent introuvable
UPDATE department
SET department_number  = '2010'
WHERE department_number ='1234';
-- about statement should fail because of the integrity constraint

DROP TYPE person_t;

CREATE TYPE person_t;
-- incomplete object type

DROP TYPE person_t;

CREATE TYPE person_t AS OBJECT
( first_name 	CHAR(20),
 second_name CHAR(20),
d_o_b         	DATE)						

--									person_t

DESCRIBE person_t;

DROP TYPE employee_t;

CREATE TYPE employee_t AS OBJECT
(employee_number CHAR(4),
employee_detail person_t,
salary   NUMBER(6,2),
start_date  DATE,
skills CLOB,
picture BLOB)
								
-- example of a complete type					employee_t

DESCRIBE employee_t;

CREATE TYPE line_t AS OBJECT
( wine_code 		CHAR(6),
  quantity 		number(2))						
--									line_type

CREATE TABLE line_table OF line_t;

--									line_table

-- insert person_t
describe person_t;
CREATE TABLE person_table OF person_t;
INSERT INTO person_table VALUES (person_t ('JANICE', 'FORD','03-May-1981'));
SELECT SYSDATE FROM DUAL;
ALTER SESSION SET NLS_DATE_LANGUAGE = 'AMERICAN';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';
SELECT SYSDATE FROM DUAL;
INSERT INTO person_table VALUES (person_t ('JANICE', 'FORD','03-May-1981'));

-- s'assurer que le langage est american pour les date


SELECT SECOND_NAME  
FROM person_table;

SELECT REF(P)
FROM person_table P 
WHERE SECOND_NAME = 'FORD';


drop table wine_reserved;
CREATE TABLE wine_reserved
(wine_code   CHAR(6),
customer_id  REF person_t);
 
DESCRIBE wine_reserved;
 

INSERT INTO wine_reserved
SELECT '40484B',
REF(P)
FROM person_table P
WHERE SECOND_NAME = 'FORD';

SELECT * FROM wine_reserved;

SELECT DEREF(W.customer_id)
FROM wine_reserved W
WHERE wine_code = '40484B'

SELECT DEREF(W.customer_id)
FROM wine_reserved W
WHERE wine_code = '40484B'
--the parameter for the DEREF function is the column name of the REF column not the table name*/


SELECT rowid FROM employee;

CREATE TYPE contact_t AS VARRAY(3)  OF VARCHAR2(15);
DESCRIBE contact_t;

CREATE TYPE line_items AS VARRAY(12)  OF line_t;

CREATE TYPE wine_size AS OBJECT (
	bottle_type 	VARCHAR2(15),
	price 		NUMBER(5,2) );

CREATE TYPE sizes AS VARRAY(5) OF 	wine_size;

CREATE TYPE lineitem_list  AS TABLE OF line_t;
-- We can now create an order type
CREATE TYPE wine_order AS OBJECT
(	order_id		CHAR(6),
customer		person_t,
orderline		lineitem_list,
order_total		NUMBER(6,2),
MEMBER FUNCTION
Get_total	RETURN NUMBER);

/
select * from wine_order;
DROP TABLE wine_order;
CREATE TABLE wine_order 
(	order_id		CHAR(6) PRIMARY KEY,
customer		person_t,
orderlines		lineitem_list);

NESTED TABLE orderlines STORE AS lineitem_list_tab

DROP TABLE wine_order;

CREATE   TYPE wine_order_t AS OBJECT
(	order_id		CHAR(6),
	customer		person_t,
	orderitems		lineitem_list,
	order_total		NUMBER(6,2),
		MEMBER FUNCTION
		Get_total	RETURN NUMBER);

-- you can experiment with adding the following constraints
CREATE TABLE wine_order_table OF wine_order_t
 (CONSTRAINT prim_wine_order PRIMARY KEY (order_id));
 
DROP TABLE wine_order_table;

CREATE TABLE wine_order_table OF wine_order_T
NESTED TABLE orderitems STORE AS lineitem_list_table;

DROP TABLE wine_order_table;
CREATE TABLE wine_order_table OF wine_order_t
 (CONSTRAINT prim_wine_order PRIMARY KEY (order_id))
NESTED TABLE orderitems STORE AS lineitem_list_table;

drop table employee;
CREATE TABLE employee
(		employee_number		CHAR(4),
		employee_detail		person_t,
	   salary			NUMBER(6,2) );

CREATE TYPE pronounciation_t AS OBJECT
 ( originator  VARCHAR2(30),
 text   VARCHAR2(50),
 speaker  VARCHAR2(30),
 take_date  DATE,
 recording  BLOB);

CREATE TYPE map_t AS OBJECT
(	region 		VARCHAR2(20),
	nw		NUMBER,
	ne		NUMBER,
	sw		NUMBER,
	se		NUMBER,
	drawing		BLOB,
	aerial		BFILE);

CREATE TYPE map_tab AS TABLE OF map_t;

-- you will need to drop wine_list to create it again with object 
-- types or just change the table name
drop table wine_list;
CREATE TABLE wine_list
(  wine_code CHAR(6),
wine_name  VARCHAR2(30) NOT NULL,
 year  NUMBER(4),
 category VARCHAR2(20),
 grape  VARCHAR2(20),
 price  NUMBER(5,2),
 bottles  sizes,
 character VARCHAR2(50),
 note  CLOB DEFAULT EMPTY_CLOB(),
 pronounce pronounciation_t,
 picture BFILE,
 region_map map_tab
 ) NESTED TABLE region_map STORE AS map_nested_tab;

-- display info about user types
SELECT type_name, type_oid, typecode, attributes 
FROM user_types

CREATE TYPE two AS OBJECT(
num1  NUMBER(2), 
num2 NUMBER (2)); 
--									type_two

CREATE TABLE three 
(x1 	NUMBER(1),
 x2 	two);	

describe three;
describe two;
 
--									type_three

INSERT INTO three VALUES (1, two(2,3));		
--									insert_three

-- show how to extract num1 and num2 from two.
select x1,T.x2.num1,T.X2.num2
from three T;


DROP TABLE wine_customer;

CREATE TABLE wine_customer
( customer_id  CHAR(4),
customer  person_t,
 contact_detail contact_t);


INSERT INTO wine_customer(customer, contact_detail)
VALUES ( person_t ('John', 'Smith', '17-Mar-1972'), contact_t() );

INSERT INTO wine_customer
VALUES ( '1234',person_t ('Shailey', 'Patel', '17-May-1975'),
contact_t('077891234', '441189234508','01567891234') )

CREATE TYPE line AS OBJECT
( 	item CHAR(8),
	price  NUMBER(5,2),
  	quantity number(2));							
--										line_type	 

CREATE TYPE artist_list AS TABLE OF person_t				
--										artist_list
CREATE TABLE song_list
(songid		CHAR(6),
 title		VARCHAR2(30),
 artists		artist_list)
NESTED TABLE artists STORE AS artist_list_tab;
--										song_list
INSERT INTO song_list VALUES
('100123', 'The times are changing',
artist_list(
    person_t ('John', 'Smith', '17-Mar-1972'),
    person_t ('Mary', 'Jones', '23-Jun-1966'),
    person_t ('Viki', 'Williams', '6-May-1982')
));

INSERT INTO line_table 
VALUES	 ( '040316', 8 );

UPDATE wine_customer
SET  customer =  person_t('Sunila', 'Patel', '17-Mar-1972')
WHERE customer_id ='1234';

SELECT customer_id, W.customer.first_name, W.customer.second_name
FROM  wine_customer W
WHERE W.customer.first_name LIKE 'P%';

select * from person_table;
INSERT INTO wine_reserved
SELECT '43107B',
REF(P)
FROM person_table P
WHERE FIRST_NAME = 'JANICE';


SELECT REF(A)
FROM line_table A
WHERE wine_code = '00456b';

SELECT DEREF (customer_id)
FROM wine_reserved
WHERE wine_code = '43107B';

describe line_table;
INSERT INTO line_table 
VALUES ( '003401', 2 )

--we can query this table in a SELECT statement

SELECT VALUE(p) FROM line_table p
        WHERE p.wine_code = '003401';
        
SELECT * FROM line_table;

CREATE TYPE dept_t AS OBJECT
(department_number	CHAR(4),
department_name	VARCHAR2(10 ));


CREATE OR REPLACE VIEW dept_OV(dept) AS
SELECT dept_t(department_number, department_name)
FROM department;

CREATE OR REPLACE VIEW dept_view OF dept_t
WITH OBJECT OID(department_number) AS
SELECT A.department_number, A.department_name
FROM department A;

DESCRIBE  dept_view;
select * from dept_view;

--SEE DETAILS OF Oracle intermedia attributes 
--in the file of that name

drop type pronounciation_t;
CREATE TYPE pronounciation_t AS OBJECT
	( originator 	VARCHAR2(30),
	text 		VARCHAR2(50),
	speaker		VARCHAR2(30),
	record_date		DATE,
	audioSource	ORDSYS.ORDAUDIO);

DROP TABLE employee;
/
CREATE TABLE employee
(employee_number		CHAR(4),
employee_name		VARCHAR2(30),
salary			NUMBER(6,2),
d_o_b				DATE,							
employee_picture   	ORDSYS.ORDIMAGE);
--									NEW_emp_table

DROP TABLE employee;

CREATE TABLE employee
(employee_number	CHAR(4),
employee_name	VARCHAR2(30),
salary		NUMBER(6,2),
d_o_b			DATE,							
employee_picture   ORDSYS.ORDIMAGE,
badge			ORDSYS.ORDIMAGE);


INSERT INTO employee
VALUES
('7990', 'John Smith', 2400.78, '15-May-1979', 
ORDSYS.ORDIMAGE(ORDSYS.ORDSOURCE(EMPTY_BLOB() , 'FILE', 'PHOTO_DIR', 'Smith.gif', SYSDATE,0), 
NULL, NULL, NULL, NULL, NULL, NULL,NULL));


DECLARE
	Image_1 		ORDSYS.ORDIMAGE;
    Image _2		ORDSYS.ORDIMAGE;
BEGIN
	SELECT employee_name, employee_picture
	INTO 	   image_1, image_2
FROM employee
WHERE employee_name = 'John Smith' FOR UPDATE; 
	--CONVERT THE IMAGE TO A THUMBNAIL AND STORE IN IMAGE_2
IMAGE_1.PROCESSCOPY('fileFormat=TIFF  fixedScale=32 32', image_2);
UPDATE employee SET employee_picture = image_1 
WHERE employee_name ='John Smith';
END;

INSERT INTO employee
VALUES
('7990', 'John Smith', 24000, '15-May-1979', 
ORDSYS.ORDIMAGE(ORDSYS.ORDSOURCE(EMPTY_BLOB() , 'FILE', 'PHOTO_DIR', 'Smith.gif', SYSDATE,0) , NULL, NULL, 
NULL, NULL, NULL, NULL,NULL),
ORDSYS.ORDIMAGE(ORDSYS.ORDSOURCE(EMPTY_BLOB() , NULL, NULL, NULL, SYSDATE,1), NULL, NULL, NULL, NULL, NULL, NULL,NULL));


DECLARE
	Image ORDSYS.ORDIMAGE
BEGIN 	
INSERT INTO employee
VALUES
('7990', 'John Smith', 24000, '15-May-1979', 
ORDSYS.ORDIMAGE ORDSYS.ORDIMAGE(ORDSYS.ORDSOURCE(EMPTY_BLOB() , 'FILE', 'PHOTO_DIR', 'Smith.gif', SYSDATE,0) , NULL, NULL, 
NULL, NULL, NULL, NULL,NULL)),
(ORDSYS.ORDSOURCE (EMPTY_BLOB() , NULL, NULL, NULL, SYSDATE,1), NULL, NULL, NULL, NULL, NULL, NULL, NULL) NULL)
	SELECT employee_name, employee_picture
	INTO 	   image
FROM employee
WHERE employee_name = 'John Smith' FOR UPDATE; 
	
IMAGE.SETPROPERTIES;
	DBMS_OUTPUT.PUTLINE('image width = '|| image.getWidth()
	DBMS_OUTPUT.PUTLINE('image height = '|| image.getHeight()
DBMS_OUTPUT.PUTLINE('image size = '|| image.getContentLength()
DBMS_OUTPUT.PUTLINE('image file type = ‘|| image.getFileFormat()
DBMS_OUTPUT.PUTLINE('image type = '|| image.getContentFormat()
DBMS_OUTPUT.PUTLINE('image compression = '|| 

image.getCompressionFormat()
DBMS_OUTPUT.PUTLINE('image mime type = '|| image.getMimeType()
UPDATE employee SET employee_picture = image 
WHERE employee_name ='John Smith';
END;


CREATE TYPE customer_t AS OBJECT
(customer_id  CHAR(4),
cutomer_details    person_t,
MAP MEMBER FUNCTION retn_value RETURN CHAR);


CREATE OR REPLACE TYPE BODY customer_t AS 
MAP MEMBER FUNCTION retn_value RETURN CHAR IS
BEGIN
	RETURN customer_id ;
END;
END;


-- this is called wine_order_t2 because it may be difficult to drop wine_order_t because dependencies have been created

CREATE OR REPLACE TYPE wine_order_t2 AS OBJECT
( order_id  CHAR(6),
 customer person_t,
 lineitems lineitem_list,
 order_total NUMBER(6,2),
ORDER MEMBER FUNCTION
Wine_total (x IN wine_order_t2)
RETURN INTEGER);


drop type wine_order_t2;

/* do not compile
CREATE OR REPLACE TYPE BODY wine_order_t2 AS 
ORDER MEMBER FUNCTION 
Wine_total (x IN wine_order_t2) RETURN INTEGER IS
BEGIN
RETURN order_total - x.wine_total;
END;
END;
*/
-- this is called line2t2 because it may be difficult to drop line because dependencies have been created


CREATE OR REPLACE TYPE person_name AS OBJECT
( personal_name varchar2(20),
  family_name varchar2(20));

CREATE OR REPLACE TYPE new_employee AS OBJECT
( name person_name,
  dateofbirth DATE,
  MEMBER FUNCTION age(e in new_employee) return number,
  MEMBER FUNCTION e_name(e in new_employee) return varchar2,
  PRAGMA RESTRICT_REFERENCES(age,WNDS),
  PRAGMA RESTRICT_REFERENCES(e_name,WNDS)  );



show errors;











