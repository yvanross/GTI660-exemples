--Chapter 8 Practical Exercises

--SYSTEM TABLES
--to do these exercises you need to be connected as user sys 
-- the first exercises use the system tables

DESCRIBE dba_tables
/
SELECT owner,table_name, tablespace_name, cluster_name,iot_name
FROM dba_tables
WHERE OWNER LIKE 'EQUIPE%'
/
SELECT OWNER, CONSTRAINT_NAME,  CONSTRAINT_TYPE,  TABLE_NAME 
FROM USER_CONSTRAINTS
where OWNER like 'EQUIPE%'
/

SELECT OWNER, CONSTRAINT_NAME,  CONSTRAINT_TYPE,  TABLE_NAME 
FROM USER_CONSTRAINTS
/

SELECT owner, table_name, tablespace_name
 FROM dba_tables
 WHERE owner <> 'SYS'
/
SELECT owner, table_name, tablespace_name
 FROM dba_tables
 WHERE owner like 'EQUIPE%'
/
 SELECT table_name,owner,tablespace_name
 FROM dba_tables
WHERE owner NOT IN ('sys', 'system')
/
SELECT tsname, substr(fname,1,40)
FROM sysfiles
/
SELECT SUBSTR(OWNER,1,10),SUBSTR(INDEX_NAME,1,10),
SUBSTR(INDEX_TYPE,1,10),
SUBSTR(TABLE_OWNER,1,10),SUBSTR(TABLE_NAME,1,10),SUBSTR(TABLESPACE_NAME,1,20)
 FROM DBA_INDEXES
 WHERE OWNER <> 'SYS'
/
SELECT OWNER,
INDEX_NAME,INDEX_TYPE,TABLE_OWNER,TABLE_NAME,
TABLESPACE_NAME 
FROM DBA_INDEXES
WHERE owner like 'EQUIPE%'
/
SELECT SUBSTR(FILE_NAME,1,15), SUBSTR(FILE_ID,1,10),
SUBSTR(TABLESPACE_NAME,1,15)
FROM DBA_DATA_FILES
/
select * from DBA_DATA_FILES where file_name like '%Equipe%';
/
SELECT SUBSTR(OWNER,1,10),OBJECT_NAME,OBJECT_TYPE,CREATED,STATUS
 FROM DBA_OBJECTS
 WHERE  owner like 'EQUIPE%';
/
SELECT owner, TABLE_NAME, COLUMN_NAME, SUBSTR(DATA_TYPE,1,10), DATA_TYPE_MOD, AVG_COL_LEN    
FROM DBA_TAB_COLUMNS
WHERE OWNER like 'EQUIPE%'
/
SELECT owner, constraint_name,table_name,column_name,position
FROM dba_cons_columns
WHERE owner like 'EQUIPE%'
/
DESCRIBE dba_indexes
/
--describe user$;
--SELECT user#, name,password
--FROM user$;
/
DESCRIBE user_lobs
/
select * from user_lobs;
--MY LOB AND OBJECT DETAILS

--SELECT obj#,col#,block#,chunk,pctversion$,file#
--FROM lob$;
/
SELECT username, user_id, password, profile
FROM dba_users;

SELECT table_owner, index_name, index_type, table_name
FROM user_indexes;
/
SELECT * from dictionary
WHERE table_name like 'i%'
/
--SELECT file#,maxextend,ownerinstance
--FROM file$
/

--SELECT user#, password, password_date
--FROM user_history$
/
--SELECT user#,name,type#,datats#
--FROM user$
/
--DESCRIBE oid$
--/
--SELECT * FROM oid$
/
--SELECT 	o.user#,o.oid$,l.obj#,l.col#
-- FROM 	oid$ o, lob$ l
--WHERE 	o.obj#=l.obj#;
/
--SELECT toid, method#, name, parameters#,results
--FROM method$
/
SELECT View_name, text_length, text
FROM user_views WHERE VIEW_TYPE_OWNER LIKE 'EQUIPE%'
/
select * FROM USER_VIEWS;

-- PERFORMANCE ISSUES

--Execute the following SQL statements and then check the SQL pool area
select * from student;

UPDATE EQUIPE235.student
SET  student_name =  'yvan Ross'
WHERE stud_id ='S005'
/

--describe  v$sqlarea
--select *  FROM v$sqlarea
SELECT sql_text
FROM v$sqlarea
WHERE lower(sql_text) LIKE ('%'||'&text'||'%')			
/									
/									show_pool



--GRANT ANALYZE ANY TO scott
--/
--CREATE INDEX wine_name_x
--ON scott.wine_list
--(wine_name ASC)
--NOLOGGING
--PCTFREE 80
--/
--ANALYZE INDEX scott.wine_name_x COMPUTE STATISTICS
--/
--ANALYZE INDEX wine_name_x ESTIMATE STATISTICS SAMPLE 20 PERCENT
--/
--ANALYZE TABLE scott.wine_list ESTIMATE STATISTICS
--/
--ALTER SESSION SET OPTIMIZER _GOAL =CHOOSE;
--/
--SELECT num_rows, blocks, empty_blocks, avg_row_len, chain_cnt
--FROM user_tables
--WHERE table_name = 'scott.wine_list'
--/

-- the next statements use the plan_table which is created by running --the script utlxplan.sql

DESCRIBE plan_table
/
CREATE TABLE plan_table
   (statement_id     VARCHAR2(30),
    timestamp        DATE,
    remarks          VARCHAR2(80),
    operation        VARCHAR2(30),
    options          VARCHAR2(30),
    object_node      VARCHAR2(128),
    object_owner     VARCHAR2(30),
    object_name      VARCHAR2(30),
    object_instance  NUMERIC,
    object_type      VARCHAR2(30),
    optimizer        VARCHAR2(255),
    search_columns   NUMERIC,
    id               NUMERIC,
    parent_id        NUMERIC,
    position         NUMERIC,
    cost             NUMERIC,
    cardinality      NUMERIC,
    bytes            NUMERIC,
    other_tag        VARCHAR2(255),
    other            LONG)
/
EXPLAIN PLAN SET STATEMENT_id = ‘Wine_1’
FOR
SELECT  	wine_name, price  
FROM 		wine_list  
WHERE  	region = 'Chile'
/

EXPLAIN PLAN SET STATEMENT_id = 'STUDENT'
FOR select * from student
WHERE STUD_ID = 'S004';

SELECT * FROM PLAN_TABLE;

--GRANT ALL ON plan_table TO SCOTT;
/
SELECT DECODE(id,0,operation||'    Cost = '||position,
LPAD(' ',2*(LEVEL-1)||LEVEL||'.'||POSITION)||' '||
OPERATION||' '||OPTIONS||' '||OBJECT_NAME||' ' ||OBJECT_TYPE) QUERY_PLAN
FROM plan_table							
/
--										plan_table

--EXPLAIN PLAN 
--FOR
--SELECT employee_number,employee_name, start_date, department_name
--FROM employee, department
--WHERE employee.department_number = department.department_number
/
EXPLAIN PLAN set STATEMENT_ID = 'wineList'
FOR
SELECT DISTINCT category
FROM wine_list
WHERE DBMS_LOB.INSTR(note, 'Ideal as an aperitif')>0
/
SELECT * FROM PLAN_TABLE
/

ALTER SESSION SET TIMED_STATISTICS =TRUE
/
ALTER SESSION SET SQL_TRACE= TRUE
/

-- The next set of statements change the tablespaces and should be --treated with caution and only executed with care. It can be --difficult to remove tablespaces.

--CREATE TABLESPACE users DATAFILE 'D:/oradata/users_01.dbf'
--SIZE 2M EXTENT MANAGEMENT LOCAL AUTOALLOCATE
/
--CREATE TABLESPACE media DATAFILE 'D:/oradata/media_01.dbf'
--SIZE 1M EXTENT MANAGEMENT LOCAL AUTOALLOCATE
/
drop table employee
/
CREATE TABLE employee
(employee_number	CHAR(4),
employee_name	VARCHAR2(30),
salary		NUMBER(6,2),
start_date		DATE,
CONSTRAINT prim_emp PRIMARY KEY(employee_number)
USING INDEX
PCTFREE  2
STORAGE  (INITIAL 1M MAXEXTENTS UNLIMITED PCTINCREASE 0)	
	TABLESPACE users)
/
DESCRIBE dba_tablespaces;
/
SELECT tablespace_name, initial_extent,pct_increase,
max_extents, status
FROM dba_tablespaces
/
DROP TABLE wine_list
--/
--CREATE TABLE wine_list
--( 	wine_code	CHAR(6),
--wine_name 	VARCHAR2(30) NOT NULL,
--	region 	VARCHAR2(20) NOT NULL,
--	year 		NUMBER(4),
--	category	VARCHAR2(20),
--	grape		VARCHAR2(20),
--	price		NUMBER(5,2),
--	bottle_size	NUMBER(4),
--	character	VARCHAR2(50),
--	note		CLOB DEFAULT EMPTY_CLOB(),
--	pronunciation	BLOB DEFAULT EMPTY_BLOB(),
--	picture		BFILE, 
--CONSTRAINT prim_wine PRIMARY KEY (wine_code))
--LOB(note, pronunciation ) STORE AS
--(TABLESPACE media 
--STORAGE  (INITIAL 100K NEXT 100K PCTINCREASE 0)
--DISABLE STORAGE IN ROW
--CHUNK 16K PCTVERSION 10 NOCHACHE LOGGING);
--/
--ALTER USER username (identified by password) DEFAULT TABLESPACE TABLESPACENAME
/
--other useful data on indexes
--DROP TABLESPACE users;
/
--DROP TABLESPACE users INCLUDING CONTENTS CASCADE CONSTRAINTS;
/
CREATE INDEX wine_name_x
ON wine_list
(wine_name ASC)
NOLOGGING
PCTFREE 80;
DESCRIBE INDEX_HISTOGRAM I
--statistics on keys with repeat count
DESCRIBE INDEX_STATS
--statistics on the b-tree
SELECT * FROM INDEX_STATS
/
--
--
--//SERVICE MANAGER. 
--
--//In a Windows environment this would involve:
--
--C:> SVRMGRL
--CONNECT SYSTEM/MANAGER
--SHOW PARAMETERS
--SHOW SGA
--EXIT
--
--GO TO MSDOS PROMPT
--C:> SVRMGRL
--CONNECT SYSTEM/MANAGER
--CREATE USER P08 IDENTIFIED BY P08
--GRANT DBA TO P08
--EXIT
--
--//====================
--
--ALTER TABLE employee
--	ADD (cv CLOB DEFAULT EMPTY_CLOB())
--/
--ALTER TABLE employee
-- ADD (cv2 CLOB DEFAULT EMPTY_CLOB())
-- LOB (cv2 ) STORE AS cv_segment
--   (TABLESPACE media
-- STORAGE (INITIAL 2K NEXT 2K PCTINCREASE 0)
-- CHUNK 2K NOCACHE NOLOGGING ENABLE STORAGE IN ROW)
--/
--SELECT NAME, SQL_TEXT 
--FROM USER_OUTLINES 
--WHERE CATEGORY='mycat'
--/
--CREATE OUTLINE wine_out
--FOR CATEGORY development
--ON
--SELECT 	wine_name, price
--FROM 		wine_list
--WHERE 	region = 'Chile'
--ORDER BY 	price
--/
--SELECT /*+ full(T)*/
--employee_number,employee_name, start_date, department_name
--FROM employee, department
--WHERE employee.department_number = department.department_number;
--
--CONNECT OUTLN/outln;
--   DROP TABLE OL$; 
--   CONNECT OUTLN/outln;
--   DROP TABLE OL$HINTS;
--
--ALTER SESSION SET CREATE_STORED_OUTLINES = FALSE;
--
---- The next set of statements use the profiler and the following files need to have been --executed first – profload.sql, dbmspbp.sql, prvtpbp.plb
---- @C:\Ora8i\RDBMS\ADMIN\profload.sql
--
--EXECUTE  C:\Ora8i\plsql\DEMO\profsum.sql
--/
--SELECT DBMS_PROFILER.START_PROFILER('test_1')
--FROM dual
--/
--EXECUTE  load_cv('1002','doc');
--/
--SELECT DBMS_PROFILER.STOP_PROFILER
--FROM dual
--/
--SELECT RUNID,RUN_DATE,RUN_TOTAL_TIME
--FROM plsql_profiler_runs;
--/
--SELECT unit_type,total_time
-- FROM plsql_profiler_units;
--/
--SELECT UNIT_NUMBER,LINE#,TOTAL_OCCUR,MIN_TIME,MAX_TIME,TOTAL_TIME
-- FROM plsql_profiler_data;
--/
--CREATE TABLE person
--( name CHAR(20),
-- skills CLOB,
--picture BLOB
--PARALLEL(DEGREE 8));
--
