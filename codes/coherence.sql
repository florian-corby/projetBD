-- ============================================================= --
-- ================= Gestion de la cohérence =================== --
-- ============================================================= --


---------------------------------------------------------------------------------
--                           Ajout Livre/CD/DVD/Video                          --
---------------------------------------------------------------------------------

-- ******* Un seul document référé possible ******* --

CREATE OR REPLACE VIEW docCatAppearances AS
(SELECT doc.category, doc.reference
FROM Document doc, Book b
WHERE doc.reference = b.reference 

UNION ALL

SELECT doc.category, doc.reference
FROM Document doc, CD c
WHERE doc.reference = c.reference 

UNION ALL

SELECT doc.category, doc.reference
FROM Document doc, DVD d
WHERE doc.reference = d.reference 

UNION ALL

SELECT doc.category, doc.reference
FROM Document doc, Video v
WHERE doc.reference = v.reference);

--SELECT * FROM docCatAppearances;
--SELECT doc.reference FROM docCatAppearances doc GROUP BY doc.reference HAVING Count(*) > 1;
CREATE OR REPLACE TRIGGER tg_book
AFTER INSERT ON Book
DECLARE alreadyReferenced int;
BEGIN
    SELECT doc.reference INTO alreadyReferenced
    FROM docCatAppearances doc 
    GROUP BY doc.reference 
    HAVING Count(*) <> 1;
    
    if(alreadyReferenced is not null) then 
         DELETE FROM Book WHERE Book.reference = alreadyReferenced; 
         DBMS_OUTPUT.PUT_LINE('ERROR :> Document already belongs to another category');
    end if;
END;
/

CREATE OR REPLACE TRIGGER tg_cd
AFTER INSERT ON CD
DECLARE alreadyReferenced int;
BEGIN
    SELECT doc.reference INTO alreadyReferenced
    FROM docCatAppearances doc 
    GROUP BY doc.reference 
    HAVING Count(*) <> 1;
    
    if(alreadyReferenced is not null) then 
         DELETE FROM CD WHERE CD.reference = alreadyReferenced; 
         DBMS_OUTPUT.PUT_LINE('ERROR :> Document already belongs to another category');
    end if;
END;
/

CREATE OR REPLACE TRIGGER tg_dvd
AFTER INSERT ON DVD
DECLARE alreadyReferenced int;
BEGIN
    SELECT doc.reference INTO alreadyReferenced
    FROM docCatAppearances doc 
    GROUP BY doc.reference 
    HAVING Count(*) <> 1;
    
    if(alreadyReferenced is not null) then 
         DELETE FROM DVD WHERE DVD.reference = alreadyReferenced; 
         DBMS_OUTPUT.PUT_LINE('ERROR :> Document already belongs to another category');
    end if;
END;
/

CREATE OR REPLACE TRIGGER tg_video
AFTER INSERT ON Video
DECLARE alreadyReferenced int;
BEGIN
    SELECT doc.reference INTO alreadyReferenced
    FROM docCatAppearances doc 
    GROUP BY doc.reference 
    HAVING Count(*) <> 1;
    
    if(alreadyReferenced is not null) then 
         DELETE FROM Video WHERE Video.reference = alreadyReferenced; 
         DBMS_OUTPUT.PUT_LINE('ERROR :> Document already belongs to another category');
    end if;
END;
/


--INSERT INTO Video(reference, time, format) VALUES (1, 160, 'MP4');


-- ******* La catégorie du document correspond à la relation qui y réfère ******* --




--INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (25, 'Linux 4ever', 'Systeme', 7, 'Eyrolles', 'informatique', 'Video', 8000);
--INSERT INTO Book (reference, page) VALUES (25, 1750);




---------------------------------------------------------------------------------
--                                Màj Emprunteur                               --
---------------------------------------------------------------------------------

-- ******* Catégorie emprunteur change => réévaluer ses documents ******* --




---------------------------------------------------------------------------------
--                         Suppression d'un emprunteur                         --
---------------------------------------------------------------------------------

-- ******* Aucun document empruntés en cours ******* --




---------------------------------------------------------------------------------
--                                 Ajout Emprunt                               --
---------------------------------------------------------------------------------

-- ******* Vérification nombre d'emprunts ******* --


-- *******      Aucun retard en cours     ******* --


-- *******       Màj qte exemplaires      ******* --




---------------------------------------------------------------------------------
--                                  Màj Emprunt                                --
---------------------------------------------------------------------------------

-- ******* Rendu Emprunt => màj quantité exemplaires ******* --




---------------------------------------------------------------------------------
--                               Suppression Emprunt                           --
---------------------------------------------------------------------------------

-- ******* Vérification document rendu ******* --


