-- ============================================================================== --
-- ========================= GESTION DES TRANSACTIONS =========================== --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre

-- ******* Boîte à outils ******* --
-- SET TRANSACTION READ WRITE; -- La transaction peut lire (avec quel niveau d'isolation???) et écrire dans les tables.
-- SET TRANSACTION READ ONLY; -- On ne peut que lire.

-- Le "ISOLATION LEVEL" définit un comportement à la lecture mais n'empêche pas les insertions
-- ou updates ou suppressions. Ici, empêche les lectures sales mais pas les lectures non répétables 
-- ou les fantômes:
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- LOCK TABLE nom_table IN EXCLUSIVE MOVE --Verrou explicite en Ecriture
-- LOCK TABLE nom_table IN SHARE MODE --Verrou explicite en Lecture

-- SAVEPOINT toto; ROLLBACK TO toto;
-- ROLLBACK; COMMIT;

-- SHOW AUTOCOMMIT; --Affiche la valeur de la variable autocommit
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
SET TRANSACTION READ WRITE NAME 'Emprunt';
-- On s'assure qu'il n'y a pas d'autocommit:
SET AUTOCOMMIT OFF;

-- Le premier arrivé peut lancer la procédure d'emprunt, les autres attendent leur tour.
-- On place le verrou en écriture avant la consultation des exemplaires disponibles afin
-- d'éviter les lectures non répétables sur ces-derniers et les verrous mortels:
LOCK TABLE Chuxclub.Borrow IN EXCLUSIVE MODE;

-- L'utilisateur consulte les exemplaires disponibles du document qu'il souhaite emprunter:
SELECT DISTINCT c.id 
FROM Chuxclub.Copy c
WHERE c.reference = 20 AND c.id NOT IN (SELECT copy FROM Chuxclub.Borrow WHERE return_date is null);

-- L'utilisateur choisit un exemplaire et l'emprunte:
INSERT INTO Chuxclub.Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 20, sysdate, null);

-- L'utilisateur peut alors annuler son emprunt et/ou terminer sa transaction:
--ROLLBACK;        
COMMIT;