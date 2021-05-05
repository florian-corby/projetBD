-- ============================================================================== --
-- ========================== GESTION DE LA COHÉRENCE =========================== --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre


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



---------------------------------------------------------------------------------
--                                    Emprunt                                  --
---------------------------------------------------------------------------------


-- ******* Ajout => Vérification nombre d'emprunts en cours ******* --
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

--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 7, to_date('2020-05-03', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 15 and copy = 7 and borrowing_date = to_date('2020-05-03', 'YYYY-MM-DD');
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 14, to_date('2020-05-03', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 15 and copy = 14 and borrowing_date = to_date('2020-05-03', 'YYYY-MM-DD');
--
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 10, to_date('2020-05-03', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 3 and copy = 10 and borrowing_date = to_date('2020-05-03', 'YYYY-MM-DD');


-- ******* Ajout =>  Aucun retard en cours ******* --
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
        and b.borrowing_date + r.duration < sysdate
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



-- ******* Ajout =>  On ne peut pas l'emprunter si en cours d'emprunt ******* --
CREATE OR REPLACE TRIGGER tg_Borrow_VerifIsBeingBorrowed
BEFORE INSERT ON Borrow
FOR EACH ROW
Declare isBorrowed borrow.copy%type;
BEGIN
    BEGIN
        select copy into isBorrowed
        from borrow
        where :new.copy = borrow.copy and borrow.return_date is null;
        exception when no_data_found then isBorrowed := null;
    END;
    
    if isBorrowed is not null
    then raise_application_error('-20001','Already borrowed and not returned');
    end if;
END;
/


--  ///=====\\\
-- /// TESTS \\\
-- \\\=======///

---- On insère un document qui n'est pas en cours d'emprunt:
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 6, to_date('2021-05-03', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 3 and copy = 6 and borrowing_date =  to_date('2021-05-03', 'YYYY-MM-DD');
--
----On insère un document en cours d'emprunt par un emprunteur différent de celui qui emprunte actuellement le document:
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 18, to_date('2021-05-03', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 3 and copy = 18 and borrowing_date =  to_date('2021-05-03', 'YYYY-MM-DD');
--
----On insère un document en cours d'emprunt par le même emprunteur que celui qui emprunte actuellement le document:
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 18, to_date('2021-05-04', 'YYYY-MM-DD'), null);
--DELETE FROM Borrow WHERE borrower = 15 and copy = 18 and borrowing_date =  to_date('2021-05-04', 'YYYY-MM-DD');



-- ******* Màj => Avertissement si retour de document en retard ******* --
CREATE OR REPLACE TRIGGER tg_Borrow_warningIfLateReturn
BEFORE UPDATE ON Borrow
FOR EACH ROW
DECLARE r_duration INT; delay INT;
BEGIN  
    BEGIN
        select r.duration into r_duration
        from borrower bwr, rights r, copy c, document d
        where bwr.id = :new.borrower
        and c.id = :new.copy
        and c.reference = d.reference
        and d.category = r.cat_document
        and bwr.category = r.cat_borrower;
        EXCEPTION WHEN no_data_found THEN r_duration := null;
    END;
    
    if :old.return_date is null and (:new.borrowing_date + r_duration) < sysdate
    then delay := sysdate - (:new.borrowing_date  + r_duration);
         dbms_output.put_line('You are ' || delay || ' day(s) late on this document.'); 
         dbms_output.put_line('Sanctions might apply next time.');
    end if;
END;
/

--  ///=====\\\
-- /// TESTS \\\
-- \\\=======///


---- === TEST_1:
---- On ajoute un emprunt qui va avoir un retard:
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 5, to_date('2021-04-01', 'YYYY-MM-DD'), null);
--
---- Liste toutes les personnes qui ont actuellement des documents en retard:
--select bwr.id, bwr.name, bwr.category, r.cat_document, r.duration, b.borrowing_date, b.return_date, b.borrowing_date + r.duration-1 as expected_date, sysdate as current_date
--from borrow b, borrower bwr, rights r, copy c, document d
--where bwr.id = b.borrower
--      and b.borrower = bwr.id
--      and b.copy = c.id
--      and c.reference = d.reference
--      and d.category = r.cat_document
--      and bwr.category = r.cat_borrower
--      and b.borrowing_date + r.duration-1 < sysdate
--      and b.return_date is null;
--
---- On simule un retour en retard (penser à brancher le DBMS Output en bas de la fenêtre SQL Developper, le bouton + vert):
--UPDATE Borrow SET return_date = to_date('2021-05-04', 'YYYY-MM-DD') WHERE borrower = 2 and copy = 5 and borrowing_date = to_date('2021-04-01', 'YYYY-MM-DD');
--
---- On efface le test:
--DELETE FROM Borrow WHERE borrower = 2 and copy = 5 and borrowing_date = to_date('2021-04-01', 'YYYY-MM-DD');
--
--
---- === TEST_2:
---- On ajoute un emprunt qui n'aura pas de retard:
--INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 5, to_date('2021-05-03', 'YYYY-MM-DD'), null);
--
---- On simule le retour NON en retard:
--UPDATE Borrow SET return_date = to_date('2021-05-04', 'YYYY-MM-DD') WHERE borrower = 2 and copy = 5 and borrowing_date = to_date('2021-05-03', 'YYYY-MM-DD');
--
---- On efface le test:
--DELETE FROM Borrow WHERE borrower = 2 and copy = 5 and borrowing_date = to_date('2021-05-03', 'YYYY-MM-DD');


-- ******* Ajout => vérif quantité Document ******* --
CREATE OR REPLACE TRIGGER tg_Document_IsQteZero
BEFORE INSERT ON Document
FOR EACH ROW
BEGIN
    if :new.qte <> 0
    then raise_application_error('-20001', 'Document quantity must be initialized at 0 as it is synchronized with the number of copies');
    end if;
END;
/



---------------------------------------------------------------------------------
--                                  Exemplaire                                 --
---------------------------------------------------------------------------------

-- ******* Ajout => màj quantité Document ******* --
CREATE OR REPLACE TRIGGER tg_Copy_IncreaseDocQte
BEFORE INSERT ON Copy
FOR EACH ROW
DECLARE doc_qte INT;
BEGIN
    SELECT d.qte INTO doc_qte
    FROM Document d
    WHERE :new.reference = d.reference;
    UPDATE Document SET qte = doc_qte+1 WHERE reference = :new.reference;
END;
/

--  ///=====\\\
-- /// TESTS \\\
-- \\\=======///

--SELECT DISTINCT d.reference, d.title, d.qte
--FROM Document d, Copy c 
--WHERE c.reference = d.reference
--ORDER BY d.reference ASC;
--
--INSERT INTO Copy (id, aisleID, reference) VALUES (51, 4, 19);
--
--SELECT * FROM Copy WHERE id = 51;



-- ******* Suppression => màj quantité document ******* --
CREATE OR REPLACE TRIGGER tg_Copy_DecreaseDocQte
BEFORE DELETE ON Copy
FOR EACH ROW
DECLARE doc_qte INT;
BEGIN
    SELECT d.qte INTO doc_qte
    FROM Document d
    WHERE :old.reference = d.reference;
    UPDATE Document SET qte = doc_qte-1 WHERE reference = :old.reference;
END;
/


--  ///=====\\\
-- /// TESTS \\\
-- \\\=======///

--SELECT DISTINCT d.reference, d.title, d.qte
--FROM Document d, Copy c 
--WHERE c.reference = d.reference
--ORDER BY d.reference ASC;
--
--DELETE FROM Copy WHERE id = 51;
--
--SELECT * FROM Copy WHERE id = 51;