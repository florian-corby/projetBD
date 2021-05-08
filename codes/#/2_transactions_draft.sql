-- ============================================================================== --
-- ========================= GESTION DES TRANSACTIONS =========================== --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre

-- ******* Boîte à outils ******* --
-- SET TRANSACTION READ WRITE; -- La transaction peut lire et écrire dans les tables
-- SET TRANSACTION READ ONLY; -- On ne peut que lire

-- Le "ISOLATION LEVEL" définit un comportement à la lecture mais n'empêche pas les insertions
-- ou updates ou suppressions. Ici, empêche les lectures sales mais pas les lectures non répétables 
-- ou les fantômes:
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- LOCK TABLE nom_table IN EXCLUSIVE MOVE --Verrou explicite en Ecriture
-- LOCK TABLE nom_table IN SHARE MODE --Verrou explicite en Lecture

-- SAVEPOINT toto; ROLLBACK TO toto;
-- ROLLBACK; COMMIT;

SHOW AUTOCOMMIT; --Affiche la valeur de la variable autocommit
-- SET AUTOCOMMIT OFF; 

---------------------------------------------------------------------------------
--                                    Emprunt                                  --
---------------------------------------------------------------------------------

-- ******* Emprunt d'un même exemplaire par des membres de la librairie ******* --

-- On suppose les membres de la librairie accèdent à la base de donnée par un formulaire ou
-- une interface graphique. Le script ci-dessous correspond alors au script exécuté lors d'un
-- emprunt quelconque. Il vise à empêcher des incohérences lors des emprunts simultanés. Pour
-- illustrer son fonctionnement on peut ouvrir deux sqldeveloper avec deux utilisateurs différents 
-- et exécuter le même script ci-dessous dans l'ordre.


-- Pas nécessaire car Oracle l'ajoute implicitement à la première requête.
-- COMMIT ferme alors le bloc tout aussi implicitement:
SET TRANSACTION READ WRITE;
-- On s'assure qu'il n'y a pas d'autocommit:
SET AUTOCOMMIT OFF;

-- On veut éviter la lecture non répétable. On pose donc un verrou dès le début 
-- en lecture pour éviter de futures écritures dans la table Borrow:
LOCK TABLE Chuxclub.Borrow IN SHARE MODE;

-- L'utilisateur consulte les copies disponibles du Document qu'il souhaite emprunter:
SELECT DISTINCT c.id 
FROM Chuxclub.Copy c
WHERE c.reference = 20 AND c.id NOT IN (SELECT copy FROM Chuxclub.Borrow WHERE return_date is null);

-- On évite la lecture non répétable mais on risque maintenant des verrous mortels dans le cas où 
-- on a deux transactions simultanées qui posent toutes les deux leurs verrous en lecture et qu'une d'entre elles 
-- veut écrire:
LOCK TABLE Chuxclub.Borrow IN EXCLUSIVE MODE;

INSERT INTO Chuxclub.Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 20, sysdate, null);
--ROLLBACK;




-- Version 2 (ne marche pas car pl/sql veut des 'into' après chaque select et que ça ne passe pas avec la sous-requête corrélée NOT IN):
SET TRANSACTION READ WRITE NAME 'Emprunt';
SET AUTOCOMMIT OFF;

DECLARE
 isInserted boolean;
 
BEGIN
    isInserted := false;
    
    WHILE not isInserted
    LOOP
    
        DECLARE
            copyToBorrow int;
            
        BEGIN
            -- La base cherche le premier exemplaire disponible:
            SELECT DISTINCT c.id into copyToBorrow
            FROM Chuxclub.Copy c
            WHERE c.reference = 20 AND c.id NOT IN (SELECT b.copy FROM Chuxclub.Borrow b WHERE return_date is null)
            FETCH FIRST 1 ROWS ONLY;

            -- Elle va tenter d'ajouter cet emprunt:
            LOCK TABLE Chuxclub.Borrow IN EXCLUSIVE MODE;
            INSERT INTO Chuxclub.Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 20, sysdate, null);
            isInserted := true;
        
            EXCEPTION 
                -- S'il n'y a aucun exemplaire de disponible on arrête tout:
                WHEN no_data_found THEN raise_application_error('-20001', 'No copies available right now. Try again later!');
                -- Si quelqu'un vient juste de faire le même emprunt il faut reprendre depuis le début:
                WHEN OTHERS THEN isInserted := false;
        END;
        
    END LOOP;
END;

-- Fin de la transaction:        
COMMIT;
        
COMMIT;

