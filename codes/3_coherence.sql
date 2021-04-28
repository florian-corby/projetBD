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


-- ******* Ajout => vérif quantité Document ******* --
CREATE OR REPLACE TRIGGER tg_Document_IsQteZero
BEFORE INSERT ON Document
FOR EACH ROW
BEGIN
if :new.qte <= 0
then raise_application_error('-20001', 'A document can only be added with positive quantity');
end if;
END;
/



---------------------------------------------------------------------------------
--                                    Emprunt                                  --
---------------------------------------------------------------------------------

-- ******* Ajout => Vérification nombre d'emprunts ******* --
CREATE OR REPLACE TRIGGER tg_Borrow_VerifMaxBorrow
BEFORE INSERT ON Borrow
FOR EACH ROW
DECLARE
    max_borrow catborrower.borrowing_max%type;
    borrow_nb number;
BEGIN
    select catborrower.borrowing_max
    into max_borrow
    from catborrower
    inner join borrower on borrower.category = catborrower.cat_borrower
    where borrower.id = :new.borrower;
    SELECT count(*)
    into borrow_nb
    from borrow
    where :new.borrower = borrower;
    if borrow_nb +1 > max_borrow
    then raise_application_error('-20001','You cannot borrow any document yet') ;
    end if;
END;
/


-- ******* Ajout =>  Aucun retard en cours ******* --
CREATE OR REPLACE TRIGGER tg_Borrow_VerifOverdues
BEFORE INSERT ON Borrow
FOR EACH ROW
declare 
return_d borrow.return_date%type;
BEGIN
    select return_date
    into return_d
    from borrow
    where borrow.borrower = :new.borrower;
    if (return_d is null and return_d > sysdate)
    then raise_application_error('-20001','You are late');
    end if;
END;
/


-- ******* Ajout =>  On ne peut pas l'emprunter si en cours d'emprunt ******* --
CREATE OR REPLACE TRIGGER tg_Borrow_VerifIsBeingBorrowed
BEFORE INSERT ON Borrow
FOR EACH ROW
Declare isBorrowed borrow.copy%type;
BEGIN
select copy
into isBorrowed
from borrow
where :new.copy = borrow.copy;
if isBorrowed is not null
then raise_application_error('-200001','Already borrowed and not returned');
end if;    
END;
/



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


