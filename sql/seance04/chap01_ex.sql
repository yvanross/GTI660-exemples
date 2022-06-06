--Chap1_ex.doc
--=================================================
--Chapter 1 Practical Exercises
--	This file contains a number of distinct SQL statements. As well as including the statements described in Chapter 1 of the textbook, it includes an exercise for you to check and revise your SQL expertise. 

-- Note that the statements can be pasted into the SQL editor following the instructions set out in the Introduction to the CD-ROM but you need to add a semicolon if you want to execute the statement immediately.	Alternatively the statements can be pasted into the SQL editor, saved and then, on exit from the editor, the statements can be executed with the RUN command. The character / is required as a terminator when using the editor.

--SQL*PLUS has a simple line editor to let you enter and edit the last command you entered. An alternative editor can be specified within SQL*PLUS:
--For Windows environments this could be

SQL> DEFINE_EDITOR = c:\windows\notepad.exe

For UNIX environments this could be

SQL> DEFINE_EDITOR = emacs

-Useful commands for SQL*PLUS include:

To run your last command type   	SQL>RUN

To save your last command type 	SQL> SAVE filename		

To retrieve a saved command type 	SQL> GET filename	

To execute a saved command type 	SQL> @ filename

SQL*PLUS saves the last command in the buffer to a file called afiedt.buf

=====================================================*/

CREATE TABLE part 	(
partno  	CHAR(3) NOT NULL,				
descrip		VARCHAR2(120),
cost		NUMBER(5,2),
qty		NUMBER)
/
INSERT INTO part 
VALUES ('101', 'Skirt', 15.00, 100)
/
INSERT INTO part
VALUES ('123', 'Italian Cashmere and wool body with leather sleeves - mens jacket', 73.45, 275)
/
SELECT 	partno, descrip, cost, qty
FROM 	part
WHERE 	descrip LIKE ('%wool%')
/
-- The purpose of the following exercise is for the reader to revise and assess their skills in SQL*PLUS. The following exercise requires you to create and populate a number of tables that can be joined together in various ways to display different information. Some of the tables are created with primary key constraints but a full discussion of primary and foreign keys is postponed until Chapter 4. The exercise illustrates how tables are created in a relational database and then joined through SQL queries. In the rest of the textbook we do not get involved with joins very much. */


1. Create the following tables in SQLPLUS selecting suitable primary keys.
A)	faculty	
COLUMNS	fac_id 	CHAR(3)
lecturer 	VARCHAR2(20)
department  VARCHAR2(10)
gender  	VARCHAR2(6)
salary 	NUMBER(6)

B)	course
COLUMNS	course_id   CHAR(6)
course_title VARCHAR2 (30) 
	
C)	grade
COLUMNS	stud_id  	CHAR(4)
test1 	NUMBER(3)
test2 	NUMBER(3)
test3 	NUMBER(3)
final_exam 	NUMBER(3))

D)	student
COLUMNS 	stud_id		CHAR(4)
		student_name	VARCHAR2(14)
		address		VARCHAR2(14)
		birthdate		DATE
		gender		VARCHAR2(6)

E)	grade_scale
COLUMNS 	low_value 	NUMBER(4,1)
high_value 	NUMBER(4,1)
grade 	CHAR(4)

B)	presentation
COLUMNS	course_id   CHAR(6)
semester 	NUMBER(1)
stud_id   	VARCHAR2(4)
fac_id   	VARCHAR2(3)
 
			
1.	Solution

CREATE TABLE faculty
(fac_id 	CHAR(3) PRIMARY KEY,
lecturer 	VARCHAR2(20),
department  VARCHAR2(10),
gender  	VARCHAR2(6),
salary 	NUMBER(6))
/
CREATE TABLE student
(stud_id  		CHAR(4)PRIMARY KEY,
student_name	VARCHAR2(14),
address		VARCHAR2(40),
birthdate		date,
gender		VARCHAR2(6))
/
CREATE TABLE course
(course_id   CHAR(6) PRIMARY KEY,
course_title VARCHAR2(30))
/
CREATE TABLE grade
(stud_id  	CHAR(4),
course_id   CHAR(6),
test1 	NUMBER(3),
test2 	NUMBER(3),
test3 	NUMBER(3),
final_exam 	NUMBER(3),
PRIMARY KEY (stud_id, course_id))
/
CREATE TABLE grade_scale
(
low_value 	NUMBER(4,1),
high_value 	NUMBER(4,1),
grade 	CHAR(1) PRIMARY KEY
)
/
CREATE TABLE presentation
(course_id   CHAR(6),
semester_no  NUMBER(1),
stud_id   	 VARCHAR2(4),
fac_id   	 VARCHAR2(3),
PRIMARY KEY (stud_id, course_id) )
/

2. ) Enter at least 4 records in all tables, selecting suitable codes and matching records in tables on the foreign keys.
									
Sample data
Faculty Table
Fac_id	Name			Department	Gender 	Salary
JO1		RAY JOHNSON		COMP SCI	MALE		20000
SO1		WENDY JUMPER	COMP SCI	FEMALE	23000
DO1		AMY DANCER		COMP SCI	FEMALE	28000
JO2		ROBERT JONES	ACCOUNTING	MALE		35000
NO1		JACK NELSON		HISTORY	MALE		28000

Student Table
Stud_id	name		address		date of birth	gender
S001	WENDY JONES		125 MAPLE AVE		25-OCT-75	FEMALE
S002	SAM WALES		16, NEW STREET		10-JAN-80	MALE
S003	ERROL BROWN		17, HIGH STREET		22-FEB-77	MALE
S004	CATHY SMITH		22, CHILTERN AVE		31-MAR-77	FEMALE
S005	JAY LANCER		2, NORTHERN AVE		1-MAR-77	FEMALE
S006	TRACY WILLIAMS	1, MANCHESTER STREET	1-JUN-77	FEMALE
S007	BEN TREVINO		17,NORTH STREET		22-AUG-77	MALE

Course Table
course_id  course_title 		
CSC100	INTRODUCTION TO COMPUTING	
CSC100	INTRODUCTION TO COMPUTING	
CSC200	JAVA PROGRAMMING			
CSC200	JAVA PROGRAMMING			
ACC200	PRINCIPLES OF ACCOUNTING	
ACC201	ADVANCED ACCOUNTING		
HIS200	HISTORY OF FILM		 	
CSC100	INTRODUCTION TO COMPUTING	
CSC100	INTRODUCTION TO COMPUTING	
CSC200	JAVA PROGRAMMING			
CSC200	JAVA PROGRAMMING			
ACC200	PRINCIPLES OF ACCOUNTING 	
ACC201	ADVANCED ACCOUNTING		
HIS200	HISTORY OF FILM 			


stud_id  	course_title 	test1 	test2 test3 final_exam
S001		JAVA PROGRAMMING 	98		95	93		92
S002		JAVA PROGRAMMING 	88		85	83		82
S003		JAVA PROGRAMMING 	78		85	93		72
S004		JAVA PROGRAMMING 	68		65	73		62
S005		JAVA PROGRAMMING 	58		55	53		42

presentation Table
course_id semester stud_id   	fac_id
CSC100		1		S001		JO1
CSC100		1		S002		SO1
CSC200		1		S003		SO1
CSC200		1		S001		DO1
ACC200		1		S001		JO2
ACC201		1		S004		JO2
HIS200		1		S005		NO1
CSC100		1		S001		JO1
CSC100		1		S002		SO1
CSC200		1		S003		SO1
CSC200		1		S001		DO1
ACC200		1		S001		JO2
ACC201		2		S004		JO2
HIS200		1		S005		NO1

2.	Solution

-- for the faculty table
INSERT INTO FACULTY VALUES
('JO1', 'RAY JOHNSON', 'COMP SCI','MALE',20000)
/
INSERT INTO FACULTY VALUES
('SO1', 'WENDY JUMPER', 'COMP SCI','FEMALE',23000)
/
INSERT INTO FACULTY VALUES
('DO1', 'AMY DANCER', 'COMP SCI','FEMALE',28000)
/
INSERT INTO FACULTY VALUES
('JO2', 'ROBERT JONES', 'ACCOUNTING','MALE',35000)
/
INSERT INTO FACULTY VALUES
('NO1', 'JACK NELSON', 'HISTORY','MALE',28000)
/
-- for the faculty table store the above statements into one SQL file
-- save the file with .SQL EXTENSION and then use @FILENAME to get and run the statements
-- vérification du language
SELECT
  value
FROM
  V$NLS_PARAMETERS
WHERE
  parameter = 'NLS_DATE_LANGUAGE';

-- s'assurer que le langage est american pour les date
ALTER SESSION SET NLS_DATE_LANGUAGE = 'AMERICAN';

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YY';
SELECT SYSDATE FROM DUAL;


  
-- for the student table
INSERT INTO student values
('S001','WENDY JONES','125 MAPLE AVE', TO_DATE('25-OCT-75'),'FEMALE')
/
INSERT INTO student values
('S002','SAM WALES','16 NEW STREET','10-JAN-70','MALE')
/
INSERT INTO student values
('S003','ERROL BROWN','17 HIGH STREET','22-FEB-77','MALE')
/
INSERT INTO student values
('S004','CATHY SMITH','22 CHILTERN AVE','31-MAR-77','FEMALE')
/
INSERT INTO student values
('S005','JAY LANCER','2 NORTHERN AVE','1-MAR-77','FEMALE')
/
INSERT INTO student values
('S006','TAMMY WILLIAMS','1 MANCHESTER STREET','1-JUN-77','FEMALE')
/
INSERT INTO student values
('S007','BEN TREVINO','17 NORTH STREET','22-AUG-77','MALE')
/ 
-- for the student table store the above statements into one SQL file
-- save the file and then use @ to get and run the statements

-- for the presentation table

INSERT INTO presentation VALUES
('CSC100' ,1,'S001','JO1')
/
INSERT INTO presentation VALUES
('CSC100' ,1,'S002','SO1')
/
INSERT INTO presentation VALUES
('CSC200' ,1,'S003','SO1')
/
INSERT INTO presentation VALUES
('CSC200',1,'S001','DO1')
/
INSERT INTO presentation VALUES
('ACC200' ,1,'S001','JO2')
/
INSERT INTO presentation VALUES
('ACC201', 1,'S004','JO2')
/
INSERT INTO presentation VALUES
('HIS200' ,1,'S005','NO1')
/
INSERT INTO presentation VALUES
('CSC100',1,'S001','JO1')
/
-- for the course table 

INSERT INTO course VALUES
('CSC100','INTRODUCTION TO COMPUTING')
/
INSERT INTO course VALUES
('CSC200','JAVA PROGRAMMING')
/
INSERT INTO course VALUES
('ACC200','PRINCIPLES OF ACCOUNTING')
/
INSERT INTO course VALUES
('ACC201', 'ADVANCED ACCOUNTING')
/
INSERT INTO course VALUES
('HIS200','HISTORY OF FILM')
/

-- for the grade_scale table
INSERT INTO GRADE_SCALE VALUES
(90.0,100.0,'A')
/
INSERT INTO GRADE_SCALE VALUES
(80.0,89.9,'B')
/
INSERT INTO GRADE_SCALE VALUES
(70.0,79.9,'C')
/
INSERT INTO GRADE_SCALE VALUES
(60.0,69.9,'D')
/
INSERT INTO GRADE_SCALE VALUES
(0.0,59.9,'F')
/
-- for the grade table
 INSERT INTO GRADE VALUES
('S001', 'CSC100',98,95,93,92)
/
INSERT INTO GRADE VALUES
('S002', 'CSC100',88,85,83,82)
/
INSERT INTO GRADE VALUES
('S003', 'CSC100',78,85,93,72)
/
INSERT INTO GRADE VALUES
('S004', 'CSC100',68,65,73,62)
/
INSERT INTO GRADE VALUES
('S005', 'CSC100',58,55,53,42)
/


3)	Write an SQL query which lists details of all the female students.


4)	Write an SQL query which lists all the lecturer’s names and faculty identifiers for the staff in the accounting department.

5)	Write an SQL query which lists the students’ surnames and their genders.


6)	Write an SQL query which displays the lecturer’s name together with the course titles they teach.	


7) 	Write an SQL script which displays the lecturer’s name together with the course titles they teach for the lecturer Ray Johnson.
									
8)  	Write an SQL script which displays the lecturer’s names in order and all the titles of the courses they do not teach.

9)	The students’ results are calculated by adding the marks of their tests to their final exam mark doubled. The resulting total is divided by 5 to give the result.	
10)	Write an SQL script which displays the student’s identifier together with their result and final grade.	

11) 	Write an SQL script which displays the lecturer’s names in order and the number of the course they teach.

12	Write an SQL script which displays the name of the lecturers who teach the most courses.


				
 
Query solutions									
SET PAUSE ON
/
--3. This query involves restriction
SELECT *
FROM student
WHERE gender = 'FEMALE'
/
--4. This query involves projection and restriction
SELECT LECTURER
FROM FACULTY
WHERE DEPARTMENT = 'ACCOUNTING'
/
--5. This query uses two string functions described in Chapter 5 nested togehter.
SELECT SUBSTR(student_name,INSTR(student_name,' '),14), gender
FROM student

--6. This query involves joining two tables.
SELECT lecturer, course_title
FROM faculty,course, presentation
WHERE faculty.fac_id = presentation.fac_id
AND presentation.course_id = course.course_id;

--7 This involves a join, projection and restriction.
SELECT lecturer, course_title
FROM faculty,course, presentation
WHERE faculty.fac_id = presentation.fac_id
AND presentation.course_id = course.course_id 
AND LECTURER ='RAY JOHNSON'

--8 This shows a non-equi join of two tables.
SELECT lecturer, course_title
FROM faculty,course, presentation
WHERE faculty.fac_id != presentation.fac_id
AND presentation.course_id = course.course_id
ORDER BY lecturer
/
--9. This shows how numbers can be manipulated and the resulting column renamed in Oracle – this does not use the AS keyword as in Standard SQL */
SELECT STUD_ID,
 (TEST1+TEST2+TEST3+(2*FINAL_EXAM))/5 RESULT
FROM GRADE
/
--10 This uses a theta join to obtain the grade corresponding to the result. Note also that the expression (TEST1+TEST2+TEST3+(2*FINAL_EXAM))/5 has been replaces by the word RESULT when the data is displayed */
SELECT STUD_ID, 
(TEST1+TEST2+TEST3+(2*FINAL_EXAM))/5 RESULT, GRADE
FROM GRADE, GRADE_SCALE
WHERE (TEST1+TEST2+TEST3+(2*FINAL_EXAM))/5
BETWEEN LOW_VALUE AND HIGH_VALUE
/

--11  TODO
select * from course;
select * from faculty;
select * from presentation;

SELECT lecturer, COUNT(course_title)
FROM faculty, course
WHERE faculty.fac_id = course.fac_id
GROUP BY lecturer
ORDER BY lecturer;



