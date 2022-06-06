--Chapter 2 Practical Exercises

DROP TABLE grape;
CREATE TABLE grape
(grape_name 		VARCHAR2(25) PRIMARY KEY,
picture			BFILE );

-- the following commands must be executed by user  SYSTEM to create a directory and to grant user scott read s to the directory

CREATE DIRECTORY "PHOTO_DIR" AS 'C:\PICTURES';

GRANT READ ON DIRECTORY PHOTO_DIR TO scott

INSERT INTO grape (grape_name, picture)
VALUES
('chardonnay', 
BFILENAME('PHOTO_DIR','chardonnay.jpeg'))
/

Solution Exercise 2.1

-- DBMSLOB package must be available for this exercise. This involves SYS user running the following files

@dbmslob  -- execute le fichier dbmslob.sql

@catproc  -- execute le fichier catproc.sql

GRANT EXECUTE ON dbms_lob TO equipe235;

--(a)	Create a table called staff in Oracle SQLPLUS.
CREATE TABLE staff
( staff_number 		CHAR(4) PRIMARY KEY,
 staff_name		VARCHAR2(25) NOT NULL,
region		CHAR(1),
image_file		VARCHAR2(80),
picture		BFILE);

- (b)
INSERT INTO staff (staff_number, staff_name, region, image_file)
VALUES ('1002', 'John Mullins','3','c:\pictures\john.bmp');

-- check the insert with the following 
SELECT  staff_number,staff_name, region, image_file
FROM staff;

-- (c) The naming convention for DIRECTORY objects is the same as that for tables and indexes. That is, normal identifiers are assumed to be uppercase, but when identifiers are delimited by double quotes they are interpreted as actually entered. For example, the following statement: 

-- CREATE DIRECTORY "PHOTO_DIR" AS 'C:\PICTURES';

-- creates a directory object whose name is PHOTO_DIR (in uppercase). But when a delimited identifier is used for the DIRECTORY name using mixed case, as shown in the following statement 

CREATE DIRECTORY "Mary_Dir" AS '/usr/home/mary';

-- the directory object's name would be 'Mary_Dir'. We can use PHOTO_DIR ' and 'Mary_Dir' as parameters when calling the BFILENAME() function; for example: 

BFILENAME('SCOTT_DIR', 'afile')

BFILENAME('Mary_Dir', 'afile')

-- Note that the result depends on the operating system, with WindowsNT, for example, the directory names are case-insensitive. Therefore the following two statements refer to the same directory: 

CREATE DIRECTORY "big_cap_dir" AS "g:\data\source";

CREATE DIRECTORY "small_cap_dir" AS "G:\DATA\SOURCE";

-- Before completing the insert for the staff table we must log in as SYS and type

CREATE DIRECTORY "PHOTO_DIR" AS 'C:\PICTURES';

-- The user scott also needs to given access to the directory by SYS

GRANT READ ON DIRECTORY PHOTO_DIR TO equipe235;

-- Sample image files are provided in the CD-ROM directory called images. These can be copied into your named directory object for use with the SQL statements that follow.


-- (d) remove the previously inserted row
DELETE FROM staff;

INSERT INTO staff VALUES
('1002', 'John Mullins','3','c:\pictures\john.jpg',
BFILENAME('PHOTO_DIR','john.jpg'))

-- However this does not check the 'john.jpg' file exists in the directory or if the directory exists as an object therefore you should always check by using LOB functions and procedures that the multimedia objects have been inserted in the database */
-- (e)	Update an existing row of the staff table to include a binary file. This can also be achieved by BFILENAME function. 

UPDATE staff
SET picture =BFILENAME('PHOTO_DIR','john.jpg')
WHERE staff_name='John Mullins';
select * from staff;

-- Once the directory has been set up we can use the following insert (remember to delete the previous row)

INSERT INTO staff 
VALUES
('1002', 'John Mullins','3', 'c:\pictures\john.jpg',BFILENAME('PHOTO_DIR','john.jpg'));

-- It would also be possible to update an existing row as follows

UPDATE staff
SET picture =BFILENAME('PHOTO_DIR','john.bmp')
WHERE staff_name='John Mullins';


-- Note that we cannot use BLOB columns in SELECT statements so the follow statement cannot be executed –
select * from staff;

SELECT 	staff_number, staff_name, region, picture
FROM 		staff
WHERE 	staff_number = '1002';

-- We also cannot be convinced these inserts and updates have taken place until we check the tables in the way shown in Chapter 4 as follows
SELECT DBMS_LOB.GETLENGTH(picture) FROM staff;

-- Additional insertions to add more multimedia files to the staff table

INSERT INTO staff 
VALUES
('1003', 'Frank ','3', 'c:\pictures\frank.jpg',
   BFILENAME('PHOTO_DIR','frank.gif'));

INSERT INTO staff
VALUES
('1004', 'Marie Jones','3', 'c:\pictures\marie.tif',BFILENAME('PHOTO_DIR','marie.tif'));

--==========================================================


