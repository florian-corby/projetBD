-- ======================================= --
-- ======= REMPLISSAGE DE LA BASE ======== --
-- ======================================= -- 

INSERT INTO Theme (theme) VALUES ('informatique'); 
INSERT INTO Theme (theme) VALUES ('mathematiques');
INSERT INTO Theme (theme) VALUES('physique');
INSERT INTO Theme (theme) VALUES('anglais');
INSERT INTO Theme (theme) VALUES ('sport');

INSERT INTO Editor (name, address, phone) VALUES ('Dunod', '11 rue Paul Bert 92247 Malakof CEDEX' ,0202020202);
INSERT INTO Editor (name, address, phone) VALUES('Eyrolles', '12 rue Paul Bert 92247 Malakof CEDEX', 0301050608);
INSERT INTO Editor (name, address, phone) VALUES ('DupondEtDupont', '13 rue Paul Bert 92247 Malakof CEDEX', 0908536274);
INSERT INTO Editor (name, address, phone) VALUES ('Laffont', '14 rue Paul Bert 92247 Malakof CEDEX', 0538759531);
INSERT INTO Editor (name, address, phone) VALUES ('Taylor', '15 rue Paul Bert 92247 Malakof CEDEX', 0123456789);

INSERT INTO Author (id, name, fst_name, address, birth) VALUES (1, 'Taylor', 'Allen', '1 impasse Swift 86000 Poitiers', to_date('1975-02-25', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES(2, 'Legendre', 'Florian', '2 avenue des Gorons 69000 Lyon', to_date('1265-07-15', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (3, 'Berthelot', 'Yann', '3 strada italiana 00144 Rome', to_date('2000-12-12', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (4, 'Fradet', 'Amandine', '4 chemin des chemins 31000 Toulouse', to_date('1000-09-26', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (5, 'Pelle', 'Sarah', '16 rue de la vieille 34000 Montpellier', to_date('1965-06-04', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (6, 'Ere', 'Axel', '43 Place au beurre 29000 Quimper', to_date('1972-11-11', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (7, 'Glace', 'Brice', 'rue du chat qui peche 75000 Paris', to_date('1982-09-24', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (8, 'Cepacare', 'Ciceron', 'impasse de la these 13000 Marseille', to_date('1999-01-01', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (9, 'Guetta', 'David', 'rue de la pie qui boit 35400 Saint-Malo', to_date('1998-03-05', 'YYYY-MM-DD'));
INSERT INTO Author (id, name, fst_name, address, birth) VALUES (10, 'Fer', 'Lucie', '6 rue des enfers 72650 Saint-Saturnin', to_date('1969-06-16', 'YYYY-MM-DD'));

INSERT INTO CatBorrower (cat_borrower, borrowing_max) VALUES ('Staff', 10);
INSERT INTO CatBorrower (cat_borrower, borrowing_max) VALUES ('Professional', 5);
INSERT INTO CatBorrower (cat_borrower, borrowing_max) VALUES ('Public', 3);

INSERT INTO CatDoc (cat_document) VALUES ('Book');
INSERT INTO CatDoc (cat_document) VALUES ('CD');
INSERT INTO CatDoc (cat_document) VALUES ('DVD');
INSERT INTO CatDoc (cat_document) VALUES ('Video');

INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Staff', 'Book', 9);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Staff', 'CD', 5);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Staff', 'DVD', 4);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Staff', 'Video', 3);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Professional', 'Book', 11);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Professional', 'CD', 4);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Professional', 'DVD', 3);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Professional', 'Video', 2);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Public', 'Book', 3);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Public', 'CD', 3);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Public', 'DVD', 2);
INSERT INTO Rights (cat_borrower, cat_document, duration) VALUES ('Public', 'Video', 1);

INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (1, 'SQL pour les nuls', 'SQL', 1, 'Taylor', 'informatique', 'Book', 50);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (2, 'SQL pour les non nuls', 'SQL', 2, 'Eyrolles', 'informatique', 'Book', 1);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (3, 'SQL pour les gens ni nuls ni non nuls', 'SQL', 3, 'Dunod', 'informatique', 'Book', 5);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (4, 'Reussir a coder les yeux fermes', 'Java', 4, 'Laffont', 'informatique', 'Book', 2);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (5, 'Programmer en Java', 'Java', 5, 'Dunod', 'informatique', 'Book', 2);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (6, 'Seance de remise en forme', 'fitness', 2, 'DupondEtDupont', 'sport', 'CD', 4);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (7, 'Conception des echecs version sorcier', 'Java', 3, 'Dunod', 'informatique', 'CD', 4);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (8, 'Les lois universelles de la physique', 'formules', 4, 'Eyrolles', 'physique', 'CD', 6);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (9, 'Un et un font deux', 'addition', 2, 'Dunod', 'mathematiques', 'CD', 8);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (10, 'La geometrie des espaces', 'geometrie', 6, 'Laffont', 'mathematiques', 'CD', 5);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (11, 'La compilation des programmes', 'compiler', 7, 'Dunod', 'informatique', 'DVD', 1);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (12, 'Reviser la programmation orientee objet', 'Java', 8, 'Eyrolles', 'informatique', 'DVD', 9);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (13, 'Elon Musk in space', 'autobiographie', 9, 'DupondEtDupont', 'anglais', 'DVD', 5);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (14, 'Brian is in the kitchen', 'apprentissage', 10, 'DupondEtDupont', 'anglais', 'DVD', 1);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (15, 'Apprendre Symfony en 150 minutes', 'symfony', 2, 'Dunod', 'informatique', 'DVD', 7);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (16, 'Premiers pas en informatique', 'OCaml', 3, 'Laffont', 'informatique', 'Video', 10);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (17, 'Tout savoir sur la physique quantique', 'quantique', 4, 'Eyrolles', 'physique', 'Video', 2);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (18, 'Les etoiles de Thomas Pesquet', 'espace', 5, 'Laffont', 'physique', 'Video', 4);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (19, 'Les logiciels pour Mac', 'Mac', 6, 'Dunod', 'informatique', 'Video', 3);
INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte) VALUES (20, 'Linux contre Windows', 'Systeme', 7, 'Eyrolles', 'informatique', 'Video', 7);

INSERT INTO Book (reference, page) VALUES (1, 1750);
INSERT INTO Book (reference, page) VALUES (2, 329);
INSERT INTO Book (reference, page) VALUES (3, 11);
INSERT INTO Book (reference, page) VALUES (4, 255);
INSERT INTO Book (reference, page) VALUES (5, 666);

INSERT INTO Video(reference, time, format) VALUES (16, 160, 'MP4');
INSERT INTO Video(reference, time, format) VALUES (17, 170, 'MP4');
INSERT INTO Video(reference, time, format) VALUES (18, 180, 'AVI');
INSERT INTO Video(reference, time, format) VALUES (19, 190, 'AVI');
INSERT INTO Video(reference, time, format) VALUES (20, 200, 'FLV');

INSERT INTO DVD(reference, time) VALUES (11, 110);
INSERT INTO DVD(reference, time) VALUES (12, 120);
INSERT INTO DVD(reference, time) VALUES (13, 130);
INSERT INTO DVD(reference, time) VALUES (14, 140);
INSERT INTO DVD(reference, time) VALUES (15, 150);

INSERT INTO CD(reference, time, subtitle) VALUES (6, 60, 0);
INSERT INTO CD(reference, time, subtitle) VALUES (7, 70, 5);
INSERT INTO CD(reference, time, subtitle) VALUES (8, 80, 15);
INSERT INTO CD(reference, time, subtitle) VALUES (9, 90, 2);
INSERT INTO CD(reference, time, subtitle) VALUES (10, 1000, 1);

INSERT INTO Copy (id, aisleID, reference) VALUES (1, 1, 1);
INSERT INTO Copy (id, aisleID, reference) VALUES (2, 1, 2);
INSERT INTO Copy (id, aisleID, reference) VALUES (3, 1, 3);
INSERT INTO Copy (id, aisleID, reference) VALUES (4, 1, 4);
INSERT INTO Copy (id, aisleID, reference) VALUES (5, 1, 5);
INSERT INTO Copy (id, aisleID, reference) VALUES (6, 2, 6);
INSERT INTO Copy (id, aisleID, reference) VALUES (7, 2, 7);
INSERT INTO Copy (id, aisleID, reference) VALUES (8, 2, 8);
INSERT INTO Copy (id, aisleID, reference) VALUES (9, 2, 9);
INSERT INTO Copy (id, aisleID, reference) VALUES (10, 2, 10);
INSERT INTO Copy (id, aisleID, reference) VALUES (11, 3, 11);
INSERT INTO Copy (id, aisleID, reference) VALUES (12, 3, 12);
INSERT INTO Copy (id, aisleID, reference) VALUES (13, 3, 13);
INSERT INTO Copy (id, aisleID, reference) VALUES (14, 3, 14);
INSERT INTO Copy (id, aisleID, reference) VALUES (15, 3, 15);
INSERT INTO Copy (id, aisleID, reference) VALUES (16, 4, 16);
INSERT INTO Copy (id, aisleID, reference) VALUES (17, 4, 17);
INSERT INTO Copy (id, aisleID, reference) VALUES (18, 4, 18);
INSERT INTO Copy (id, aisleID, reference) VALUES (19, 4, 19);
INSERT INTO Copy (id, aisleID, reference) VALUES (20, 4, 20);

INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (1, 'Dupont', 'Dupond', 'chemin des Dupon 49000 Angers', 0745821559, 'Public');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (2, 'Legendre', 'Florian', '2 avenue des Gorons 69000 Lyon', 1265071501, 'Professional');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (3, 'Berthelot', 'Yann', '3 strada italiana 00144 Rome', 2000121212, 'Professional');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (4, 'Fradet', 'Amandine', '4 chemin des chemins 31000 Toulouse', 1995092645, 'Staff');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (5, 'Manaudou', 'Laurent', '5 avenue du sud 13000 Marseille', 0154985275, 'Professional');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (6, 'Hulot', 'Nicolas', '6 avenue du Sud 13000 Marseille', 0512584758, 'Staff');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (7, 'Dupond', 'Dupont', 'chemin des Dupon 49000 Angers', 0154585652, 'Public');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (8, 'Dupons', 'Desponts', 'chemin des Dupon 49000 Angers', 0215457885, 'Public');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (9, 'Duponh', 'Dhupon', 'chemin des Dupon 49000 Angers', 0326569885, 'Public');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (10, 'Baba', 'Ali', 'rue des tresors 00144 Rome', 0665588996, 'Staff');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (11, 'Sensei', 'Kuro', 'impasse des tentacules 13000 Angers', 0448822335, 'Public');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (12, 'Nook', 'Tom', 'chemin des iles mysteres 59000 Lille', 0201554488, 'Staff');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (13, 'Meli', 'Melo', 'chemin des iles mysteres 59000 Lille', 0554893265, 'Staff');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (14, 'Trump', 'Donald', '45 avenue Washington 77000 Melun', 0654321548, 'Public');
INSERT INTO Borrower (id, name, fst_name, address, phone, category) VALUES (15, 'Apeupres', 'Jean-Michel', '222 Banker Strit 11000 Carcassone', 0102030405, 'Professional');

INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (1, 1, to_date('2018-11-16', 'YYYY-MM-DD'), to_date('2018-11-19', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (1, 15, to_date('2019-03-03', 'YYYY-MM-DD'), to_date('2019-03-05', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 11, to_date('2021-04-24', 'YYYY-MM-DD'), to_date('2020-04-27', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (3, 12, to_date('2021-01-01', 'YYYY-MM-DD'), to_date('2020-01-03', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (5, 13, to_date('2020-12-13', 'YYYY-MM-DD'), to_date('2019-12-16', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 14, to_date('2021-03-31', 'YYYY-MM-DD'), to_date('2021-04-03', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (12, 1, to_date('2020-04-21', 'YYYY-MM-DD'), to_date('2020-04-30', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (12, 6, to_date('2020-04-21', 'YYYY-MM-DD'), to_date('2020-04-26', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (12, 11, to_date('2020-04-21', 'YYYY-MM-DD'), to_date('2020-04-25', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (12, 16, to_date('2020-04-21', 'YYYY-MM-DD'), to_date('2020-04-24', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 2, to_date('2021-02-12', 'YYYY-MM-DD'), to_date('2021-02-23', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 7, to_date('2021-02-12', 'YYYY-MM-DD'), to_date('2021-02-16', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 11, to_date('2021-02-12', 'YYYY-MM-DD'), to_date('2021-02-15', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 17, to_date('2021-02-12', 'YYYY-MM-DD'), to_date('2021-02-14', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (11, 3, to_date('2019-07-07', 'YYYY-MM-DD'), to_date('2019-07-10', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (11, 8, to_date('2019-07-07', 'YYYY-MM-DD'), to_date('2019-07-10', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (11, 11, to_date('2019-07-07', 'YYYY-MM-DD'), to_date('2019-07-09', 'YYYY-MM-DD'));
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (11, 18, to_date('2019-07-10', 'YYYY-MM-DD'), to_date('2019-07-11', 'YYYY-MM-DD'));

COMMIT;
