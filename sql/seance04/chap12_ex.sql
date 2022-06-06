--Chapter 12 Practical Exercises

-- todo:  must grant access to directory
INSERT INTO protozoa
(protozoa_name, family_name, remark, video)
values
('cyclidium_glaucoma', ' cyclidium',
'Free swimmers are usually found when no large flocs have been formed. They generally swim faster than flagellates and are generally more efficient feeders.',
BFILENAME('PHOTO_DIR', ‘cyclidium_glaucoma.mov'))

CREATE OR REPLACE PROCEDURE prot_blob_write IS
   Lob_loc      BLOB; -- TO HOLD LOB LOCATOR
   proto 	VARCHAR2(32767) := '';
   image =  acineria_uncinata.jpg
   OFFSET      INTEGER;
BEGIN
   /* Select the LOB: */
	SELECT picture INTO Lob_loc FROM protozoa
      	WHERE protozoa_name = 'acineria_uncinata'
   	FOR update;
   /*offset and amount parameters always refer to bytes in BLOBS  */
	
   	OFFSET:= DBMS_LOB.GETLENGTH(Lob_loc)+2;
	AMOUNT:= LENGTH(reftext);
   /* Read data: */
	dbms_lob.write(Lob_loc,amount,offset,reftext);
  /* 	*/
  
   	INSERT INTO MESSAGES VALUES (amount,'BLOB added','',offset);
	COMMIT;
EXCEPTION
    when no_data_found
    then dbms_output.put_line('COPY operation has some problems');
END;
/

-- video clip objects

CREATE TYPE cd_t AS OBJECT
(cd_id  CHAR(6),
 title  VARCHAR2(30),
 artists  artist_list)
/
CREATE TYPE award_t AS VARRAY(9)  OF VARCHAR2(20);
CREATE TYPE video_clip_t AS OBJECT
(video_number        CHAR(6),
clip_id                    CHAR(6),
title                      VARCHAR2(40),
director           VARCHAR2(40),
casting                    VARCHAR2(40),
category           VARCHAR2(40),
copyright          VARCHAR2(400),
producer           VARCHAR2(40),
awards                     award_t,
timeperiod         VARCHAR2(20),
rating                     VARCHAR2(20),
duration           INTEGER,
cdref                      REF     cd_t,
text_content               CLOB,
cover_image                ORDSYS.ORDImage,
video_source               ORDSYS.ORDVideo)
/
CREATE TYPE clip_list AS TABLE OF VIDEO_CLIP_T;


