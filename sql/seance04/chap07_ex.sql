--Chapter 7 Practical Exercises

CREATE OR REPLACE TYPE picture_list AS TABLE OF VARCHAR2(25)
describe picture_list;

ALTER TABLE wine_list
ADD (meta_picture  picture_list)
NESTED TABLE meta_picture STORE AS picture_list_tab;
describe wine_list;

CREATE TABLE dublin_core
(identifier CHAR(10),
subject  VARCHAR2(80),
title  VARCHAR2(80),
creator  VARCHAR2(80),
publisher VARCHAR2(60),
description CLOB,
contributor VARCHAR2(80),
subject_date DATE,
dc_resource VARCHAR2(100),
format  VARCHAR2(30),
relation VARCHAR2(100),
source  VARCHAR2(100),
language CHAR(10),
coverage VARCHAR2(100),
rights  VARCHAR2(100),
PRIMARY KEY(identifier) );

ALTER SESSION SET NLS_DATE_LANGUAGE = 'AMERICAN';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';
SELECT SYSDATE FROM DUAL;

INSERT INTO dublin_core
(identifier, subject, title, creator, publisher, subject_date)
VALUES
('1001001001', 'multimedia databases', 'Lynne Dunckley','Multimedia Databases - An Object relational Approach', 'Addison-Wesley', '01-JAN-2003');
select * from dublin_core;

CREATE TABLE grape_dlo
(grape_name	VARCHAR2(30),
subject		VARCHAR2(80),
title		VARCHAR2(80),
creator		VARCHAR2(80),
publisher	VARCHAR2(60),
grape_description	CLOB DEFAULT EMPTY_CLOB(),
grape_picture	BLOB DEFAULT EMPTY_BLOB(),
contributor	VARCHAR2(80),
subject_date	DATE,
dc_resource	VARCHAR2(100),
format		VARCHAR2(30),
relation	VARCHAR2(100),
source		VARCHAR2(100),
language	CHAR(10),
coverage	VARCHAR2(100),
rights		VARCHAR2(100),
PRIMARY KEY(grape_name) );

