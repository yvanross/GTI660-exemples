--Chapter 5 Practical Exercises 
select * from wine_list;

UPDATE wine_list
SET note = 'bonjour mon coco ce vin comporte poise, elegance and balance'
WHERE wine_code ='43107B';


SELECT 	wine_name, price
FROM 		wine_list
WHERE 	region = 'Bordeaux'
--									where_France

-- the following queries use a brief name to substitute for the long functional expression so that for example when the data is displayed it is listed under small string. In standard SQL the name would follow the key word AS but Oracle does not use this
select * from wine_list;
SELECT  wine_name, price, DBMS_LOB.SUBSTR(note,10,20)AS smallstring
from wine_list
where DBMS_LOB.INSTR (note, 'poise, elegance and balance')<>0

--									where_poise

SELECT wine_name, INSTR(wine_name, 'au') AS position
FROM wine_list 

SELECT wine_name, character, INSTR(character, 'Medium Bodied') as position,
SUBSTR(character, INSTR(character, 'Medium Bodied'),300) AS cut_out
FROM wine_list	

--										cut_out

-- voir le test suivant pour comprendre pourquoi le cut_out est null
SELECT wine_name
FROM wine_list
WHERE INSTR(character, 'Medium Bodied') >0

update wine_list set note = 'contains citrus fruits and gooseberries' where wine_code = '40484B';
select * from wine_list;
SELECT wine_name, note,DBMS_LOB.INSTR(note, 'citrus fruits and gooseberries') as position,
DBMS_LOB.SUBSTR(note, DBMS_LOB.INSTR(note, 'citrus fruits and gooseberries'),300) AS cut_out
FROM wine_list	

--									cut_out_clob

-- Attention dbms_lob.substr fonctionne différamment du substr pour un varchar
-- subst(lob_loc, amout, offset)
SELECT wine_name, 
DBMS_LOB.SUBSTR(note, 80,DBMS_LOB.INSTR(note, 'citrus fruits and gooseberries')) AS cut_out
FROM wine_list
WHERE DBMS_LOB.INSTR(note, 'citrus fruits and gooseberries')>0	
--/					

select * from wine_list;
SELECT category, year, AVG(price) AS average_price, MAX(price) AS highest
FROM		wine_list
--WHERE	region = 'Bordeaux'
GROUP BY	category, year
HAVING	year BETWEEN 1995 AND 1998
	ORDER BY category, year
/

DROP TABLE song
/
CREATE TABLE song
(	cdref		CHAR(6),
	songid	CHAR(6),
    artist	VARCHAR2(30),
    title		VARCHAR2(30),
	script	CLOB,
	writer	VARCHAR2(30),
	duration	INTEGER,
	audio_source	BLOB,
    PRIMARY KEY(cdref, songid))
/

DROP TABLE audio_example;
CREATE TABLE audio_example
( id   CHAR(8) PRIMARY KEY,
 description  VARCHAR2(4000),
 audio_data  BLOB,
 format   VARCHAR2(31),
 comments  CLOB,
 encoding  VARCHAR2(256),
 no_of_channels NUMBER,
 sampling_rate  NUMBER,
 sampling_size  NUMBER,
 compressiontype VARCHAR2(4000),
  audioDuration  NUMBER);

/*
Country	  Area	        Gdp	       Cars	    Population	  Births	 Deaths	     PCA F1

Germany	  357.00	  826.00	   25346	77854.00	  584.00	  696.10	 1.39686
Greece 	  132.00	   42.80	    1156	 9897.80	  123.00	   88.40	 -.92124
Spain  	  504.00	  216.20	    8879	38345.00	  456.00	  289.00	  .23597
France 	  544.00	  674.80	   20800	54678.00	  768.00	  543.00	 1.31617
Ireland	   68.90	   24.10	     719	 3543.00	   67.00	   32.30	-1.11725
Italy  	  301.00	  473.60	   20888	57009.70	  547.00	  532.00	  .77085
Denmark	   92.00	   28.90	     657	100987.0	   64.00	   97.20	 -.66384
Belgium	   34.00	   25.60	     567	 1435.00	   38.00	   56.70	-1.16387
Sweden 	  246.00	  256.70	   17213	 5678.00	  142.00	   97.80	 -.35222
UK     	  244.00	  612.34	   25678	56789.40	  729.00	  644.00	 1.12279
Holland	  144.00	  378.80	    1854	12455.00	  132.00	  115.00	 -.62422 
*/

SELECT 	country
FROM    	Europe
WHERE 	pcaf1 BETWEEN 0.1 AND 0.9



