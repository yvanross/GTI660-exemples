--Chapter 11 Practical Exercises

-- In the examples in this set of exercises tables and objects have been specified using the CLOB or BLOB data type in order to keep the procedural code simple. The data type available in ORDSYS (see Appendix F) could have been used which would also allow use of the ORDSYS methods . */

--	The Sewage Information System

CREATE TABLE technician (
technician_number 	CHAR(4) PRIMARY KEY,
technician_detail 	person_t,
skill_level 		NUMBER(1)
)
-- inserting Technician rows
INSERT INTO technician (technician_number, technician_detail, skill_level)
VALUES ( '3451', person_t ('JANICE', 'FORD','03-May-1981'), 3)
/
INSERT INTO technician (technician_number, technician_detail, skill_level)
VALUES ( '3452', person_t ('FRANK', 'WEST','03-May-1971'), 5)
/
INSERT INTO technician (technician_number, technician_detail, skill_level)
VALUES ( '3453', person_t ('SUNILA', 'PATEL','13-Sep-1965'), 5)
/
INSERT INTO technician (technician_number, technician_detail, skill_level)
VALUES ( '3454', person_t ('ROBERT ', ' MROZEK ','29-Oct-1963'), 4)
/
-- before we can create a table for the protozoa information we need to deal with the --multivalued attributes by creating user-defined types.

CREATE TYPE anteria_truncated AS VARRAY(3)  OF VARCHAR2(15);
show errors;

CREATE TYPE anteria_direction AS VARRAY(2)  OF VARCHAR2(10);

CREATE TYPE somatic_cilia	AS VARRAY(5)  OF VARCHAR2(15);

CREATE TYPE habit	AS VARRAY(6)  OF VARCHAR2(12);

-- now create the protozoa table using user-defined types
DROP TABLE protozoa;
/
CREATE TABLE protozoa
( protozoa_name VARCHAR2(40) PRIMARY KEY,
family_name  VARCHAR2(40) NOT NULL,
biological_name VARCHAR2(40),
anteria_trunc anteria_truncated,
anteria_d  anteria_direction,
anteria_b  VARCHAR2(1),
cilia   VARCHAR2(1),
vacuole  NUMBER(2),
somatic_cil  somatic_cilia,
protozoa_habit  habit,
lorica   VARCHAR2(15),
bodystalk  VARCHAR2(15),
remark2 CLOB DEFAULT EMPTY_CLOB(),
picture  BLOB DEFAULT EMPTY_BLOB(),
video  BFILE )
/
-- create a table to hold the results of the tests for the samples

CREATE TABLE sample
( 
sample_no 		CHAR(8) PRIMARY KEY,
protozoa_name 	VARCHAR2(25) REFERENCES protozoa,
works_name 		VARCHAR2(25) NOT NULL,
location		VARCHAR2(25),
plant			VARCHAR2(50),
technician_number	CHAR(4) REFERENCES technician,
description		CLOB DEFAULT EMPTY_CLOB()
 )
/
INSERT INTO protozoa
(protozoa_name, family_name, remark2)
values
('acineria_uncinata', 
'acineria',
'Free swimmers are usually found when no large flocs have been formed. They generally swim faster than flagellates and are generally more efficient feeders.')
/
--Load an image into a BLOB using a procedure
-- TODO: must grant acces to create directory
CREATE OR REPLACE PROCEDURE prot_blob_proc IS
            lob_loc      BLOB; -- TO HOLD LOB LOCATOR
    amount    BINARY_integer:= 32767;--MAX VALUE FOR PL/SQL
    buffer  RAW(32767);
            image   VARCHAR2(40) :=  'acineria_uncinata.jpg';
    temp_lob BFILE := BFILENAME('PHOTO_DIR', 'acineria_uncinata.jpg');
 BEGIN
    /* Select the LOB: */
    SELECT picture INTO Lob_loc FROM protozoa
            WHERE protozoa_name = 'acineria_uncinata'
            FOR update;
    /* Read data: */
    /* Open the BFILE: */
     DBMS_LOB.FILEOPEN(temp_lob, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADFROMFILE(lob_loc,temp_lob,amount);
    INSERT INTO MESSAGES (NUMCOL1,CHARCOL1)
    VALUES (amount,'Protozoa LOB added');
    COMMIT;
    dbms_lob.filecloseall;
 EXCEPTION
     when no_data_found
     then dbms_output.put_line('protozoa write operation has some problems');
 END;
/

//===========




