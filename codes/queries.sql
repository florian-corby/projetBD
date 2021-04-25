-- ========================================== --
-- ============== EXERCICE 6 ================ --
-- ========================================== --


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
FROM Borrower bwr, Borrow b, Copy c, Document d, Author a
WHERE bwr.id = b.borrower AND b.copy = c.id AND c.reference = d.reference AND d.author = a.id
ORDER BY bwr.name ASC;



-- ***** (4) *****




-- ***** (5) *****

--TODO: Là on a la quantité totale des exemplaire présents à la bibliothèque mais pas la quantité totale en tout:
--Solution la plus simple: rajouter un attribut quantité dans Exemplaire qui donne la quantité courante d'exemplaire présents
--dans la bibliothèque, tandis que l'attribut quantité dans Document nous donnerait la quantité totale (présents et absents) du document
--que possède la bibliothèque:
SELECT e.name, SUM(d.qte)
FROM Document d, Editor e
WHERE e.name = d.editor AND e.name = 'Eyrolles'
GROUP BY e.name;


-- ***** (6) *****

SELECT e.name, SUM(d.qte) --SUM(c.qte) et non SUM(d.qte)
FROM Document d, Editor e --, Copy c
WHERE e.name = d.editor -- AND c.reference = d.reference
GROUP BY e.name;


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



-- ***** (12) *****



-- ***** (13) *****



-- ***** (14) *****



-- ***** (15) *****



-- ***** (16) *****



-- ***** (17) *****



-- ***** (18) *****



-- ***** (19) *****



-- ***** (20) *****


