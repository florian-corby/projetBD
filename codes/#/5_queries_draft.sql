-- ============================================================================== --
-- ============== INTERROGATION DE LA BASE DE DONNÉES MULTIMEDIA ================ --
-- ============================================================================== --


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
SELECT d.reference, d.title, d.editor, d.theme, d.category, a.name || ' ' || a.fst_name AS author
FROM Document d, DocumentAuthors da, Author a
WHERE d.reference = da.reference and da.author_id = a.id;

SELECT d.reference, LISTAGG(a.name || ' ' || a.fst_name, ', ') WITHIN GROUP (ORDER BY a.name) AS authors
FROM Document d, DocumentAuthors da, Author a
WHERE d.reference = da.reference and da.author_id = a.id
GROUP BY d.reference;

SELECT d.reference, d.title, d.editor, d.theme, d.category, da.authors
FROM Document d, (SELECT d.reference, LISTAGG(a.name || ' ' || a.fst_name, ', ') WITHIN GROUP (ORDER BY a.name) AS authors
                    FROM Document d, DocumentAuthors da, Author a
                    WHERE d.reference = da.reference and da.author_id = a.id
                    GROUP BY d.reference) da
WHERE d.reference = da.reference;

SELECT DISTINCT bwr.name as Emprunteur, d.title as Titre, a.name as Auteur
FROM Borrower bwr, Borrow b, Copy c, Document d, Author a
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference AND d.author = a.id
ORDER BY bwr.name ASC;



-- ***** (4) ***** --




-- ***** (5) ***** --
--TODO: Là on a la quantité totale des exemplaire présents à la bibliothèque mais pas la quantité totale en tout:
--Solution la plus simple: rajouter un attribut quantité dans Exemplaire qui donne la quantité courante d'exemplaire présents
--dans la bibliothèque, tandis que l'attribut quantité dans Document nous donnerait la quantité totale (présents et absents) du document
--que possède la bibliothèque:
SELECT e.name, SUM(d.qte)
FROM Document d, Editor e
WHERE e.name = d.editor AND e.name = 'Eyrolles'
GROUP BY e.name;


-- ***** (6) ***** --
SELECT e.name, SUM(d.qte) --SUM(c.qte) et non SUM(d.qte)
FROM Document d, Editor e --, Copy c
WHERE e.name = d.editor -- AND c.reference = d.reference
GROUP BY e.name;

--SELECT e.name, SUM(d.qte) --SUM(c.qte) et non SUM(d.qte)
--FROM Document d, Editor e --, Copy c
--WHERE e.name = d.editor -- AND c.reference = d.reference
--GROUP BY e.name;


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

--TODO: 6 derniers mois => par rapport à sysdate
SELECT DISTINCT bwr.name, bwr.fst_name
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.category = 'Professional'
    AND bwr.id = b.borrower
    AND d.category = 'DVD'
    AND b.copy = c.id
    AND c.reference = d.reference
    AND b.borrowing_date >= to_date('25/10/2020', 'DD/MM/YYYY');
    
    
-- ***** (14) ***** --
SELECT *
FROM Document d
WHERE qte > (
    SELECT AVG(qte)
    FROM Document d
);


-- ***** (15) ***** --
SELECT DISTINCT a.name
FROM Author a, Document d
WHERE d.theme = 'informatique'
    AND a.id = d.author
    AND a.id IN (
        SELECT d.author
        FROM Document d
        WHERE d.theme = 'mathematiques'
);

-- ***** (16) ***** --
--SELECT d.editor, COUNT(*) as Quantite  --affiche la quantité totale pour chaque editeur
--    FROM Borrow b, Copy c, Document d
--    WHERE d.reference = c.reference AND c.id = b.copy
--    GROUP BY d.editor;
--    
--SELECT Max(d.quantite) as Max_Emprunt --affiche la quantité maximum
--FROM (
--    SELECT d.editor, COUNT(*) as Quantite 
--    FROM Borrow b, Copy c, Document d
--    WHERE d.reference = c.reference AND c.id = b.copy
--    GROUP BY d.editor
--) d;

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
---- Donne tous les mots-clefs de tous les documents:
--SELECT d.reference, dk.keyword
--FROM DocumentKeywords dk, Document d
--WHERE dk.reference = d.reference;
--
---- Donne tous les mots-clefs du document dont le titre est 'SQL pour les nuls':
--SELECT dk.keyword
--FROM DocumentKeywords dk, Document d
--WHERE dk.reference = d.reference 
--AND d.title = 'SQL pour les nuls';
--
---- Donne les références des documents ayant au moins un mot-clef en commun avec le 
---- document dont le titre est 'SQL pour les nuls':
--SELECT DISTINCT t1.reference
--FROM (SELECT d.reference, dk.keyword as keywords
--        FROM DocumentKeywords dk, Document d
--        WHERE dk.reference = d.reference) t1
--WHERE t1.keywords IN (SELECT dk.keyword as keyword
--        FROM DocumentKeywords dk, Document d
--        WHERE dk.reference = d.reference 
--        AND d.title = 'SQL pour les nuls');
        
-- Donne les documents n'ayant aucun mot-clef en commun avec le
-- document dont le titre est 'SQL pour les nuls':
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
                                                    
--TODO (Version d'Amandine):
SELECT DISTINCT d.title  --malheureusement, elle affiche aussi ceux qui ont un mot clef en commun
FROM Document d
WHERE d.reference NOT IN (SELECT d.reference
                          FROM DocumentKeywords dk, Document d
                          WHERE dk.reference = d.reference 
                          AND d.title = 'SQL pour les nuls');



-- ***** (18) ***** --



-- ***** (19) ***** --



-- ***** (20) ***** --


