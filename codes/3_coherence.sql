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


---------------------------------------------------------------------------------
--                                  Emprunteur                                 --
---------------------------------------------------------------------------------

-- ******* Catégorie emprunteur change => réévaluer ses documents ******* --


-- ******* Suppression d'un emprunteur => Aucun document empruntés en cours ******* --




---------------------------------------------------------------------------------
--                                    Emprunt                                  --
---------------------------------------------------------------------------------

-- ******* Ajout => Vérification nombre d'emprunts ******* --


-- ******* Ajout =>  Aucun retard en cours ******* --


-- ******* Ajout =>  Màj qte exemplaires ******* --


-- ******* Màj => Rendu Emprunt => màj quantité exemplaires ******* --


-- ******* Suppression => Vérification document rendu ******* --


