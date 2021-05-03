-- ============================================================================== --
-- ============== INTERROGATION DE LA BASE DE DONNÉES MULTIMEDIA ================ --
-- ============================================================================== --


-- ***** (1) *****
SELECT d.title as Titre
FROM Document d
WHERE d.theme = 'mathematiques' or d.theme = 'informatique'
ORDER BY d.title ASC;


-- ***** (2) *****
SELECT d.title as Titre, d.theme as Theme
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference
      AND bwr.name = 'Dupont' AND b.borrowing_date >= to_date('15/11/2018', 'DD/MM/YYYY') AND b.borrowing_date <= to_date('15/11/2019', 'DD/MM/YYYY');


-- ***** (3) *****
SELECT DISTINCT bwr.name as Emprunteur, d.title as Titre, a.name as Auteur
FROM Borrower bwr, Borrow b, Copy c, Document d, Author a, DocumentAuthors da
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference AND d.reference = da.reference AND da.author_id = a.id
ORDER BY bwr.name ASC;



-- ***** (4) *****




-- ***** (5) *****
SELECT e.name, SUM(d.qte)
FROM Document d, Editor e
WHERE e.name = d.editor AND e.name = 'Eyrolles'
GROUP BY e.name;


-- ***** (6) ***** TODO
SELECT e.name, SUM(d.qte)
FROM Document d, Editor e
WHERE d.editor = e.name
GROUP BY e.name;



--SELECT e.name, SUM(d.qte) --SUM(c.qte) et non SUM(d.qte)
--FROM Document d, Editor e --, Copy c
--WHERE e.name = d.editor -- AND c.reference = d.reference
--GROUP BY e.name;


-- ***** (7) *****
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



-- ***** (8) *****
SELECT e.name
FROM Editor e, Document d
WHERE e.name = d.editor AND (d.theme = 'informatique' or d.theme = 'mathematiques')
GROUP BY e.name
HAVING COUNT(*) > 2;


-- ***** (9) *****

SELECT DISTINCT bwr1.name
FROM Borrower bwr1, Borrower bwr2
WHERE bwr1.address = bwr2.address 
      AND bwr1.name <> bwr2.name 
      AND bwr2.name = 'Dupont';


-- ***** (10) *****
SELECT e.name
FROM Editor e
WHERE e.name NOT IN(
    SELECT e.name
    FROM Editor e, Document d
    WHERE e.name = d.editor AND d.theme = 'informatique'
    GROUP BY e.name
);


-- ***** (11) *****
SELECT bwr.name
FROM Borrower bwr
WHERE bwr.id NOT IN(
    SELECT b.borrower
    FROM Borrow b
    GROUP BY b.borrower
);

-- ***** (12) *****
SELECT *
FROM Document d
WHERE d.reference NOT IN(
    SELECT c.reference
    FROM Copy c, Borrow b
    WHERE c.id = b.copy
);

-- ***** (13) *****
SELECT DISTINCT bwr.name, bwr.fst_name
FROM Borrower bwr, Borrow b, Copy c, Document d
WHERE bwr.category = 'Professional'
    AND bwr.id = b.borrower
    AND d.category = 'DVD'
    AND b.copy = c.id
    AND c.reference = d.reference
    AND b.borrowing_date >= to_date('25/10/2020', 'DD/MM/YYYY')
;

-- ***** (14) *****
SELECT *
FROM Document d
WHERE qte > (
    SELECT AVG(qte)
    FROM Document d
);

-- ***** (15) *****
SELECT DISTINCT a.name
FROM Author a, Document d, DocumentAuthors da
WHERE d.theme = 'informatique'
    AND a.id = da.author_id AND da.reference = d.reference
    AND a.id IN (
        SELECT da.author_id
        FROM Document d, DocumentAuthors da
        WHERE d.theme = 'mathematiques' AND d.reference = da.reference
);

-- ***** (16) *****
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

-- ***** (17) ***** TODO
SELECT DISTINCT d.title  --malheureusement, elle affiche aussi ceux qui ont un mot clef en commun
FROM Document d
WHERE d.reference NOT IN
( 
    SELECT d.reference
    FROM DocumentKeywords dk, Document d
    WHERE dk.reference = d.reference 
    AND d.title = 'SQL pour les nuls'
);

-- ***** (18) *****
SELECT DISTINCT d.title
FROM Document d, DocumentKeywords dk
WHERE d.reference = dk.reference
AND dk.keyword IN
( 
    SELECT dk.keyword
    FROM DocumentKeywords dk, Document d
    WHERE dk.reference = d.reference 
    AND d.title = 'SQL pour les nuls'
);

-- ***** (19) *****



-- ***** (20) *****


