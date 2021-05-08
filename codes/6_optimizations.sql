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
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (2) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (3) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (4) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (5) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (6) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (7) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (8) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (9) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


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
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (12) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (13) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (14) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (15) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (16) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (17) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (18) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (19) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 


-- ***** (20) ***** --
-- Méthode d'optimisation choisie: 
-- Motivations: 

