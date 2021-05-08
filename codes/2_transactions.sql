-- ============================================================================== --
-- ========================= GESTION DES TRANSACTIONS =========================== --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre


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
-- COMMIT ferme alors le bloc tout aussi implicitement. On s'assure également que l'autocommit
-- n'est pas à OFF même si ce n'est par défaut pas le cas sous Oracle:
SET TRANSACTION READ WRITE;
SET AUTOCOMMIT OFF;

-- L'utilisateur consulte les copies disponibles du Document qu'il souhaite emprunter:
SELECT DISTINCT c.id 
FROM Chuxclub.Copy c
WHERE c.reference = 20 AND c.id NOT IN (SELECT copy FROM Chuxclub.Borrow WHERE return_date is null);

-- Le premier arrivé peut l'emprunter. Si ça échoue l'utilisateur doit recommencer la transaction:
LOCK TABLE Chuxclub.Borrow IN EXCLUSIVE MODE;
INSERT INTO Chuxclub.Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 20, sysdate, null);

-- L'utilisateur peut annuler (rollback) ou valider son emprunt:
--ROLLBACK;
COMMIT;