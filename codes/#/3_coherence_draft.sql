-- ============================================================= --
-- ================= GESTION DE LA COHÉRENCE =================== --
-- ============================================================= --


---------------------------------------------------------------------------------
--                                   Document                                  --
---------------------------------------------------------------------------------

-- ******* Ajout/Mise à jour => Vérification cohérence de la catégorie ******* --
CREATE OR REPLACE TRIGGER tg_Document_Category 
BEFORE INSERT OR UPDATE ON Document
FOR EACH ROW
BEGIN
if :new.category = 'Book' and (:new.pages is null 
                               or :new.time is not null 
                               or :new.format is not null 
                               or :new.nbSubtitles is not null)
then raise_application_error('-20001', 'A book has a certain number of pages and has no specific duration or video format or subtitles');
  
elsif :new.category = 'CD' and (:new.pages is not null 
                                or :new.time is null 
                                or :new.format is not null 
                                or :new.nbSubtitles is null)
then raise_application_error('-20001', 'A CD has a certain duration and a certain number of subtitles but no video format or pages');

elsif :new.category = 'DVD' and (:new.pages is not null 
                                 or :new.time is null 
                                 or :new.format is not null 
                                 or :new.nbSubtitles is not null)
then raise_application_error('-20001', 'A DVD has a certain duration but has no pages or video format or subtitles');

elsif :new.category = 'Video' and (:new.pages is not null 
                                   or :new.time is null 
                                   or :new.format is null 
                                   or :new.nbSubtitles is not null)
then raise_application_error('-20001', 'A Video has a certain duration and video format but has no pages or subtitles');
end if;
END;
/


-- **** Suppression **** --
--SELECT d.reference, d.title, c.id, b.borrowing_date, b.return_date 
--FROM Document d, Copy c, Borrow b
--WHERE d.reference = c.reference and c.id = b.copy and b.return_date is null;
--
--SELECT d.reference, COUNT(*)
--FROM Document d, Copy c, Borrow b
--WHERE d.reference = c.reference and c.id = b.copy and b.return_date is null
--GROUP BY d.reference;
--
--SELECT COUNT(*)
--FROM Document d, Copy c, Borrow b
--WHERE 52 = c.reference and c.id = b.copy and b.return_date is null
--GROUP BY d.reference;




-- ***** Paraît OK mais: il faut des ON DELETE CASCADE. Problème: on ne peut pas faire de requêtes sur la relation qui a 
-- déclenché le trigger or on doit supprimer en cascade les copies et les emprunts mais le trigger ci-dessous échoue. Seule
-- solution serait de faire un ON DELETE SET NULL sur la table Copy mais pas trop de sens... Ou alors un ON DELETE SET NULL 
-- sur Copie et un trigger sur copie qui après la mise à jour l'élimine: ***** --

--CREATE OR REPLACE TRIGGER tg_Document_Suppression 
--BEFORE DELETE ON Document
--FOR EACH ROW
--DECLARE isBeingBorrowed INT;
--BEGIN
--    SELECT COUNT(*) into isBeingBorrowed
--    FROM Copy c, Borrow b
--    WHERE :old.reference = c.reference and c.id = b.copy and b.return_date is null
--    GROUP BY :old.reference;
--    exception when NO_DATA_FOUND then isBeingBorrowed := null;
--    
--    if isBeingBorrowed is not null
--    then raise_application_error('-20001', 'A copy of this document is being borrowed and hence cannot be deleted!');
--    end if;
--END;
--/

--DELETE FROM Document WHERE reference = 18;


-- ******* Ajout => vérif quantité Document ******* --
--CREATE OR REPLACE TRIGGER tg_Document_IsQteZero
--BEFORE INSERT ON Document
--FOR EACH ROW
--BEGIN
--
--END;
--/


---------------------------------------------------------------------------------
--                                    Emprunt                                  --
---------------------------------------------------------------------------------

-- ******* Ajout => Vérification nombre d'emprunts ******* --
-- Affiche tous ceux qui ont emprunté quelque-chose avec leurs max d'emprunt associés à leurs catégories:
SELECT DISTINCT bwr.id, bwr.name, bwr.fst_name, bwr.category, catB.borrowing_max
FROM Borrow b, Borrower bwr, CatBorrower catB
WHERE b.borrower = bwr.id and bwr.category = catB.cat_borrower
ORDER BY bwr.id ASC;


-- Affiche tous ceux qui ont emprunté quelque-chose avec leurs max d'emprunt associés à leurs catégories
-- Et qui ont encore un emprunt en cours:
SELECT bwr.id, bwr.name, bwr.fst_name, bwr.category, catB.borrowing_max
FROM Borrow b, Borrower bwr, CatBorrower catB
WHERE b.borrower = bwr.id and bwr.category = catB.cat_borrower and b.return_date is null
ORDER BY bwr.id ASC;


-- Compte le nombre de documents en cours d'emprunt de tous les emprunteurs ayant des emprunts en cours:
SELECT bwr.id, COUNT(*)
FROM Borrow b, Borrower bwr, CatBorrower catB
WHERE b.borrower = bwr.id and bwr.category = catB.cat_borrower and b.return_date is null
GROUP BY bwr.id
ORDER BY bwr.id ASC;

-- Le trigger final:
CREATE OR REPLACE TRIGGER tg_Borrow_VerifMaxBorrow
BEFORE INSERT ON Borrow
FOR EACH ROW
DECLARE
    nbCurrentBorrows INT;
    nbMaxBorrows INT;
BEGIN

    BEGIN
        SELECT COUNT(*) INTO nbCurrentBorrows
        FROM Borrow b, Borrower bwr, CatBorrower catB
        WHERE bwr.id = :new.borrower and bwr.category = catB.cat_borrower and b.return_date is null
        GROUP BY bwr.id;
        EXCEPTION WHEN no_data_found THEN nbCurrentBorrows := 0;
    END;
    
    SELECT catB.borrowing_max INTO nbMaxBorrows
    FROM Borrower bwr, CatBorrower catB
    WHERE bwr.id = :new.borrower and bwr.category = catB.cat_borrower;
    
    if nbCurrentBorrows >= nbMaxBorrows
    then raise_application_error('-20001', 'You have exceeded the number of borrowed documents you can have. Please return some documents before borrowing new ones.');
    end if;
END;
/ 


--  ///=====\\\
-- /// TESTS \\\
-- \\\=======///

INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 7, to_date('2020-05-03', 'YYYY-MM-DD'), null);
DELETE FROM Borrow WHERE borrower = 15 and copy = 7 and borrowing_date = to_date('2020-05-03', 'YYYY-MM-DD');
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 14, to_date('2020-05-03', 'YYYY-MM-DD'), null);
DELETE FROM Borrow WHERE borrower = 15 and copy = 14 and borrowing_date = to_date('2020-05-03', 'YYYY-MM-DD');

INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 10, to_date('2020-05-03', 'YYYY-MM-DD'), null);
DELETE FROM Borrow WHERE borrower = 3 and copy = 10 and borrowing_date = to_date('2020-05-03', 'YYYY-MM-DD');


-- ******* Ajout =>  Aucun retard en cours ******* --

-- Liste toutes les personnes qui ont eu des documents en retard (je fais -1 pour en avoir plus pour l'instant):
select bwr.id, bwr.name, bwr.category, r.cat_document, r.duration, b.borrowing_date, b.return_date, b.borrowing_date + r.duration-1 as expected_date
from borrow b, borrower bwr, rights r, copy c, document d
where bwr.id = b.borrower
      and b.borrower = bwr.id
      and b.copy = c.id
      and c.reference = d.reference
      and d.category = r.cat_document
      and bwr.category = r.cat_borrower
      and b.borrowing_date + r.duration-1 < b.return_date;
      
      
-- Compte, pour chaque personne, le nombre de documents en retard qu'elle a eu en tout:
select bwr.id, COUNT(*)
from borrow b, borrower bwr, rights r, copy c, document d
where bwr.id = b.borrower
      and b.borrower = bwr.id
      and b.copy = c.id
      and c.reference = d.reference
      and d.category = r.cat_document
      and bwr.category = r.cat_borrower
      and b.borrowing_date + r.duration-1 < b.return_date
GROUP BY bwr.id ORDER BY bwr.id ASC;


-- Liste toutes les personnes qui ont actuellement des documents en retard (je fais -1 pour en avoir plus pour l'instant):
select bwr.id, bwr.name, bwr.category, r.cat_document, r.duration, b.borrowing_date, b.return_date, b.borrowing_date + r.duration-1 as expected_date, sysdate as current_date
from borrow b, borrower bwr, rights r, copy c, document d
where bwr.id = b.borrower
      and b.borrower = bwr.id
      and b.copy = c.id
      and c.reference = d.reference
      and d.category = r.cat_document
      and bwr.category = r.cat_borrower
      and b.borrowing_date + r.duration-1 < sysdate
      and b.return_date is null;


-- Compte, pour chaque personne, le nombre de documents qu'elle a actuellement en retard:
select bwr.id, COUNT(*)
from borrow b, borrower bwr, rights r, copy c, document d
where bwr.id = b.borrower
      and b.borrower = bwr.id
      and b.copy = c.id
      and c.reference = d.reference
      and d.category = r.cat_document
      and bwr.category = r.cat_borrower
      and b.borrowing_date + r.duration-1 < sysdate
      and b.return_date is null
GROUP BY bwr.id ORDER BY bwr.id ASC;
      
      
-- Le trigger final:
CREATE OR REPLACE TRIGGER tg_Borrow_VerifOverdues
BEFORE INSERT ON Borrow
FOR EACH ROW
declare 
nbDocsBeingOverdued INT;
BEGIN
    BEGIN
        select COUNT(*) into nbDocsBeingOverdued
        from borrow b, borrower bwr, rights r, copy c, document d
        where bwr.id = :new.borrower
        and b.borrower = bwr.id
        and b.copy = c.id
        and c.reference = d.reference
        and d.category = r.cat_document
        and bwr.category = r.cat_borrower
        and b.borrowing_date + r.duration-1 < sysdate
        and b.return_date is null
        GROUP BY bwr.id;
        EXCEPTION WHEN no_data_found THEN nbDocsBeingOverdued := 0;
    END;
    
    if nbDocsBeingOverdued > 0
        then raise_application_error('-20001','You cannot borrow any document yet, return your overdued documents first');
    end if;
END;
/


--  ///=====\\\
-- /// TESTS \\\
-- \\\=======///

--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 6, to_date('2021-04-28', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 15 and copy = 6 and borrowing_date =  to_date('2021-04-28', 'YYYY-MM-DD');


--CREATE OR REPLACE TRIGGER tg_Borrow_VerifOverdues
--BEFORE INSERT ON Borrow
--FOR EACH ROW
--declare 
--return_d borrow.return_date%type;
--BEGIN
--    select return_date into return_d
--    from borrow
--    where borrow.borrower = :new.borrower;
--    exception when no_data_found then return_d := null;
--    
--    if (return_d is null and return_d < sysdate)
--        then dbms_output.put_line('You are late');
--    end if;
--END;
--/


-- ******* Ajout =>  On ne peut pas l'emprunter si en cours d'emprunt ******* --
--CREATE OR REPLACE TRIGGER tg_Borrow_VerifIsBeingBorrowed
--BEFORE INSERT ON Borrow
--FOR EACH ROW
--BEGIN
--
--END;
--/


-- ******* Suppression => Vérification document rendu ******* --
--CREATE OR REPLACE TRIGGER tg_Borrow_VerifHasBeenReturned -- Doublon avec ci-dessus?
--BEFORE INSERT ON Borrow
--FOR EACH ROW
--BEGIN
--
--END;
--/




---------------------------------------------------------------------------------
--                                  Emprunteur                                 --
---------------------------------------------------------------------------------

-- ******* Catégorie emprunteur change => réévaluer ses documents ******* --
--CREATE OR REPLACE TRIGGER tg_Borrower_AssessDocsToNewRights
--BEFORE INSERT ON Borrower
--FOR EACH ROW
--BEGIN
--
--END;
--/


-- ******* Suppression d'un emprunteur => Aucun document empruntés en cours ******* --
--SELECT bwr.id, bwr.name, b.borrowing_date, b.return_date, d.title
--FROM Borrower bwr, Borrow b, Copy c, Document d
--WHERE bwr.id = b.borrower and b.copy = c.id and c.reference = d.reference and b.return_date is null;
--
--SELECT bwr.id, COUNT(*)
--FROM Borrower bwr, Borrow b
--WHERE bwr.id = b.borrower and b.return_date is null
--GROUP BY bwr.id;
--
-- (Ne marche pas car la table borrow avec ON DELETE CASCADE est modifiée => erreur mutabilité des tables avec le trigger)
--CREATE OR REPLACE TRIGGER tg_Borrower_VerifNoBeingBorrowedDocs
--BEFORE DELETE ON Borrower
--FOR EACH ROW
--DECLARE
--    nbCopiesBeingBorrowed INT;
--BEGIN
--    SELECT COUNT(*) INTO nbCopiesBeingBorrowed
--    FROM Borrow b
--    WHERE :old.id = b.borrower and b.return_date is null
--    GROUP BY :old.id;
--    EXCEPTION WHEN no_data_found THEN nbCopiesBeingBorrowed := null;
--    
--    if nbcopiesbeingborrowed is not null
--    then raise_application_error('-20001', 'This person has still a copy of a document being borrowed. All documents must be returned before deletion.');
--    end if;
--END;
--/
--
--DELETE FROM Borrower bwr WHERE bwr.id = 15;



---------------------------------------------------------------------------------
--                                  Exemplaire                                 --
---------------------------------------------------------------------------------

-- ******* Ajout => màj quantité Document ******* --
--CREATE OR REPLACE TRIGGER tg_Copy_IncreaseDocQte
--BEFORE INSERT ON Copy
--FOR EACH ROW
--BEGIN
--
--END;
--/


-- ******* Suppression => màj quantité document ******* --
--CREATE OR REPLACE TRIGGER tg_Copy_DecreaseDocQte
--BEFORE INSERT ON Copy
--FOR EACH ROW
--BEGIN
--
--END;
--/

