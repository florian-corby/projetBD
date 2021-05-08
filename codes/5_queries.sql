-- ============================================================================== --
-- ============== INTERROGATION DE LA BASE DE DONNÉES MULTIMEDIA ================ --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre


---------------------------------------------------------------------------------
--                                 Les requêtes                                --
---------------------------------------------------------------------------------

-- ***** (1) ***** --
SELECT d.title as Titre
FROM Document d
WHERE d.theme = 'mathematiques' or d.theme = 'informatique'
ORDER BY d.title ASC;


-- ***** (2) ***** --
SELECT d.title as Titre, d.theme as Theme
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference
      AND bwr.name = 'Dupont' AND b.borrowing_date >= to_date('15/11/2018', 'DD/MM/YYYY') AND b.borrowing_date <= to_date('15/11/2019', 'DD/MM/YYYY');


-- ***** (3) ***** --
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
--En utilisant la connexion "Administrateur" (changer le nom d'utilisateur si besoin):
--Alter session set "_ORACLE_SCRIPT" = true;
--
--CREATE ROLE member;
--GRANT SELECT ON <nomUtilisateur>.Document TO member;
--GRANT SELECT ON <nomUtilisateur>.DocumentAuthors TO member;
--GRANT SELECT ON <nomUtilisateur>.Author TO member;
--
--CREATE USER colleague IDENTIFIED BY colleague;
--GRANT member TO colleague;
--GRANT CONNECT TO colleague;
--GRANT RESOURCE TO colleague;
--Alter USER colleague quota unlimited on users;
--COMMIT;


--Dans un autre sqldeveloper, créer une nouvelle connexion avec l'utilisateur colleague (et le mdp "colleague")
--Pour le SID => orclcdb. Pour le nom de la connexion => choisir celui qu'on veut. Dans la nouvelle connexion, exécutez
--la requête suivante:
SELECT DISTINCT a.name, a.fst_name
FROM Chuxclub.Author a, Chuxclub.DocumentAuthors da, Document d
WHERE a.id = da.author_id AND da.reference = d.reference
      AND d.editor = 'Dunod';
      
--Toute requête sur d'autres tables que celles indiquées lors de la création du rôle "member" se solde par un
--"Table or View doesn't exist", tandis que toute requête sur les tables indiquées lors de la création du rôle "member"
--fonctionne.


-- ***** (5) ***** --
SELECT e.name, SUM(d.qte)
FROM Document d, Editor e
WHERE e.name = d.editor AND e.name = 'Eyrolles'
GROUP BY e.name;


-- ***** (6) ***** -- 
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
SELECT e.name
FROM Editor e, Document d
WHERE e.name = d.editor AND (d.theme = 'informatique' or d.theme = 'mathematiques')
GROUP BY e.name
HAVING COUNT(*) > 2;


-- ***** (9) ***** --
SELECT DISTINCT bwr1.name
FROM Borrower bwr1, Borrower bwr2
WHERE bwr1.address = bwr2.address 
      AND bwr1.name <> bwr2.name 
      AND bwr2.name = 'Dupont';


-- ***** (10) ***** --
SELECT e.name
FROM Editor e
WHERE e.name NOT IN(
    SELECT e.name
    FROM Editor e, Document d
    WHERE e.name = d.editor AND d.theme = 'informatique'
    GROUP BY e.name
);


-- ***** (11) ***** --
SELECT bwr.name
FROM Borrower bwr
WHERE bwr.id NOT IN(
    SELECT b.borrower
    FROM Borrow b
    GROUP BY b.borrower
);


-- ***** (12) ***** --
SELECT *
FROM Document d
WHERE d.reference NOT IN(
    SELECT c.reference
    FROM Copy c, Borrow b
    WHERE c.id = b.copy
);


-- ***** (13) ***** -- 
SELECT DISTINCT bwr.name, bwr.fst_name
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.category = 'Professional'
    AND bwr.id = b.borrower
    AND d.category = 'DVD'
    AND b.copy = c.id
    AND c.reference = d.reference
    AND b.borrowing_date >= add_months(sysdate, -6);


-- ***** (14) ***** --
SELECT *
FROM Document d
WHERE qte > (SELECT AVG(qte)
             FROM Document d);


-- ***** (15) ***** --
SELECT DISTINCT a.name
FROM Author a, Document d, DocumentAuthors da
WHERE d.theme = 'informatique'
    AND a.id = da.author_id AND da.reference = d.reference
    AND a.id IN (SELECT da.author_id
                 FROM Document d, DocumentAuthors da
                 WHERE d.theme = 'mathematiques' AND d.reference = da.reference);


-- ***** (16) ***** --
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
SELECT reference
FROM
(
    SELECT t1.reference as reference, t2.keyword as matching_keywords
    FROM DocumentKeywords t1

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
SELECT reference
FROM
(
    SELECT t1.reference as reference, t1.keyword as doc_keywords, t2.keyword as matching_keywords
    FROM DocumentKeywords t1

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
                                   AND d.title = 'SQL pour les nuls')
AND COUNT(doc_keywords) <= (SELECT COUNT(keyword)
                            FROM DocumentKeywords dk, Document d
                            WHERE dk.reference = d.reference 
                            AND d.title = 'SQL pour les nuls');
