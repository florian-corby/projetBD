-- ============================================================================== --
-- ========================= OPTIMISATION DES REQUÊTES ========================== --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre


---------------------------------------------------------------------------------
--        Les index des requêtes correspondant au fichier 5_queries.sql        --
---------------------------------------------------------------------------------

-- ***** Quelques données préliminaires pour éclairer nos choix ***** --

-- On met à jour nos statistiques:
EXEC dbms_stats.gather_schema_stats ('Chuxclub'); 

-- À exécuter sur sa session Administrateur:
SHOW PARAMETERS;
SHOW PARAMETER DB_BLOCK_SIZE; --8192Ko par bloc chez moi
SHOW PARAMETER DB_FILE_MULTIBLOCK_READ_COUNT; --36 blocs lus simultanément chez moi

-- Nombre de blocs occupés par nos tables (peuvent ne pas être consécutifs => 1 I/O au mieux
-- pour lire toutes les données de chaque table, 8 I/O au pire):
SELECT * FROM user_segments WHERE segment_name = 'AUTHOR'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'BORROW'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'BORROWER'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'CATBORROWER'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'CATDOC'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'COPY'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'DOCUMENT'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'DOCUMENTAUTHORS'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'DOCUMENTKEYWORDS'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'EDITOR'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'KEYWORD'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'RIGHTS'; --8 blocs occupés
SELECT * FROM user_segments WHERE segment_name = 'THEME'; --8 blocs occupés

-- Affiche les index de la table et si les blocs de chaque table sont organisés
-- physiquement par rapport à leurs indexs => informations notamment pour les recherches sur des intervalles de valeurs:
SELECT INDEX_NAME, CLUSTERING_FACTOR FROM user_indexes;

-- Pour l'instant les index sur les clefs primaires occupent un seul noeud:
SELECT SEGMENT_NAME, BLEVEL, LEAF_BLOCKS, bytes, blocks 
FROM user_segments 
LEFT JOIN user_indexes ON user_indexes.index_name = user_segments.segment_name;

-- On active des affichages d'information supplémentaires lors de l'exécution des requêtes
-- comme le plan d'exécution des requêtes choisi par l'optimiseur et le temps d'exécution des requêtes:
SET AUTOTRACE ON EXPLAIN;
SET TIMING ON;
-- DESC Document;



-- ***** (1) ***** --
-- Méthode d'optimisation choisie: Arbre B+
-- Motivations: Il peut y avoir autant de theme que de document, ce qui pourrait
-- devenir hors norme. Et une vue ne serait pas suffisante car elle ne serait pas
-- mettable à jour. On ne sélectionne que la colonne Title de Document


-- La nouvelle requête:
CREATE INDEX Theme_index ON Document ( theme );

-- L'ancienne requête:
SELECT d.title as Titre
FROM Document d
WHERE d.theme = 'mathematiques' or d.theme = 'informatique'
ORDER BY d.title ASC;



-- ***** (2) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT d.title as Titre, d.theme as Theme
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference
      AND bwr.name = 'Dupont' AND b.borrowing_date >= to_date('15/11/2018', 'DD/MM/YYYY') AND b.borrowing_date <= to_date('15/11/2019', 'DD/MM/YYYY');


-- ***** (3) ***** --
-- Méthode d'optimisation choisie:index Bitmap
-- Motivations: 
CREATE BITMAP INDEX Borrower_Doc_index ON Borow ( copy );


-- La nouvelle requête:

-- L'ancienne requête:
-- Montre les champs les plus importants et donne la liste
-- des auteurs séparés par des virgules pour chaque document:
CREATE OR REPLACE VIEW DocumentSummary AS
SELECT d.reference, d.title, d.editor, d.theme, d.category, da.authors
FROM Document d, (SELECT d.reference, LISTAGG(a.name || ' ' || a.fst_name, ', ') WITHIN GROUP (ORDER BY a.name) AS authors
                    FROM Document d, DocumentAuthors da, Author a
                    WHERE d.reference = da.reference and da.author_id = a.id
                    GROUP BY d.reference) da
WHERE d.reference = da.reference;
--SELECT * FROM DocumentSummary;

-- La requête finale:
SELECT DISTINCT bwr.name as Emprunteur, d.title as Titre, d.authors
FROM Borrower bwr, Borrow b, Copy c, DocumentSummary d
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference
ORDER BY bwr.name ASC;


-- ***** (4) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT DISTINCT a.name, a.fst_name
FROM Chuxclub.Author a, Chuxclub.DocumentAuthors da, Document d
WHERE a.id = da.author_id AND da.reference = d.reference
      AND d.editor = 'Dunod';


-- ***** (5) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT e.name, SUM(d.qte)
FROM Document d, Editor e
WHERE e.name = d.editor AND e.name = 'Eyrolles'
GROUP BY e.name;


-- ***** (6) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
-- Donne pour chaque document le nombre d'exemplaires actuellement 
-- présents à la bibliothèque (ie. qui ne sont pas en cours d'emprunt):
CREATE OR REPLACE VIEW DocsCurrentQuantities AS
SELECT t1.reference, t1.total_copies - NVL(t2.nb_of_copies_being_borrowed, 0) as total_copies_present
FROM 

(SELECT d.reference, COUNT(*) as total_copies
FROM Document d, Copy c
WHERE d.reference = c.reference
GROUP BY d.reference) t1 

LEFT OUTER JOIN

(SELECT d.reference, COUNT(*) as nb_of_copies_being_borrowed
FROM DOCUMENT d, Copy c, Borrow b
WHERE d.reference = c.reference and c.id = b.copy and b.return_date is null
GROUP BY d.reference) t2

ON t1.reference = t2.reference
ORDER BY t1.reference ASC;
--SELECT * FROM DocsCurrentQuantities;

-- La requête finale:
SELECT e.name, SUM(dcq.total_copies_present)
FROM Document d, DocsCurrentQuantities dcq, Editor e
WHERE d.reference = dcq.reference AND d.editor = e.name
GROUP BY e.name;


-- ***** (7) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT d.title, t.quantite
FROM Document d
INNER JOIN
(
    SELECT c.reference, COUNT(*) as Quantite
    FROM Borrow b, Copy c, Document d
    WHERE d.reference = c.reference AND c.id = b.copy
    GROUP BY c.reference
)
t ON d.reference = t.reference;


-- ***** (8) ***** --
-- Méthode d'optimisation choisie:Vue ou cliché
-- Motivations: Cette vue ne sera pas mettable à jour à cause de la jointure.

-- La nouvelle requête:
CREATE VIEW Editor_Info_Math AS
SELECT e.name
FROM Editor e, Document d
WHERE e.name = d.editor AND (d.theme = 'informatique' or d.theme = 'mathematiques')
GROUP BY e.name
HAVING COUNT(*) > 2;

-- L'ancienne requête:
SELECT e.name
FROM Editor e, Document d
WHERE e.name = d.editor AND (d.theme = 'informatique' or d.theme = 'mathematiques')
GROUP BY e.name
HAVING COUNT(*) > 2;


-- ***** (9) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT DISTINCT bwr1.name
FROM Borrower bwr1, Borrower bwr2
WHERE bwr1.address = bwr2.address 
      AND bwr1.name <> bwr2.name 
      AND bwr2.name = 'Dupont';


-- ***** (10) ***** --
-- Méthode d'optimisation choisie: Vue concrète
-- Motivations: Bien que les domaines soient suffisamment restreints,
-- un Index BitMap sur l'attribut 'theme' de l'entité Document ou éventuellement sur l'éditeur n'aurait aucun intérêt
-- du fait de la jointure. Forcer un algorithme de jointure n'aurait pas d'intérêt car l'optimiseur d'Oracle utilise déjà
-- l'algorithme le plus performant, à savoir la jointure par hashage. On peut en revanche créer une vue concrète tout en gardant
-- à l'esprit qu'elle ne serait ni mettable à jour du fait de la jointure, ni automaintenable à la suppression dans Document. 
-- Elle est automaintenable à l'insertion dans Document.

DROP MATERIALIZED VIEW editorCS;

CREATE MATERIALIZED VIEW editorCS 
TABLESPACE USERS
BUILD IMMEDIATE
REFRESH complete ON COMMIT
ENABLE QUERY REWRITE AS
SELECT e.name 
    FROM Editor e, Document d
    WHERE e.name = d.editor AND d.theme = 'informatique'
    GROUP BY e.name;

-- La nouvelle requête:
SELECT e.name 
FROM Editor e
WHERE e.name NOT IN (SELECT * FROM editorCS);

-- L'ancienne requête:
SELECT e.name
FROM Editor e
WHERE e.name NOT IN(
    SELECT e.name
    FROM Editor e, Document d
    WHERE e.name = d.editor AND d.theme = 'informatique'
    GROUP BY e.name
);


-- ***** (11) ***** --
-- Méthode d'optimisation choisie: Aucune
-- Motivations: Il n'y a pas de jointure donc pas d'optimisation à faire là-dessus que ce soit en forçant l'utilisation
--              d'un algorithme ou en utilisant une vue concrète. Un index sur la colonne borrower de la table borrow 
--              n'aurait ici pas d'intérêt car l'optimiseur commence de toute façon par parcourir toute la table avant 
--              de faire son GROUP BY par hachage.

-- L'ancienne requête (conservée telle quelle):
SELECT bwr.name
FROM Borrower bwr
WHERE bwr.id NOT IN(
    SELECT b.borrower
    FROM Borrow b
    GROUP BY b.borrower
);


-- ***** (12) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT *
FROM Document d
WHERE d.reference NOT IN(
    SELECT c.reference
    FROM Copy c, Borrow b
    WHERE c.id = b.copy
);


-- ***** (13) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT DISTINCT bwr.name, bwr.fst_name
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.category = 'Professional'
    AND bwr.id = b.borrower
    AND d.category = 'DVD'
    AND b.copy = c.id
    AND c.reference = d.reference
    AND b.borrowing_date >= add_months(sysdate, -6);


-- ***** (14) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT *
FROM Document d
WHERE qte > (SELECT AVG(qte)
             FROM Document d);


-- ***** (15) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT DISTINCT a.name
FROM Author a, Document d, DocumentAuthors da
WHERE d.theme = 'informatique'
    AND a.id = da.author_id AND da.reference = d.reference
    AND a.id IN (SELECT da.author_id
                 FROM Document d, DocumentAuthors da
                 WHERE d.theme = 'mathematiques' AND d.reference = da.reference);


-- ***** (16) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT qte_emprunts_par_editeur.editor, qte_emprunts_par_editeur.quantite
FROM (
    SELECT d.editor, COUNT(*) as Quantite  --affiche la quantité totale pour chaque editeur
    FROM Borrow b, Copy c, Document d
    WHERE d.reference = c.reference AND c.id = b.copy
    GROUP BY d.editor
    ) qte_emprunts_par_editeur
WHERE qte_emprunts_par_editeur.quantite IN
(
    SELECT Max(d.quantite)
    FROM (
        SELECT d.editor, COUNT(*) as Quantite 
        FROM Borrow b, Copy c, Document d
        WHERE d.reference = c.reference AND c.id = b.copy
        GROUP BY d.editor
    ) d
);


-- ***** (17) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT * 
FROM Document d
WHERE d.reference NOT IN (SELECT DISTINCT t1.reference
                            FROM (SELECT d.reference, dk.keyword as keywords
                                    FROM DocumentKeywords dk, Document d
                                    WHERE dk.reference = d.reference) t1
                            WHERE t1.keywords IN (SELECT dk.keyword as keyword
                                                    FROM DocumentKeywords dk, Document d
                                                    WHERE dk.reference = d.reference 
                                                    AND d.title = 'SQL pour les nuls'));


-- ***** (18) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT DISTINCT d.title
FROM Document d, DocumentKeywords dk
WHERE d.reference = dk.reference
AND dk.keyword IN
( 
    SELECT dk.keyword
    FROM DocumentKeywords dk, Document d
    WHERE dk.reference = d.reference 
    AND d.title = 'SQL pour les nuls'
) AND d.title <> 'SQL pour les nuls';


-- ***** (19) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:
SELECT reference
FROM
(
    SELECT t1.reference as reference, t2.keyword as matching_keywords
    FROM (SELECT d.reference, dk.keyword
    FROM Document d, DocumentKeywords dk
    WHERE dk.reference = d.reference) t1

    LEFT OUTER JOIN

    (SELECT dk.keyword
    FROM DocumentKeywords dk, Document d
    WHERE dk.reference = d.reference 
    AND d.title = 'SQL pour les nuls') t2

    ON t1.keyword = t2.keyword
)                                                 
WHERE reference NOT IN (SELECT reference FROM Document d WHERE title = 'SQL pour les nuls')
GROUP BY reference
HAVING COUNT(matching_keywords) = (SELECT COUNT(keyword)
                                    FROM DocumentKeywords dk, Document d
                                    WHERE dk.reference = d.reference 
                                    AND d.title = 'SQL pour les nuls');


-- ***** (20) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- La nouvelle requête:

-- L'ancienne requête:


