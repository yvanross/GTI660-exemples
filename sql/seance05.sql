SELECT nom FROM acteur WHERE id IN (SELECT idActeur FROM acteurSerie AS "LE WHEDONVERSE" JOIN (SELECT idSerie FROM acteurSerie GROUP BY idSerie HAVING count(*) = 2) AS "MEILLEURE SÉRIE AU MONDE" ON "LE WHEDONVERSE".idSerie = "MEILLEURE SÉRIE AU MONDE".idSerie WHERE "LE WHEDONVERSE".idActeur NOT IN (SELECT idActeur FROM acteurSerie WHERE idSerie IN (1) ));


id |      nom       
----+----------------
  1 | Nathan Fillion
  2 | Felicia Day
  3 | Eliza Dushku
  4 | Alan Tudyk
(4 rows)

 id |    nom    
----+-----------
  1 | Buffy
  2 | Firefly
  3 | Dollhouse

 idacteur | idserie 
----------+---------
        1 |       1
        1 |       2
        2 |       1
        2 |       3
        3 |       1
        3 |       3
        4 |       2
        4 |       3

