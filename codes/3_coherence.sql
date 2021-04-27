-- ============================================================= --
-- ================= GESTION DE LA COHÉRENCE =================== --
-- ============================================================= --


---------------------------------------------------------------------------------
--                                   Document                                  --
---------------------------------------------------------------------------------

-- ******* Ajout => Vérification cohérence de la catégorie ******* --

CREATE OR REPLACE TRIGGER tg_Document_Category 
BEFORE INSERT ON Document
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


-- ******** Màj ******** --


-- **** Suppression **** --


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


