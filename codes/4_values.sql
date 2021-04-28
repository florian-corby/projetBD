-- ======================================= --
-- ======= REMPLISSAGE DE LA BASE ======== --
-- ======================================= -- 


-- ********* RIGHTS ZONE ********* --
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



-- ********* DOCUMENT ZONE ********* --
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

INSERT INTO Editor (name, address, phone) VALUES ('Dunod', '11 rue Paul Bert 92247 Malakof CEDEX' ,0202020202);
INSERT INTO Editor (name, address, phone) VALUES('Eyrolles', '12 rue Paul Bert 92247 Malakof CEDEX', 0301050608);
INSERT INTO Editor (name, address, phone) VALUES ('DupondEtDupont', '13 rue Paul Bert 92247 Malakof CEDEX', 0908536274);
INSERT INTO Editor (name, address, phone) VALUES ('Laffont', '14 rue Paul Bert 92247 Malakof CEDEX', 0538759531);
INSERT INTO Editor (name, address, phone) VALUES ('Taylor', '15 rue Paul Bert 92247 Malakof CEDEX', 0123456789);

INSERT INTO Keyword (keyword) VALUES ('educational');
INSERT INTO Keyword (keyword) VALUES ('amazing');
INSERT INTO Keyword (keyword) VALUES ('mind-blowing');
INSERT INTO Keyword (keyword) VALUES ('boring');
INSERT INTO Keyword (keyword) VALUES ('funny');
INSERT INTO Keyword (keyword) VALUES ('incisive');
INSERT INTO Keyword (keyword) VALUES ('relaxing');
INSERT INTO Keyword (keyword) VALUES ('wholesome');
INSERT INTO Keyword (keyword) VALUES ('nsfw');
INSERT INTO Keyword (keyword) VALUES ('mind-twister');
INSERT INTO Keyword (keyword) VALUES ('controversial');
INSERT INTO Keyword (keyword) VALUES ('entertaining');
INSERT INTO Keyword (keyword) VALUES ('artwork');
INSERT INTO Keyword (keyword) VALUES ('gruesome');
INSERT INTO Keyword (keyword) VALUES ('philosophical');
INSERT INTO Keyword (keyword) VALUES ('poetic');
INSERT INTO Keyword (keyword) VALUES ('heart-warming');
INSERT INTO Keyword (keyword) VALUES ('SQL');
INSERT INTO Keyword (keyword) VALUES ('Java');
INSERT INTO Keyword (keyword) VALUES ('formules');
INSERT INTO Keyword (keyword) VALUES ('addition');
INSERT INTO Keyword (keyword) VALUES ('geometrie');
INSERT INTO Keyword (keyword) VALUES ('compiler');
INSERT INTO Keyword (keyword) VALUES ('autobiographie');
INSERT INTO Keyword (keyword) VALUES ('apprentissage');
INSERT INTO Keyword (keyword) VALUES ('symfony');
INSERT INTO Keyword (keyword) VALUES ('Ocaml');
INSERT INTO Keyword (keyword) VALUES ('quantique');
INSERT INTO Keyword (keyword) VALUES ('espace');
INSERT INTO Keyword (keyword) VALUES ('Mac');
INSERT INTO Keyword (keyword) VALUES ('Systeme');

INSERT INTO Theme (theme) VALUES ('informatique'); 
INSERT INTO Theme (theme) VALUES ('mathematiques');
INSERT INTO Theme (theme) VALUES('physique');
INSERT INTO Theme (theme) VALUES('anglais');
INSERT INTO Theme (theme) VALUES ('sport');

INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (1, 'SQL pour les nuls', 50, 'Taylor', 'informatique', 'Book', 200,  null, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (2, 'SQL pour les non nuls', 1, 'Eyrolles', 'informatique', 'Book', 2000, null, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (3, 'SQL pour les gens ni nuls ni non nuls', 5, 'Dunod', 'informatique', 'Book', 8001, null, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (4, 'Reussir a coder les yeux fermes', 2, 'Laffont', 'informatique', 'Book', 42, null, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (5, 'Programmer en Java', 2, 'Dunod', 'informatique', 'Book', 503, null, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (6, 'Seance de remise en forme', 2, 'DupondEtDupont', 'sport', 'CD', null, 30, null, 8);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (7, 'Conception des echecs version sorcier', 3, 'Dunod', 'informatique', 'CD', null, 90, null, 127);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (8, 'Les lois universelles de la physique', 4, 'Eyrolles', 'physique', 'CD', null, 180, null, 321);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (9, 'Un et un font deux', 8, 'Dunod', 'mathematiques', 'CD', null, 3600, null, 4500);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (10, 'La geometrie des espaces', 5, 'Laffont', 'mathematiques', 'CD', null, 127, null, 129);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (11, 'La compilation des programmes', 1, 'Dunod', 'informatique', 'DVD', null, 252, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (12, 'Reviser la programmation orientee objet', 9, 'Eyrolles', 'informatique', 'DVD', null, 31252, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (13, 'Elon Musk in space', 5, 'DupondEtDupont', 'anglais', 'DVD', null, 75, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (14, 'Brian is in the kitchen', 1, 'DupondEtDupont', 'anglais', 'DVD', null, 83, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (15, 'Apprendre Symfony en 150 minutes', 7, 'Dunod', 'informatique', 'DVD', null, 151, null, null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (16, 'Premiers pas en informatique', 10, 'Laffont', 'informatique', 'Video', null, 15, 'MP4', null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (17, 'Tout savoir sur la physique quantique', 2, 'Eyrolles', 'physique', 'Video', null, 2, 'AVI', null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (18, 'Les etoiles de Thomas Pesquet', 4, 'Laffont', 'physique', 'Video', null, 65, 'FLV', null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (19, 'Les logiciels pour Mac', 3, 'Dunod', 'informatique', 'Video', null, 3, 'WMV', null);
INSERT INTO Document (reference, title, qte, editor, theme, category, pages, time, format, nbSubtitles) VALUES (20, 'Linux contre Windows', 7, 'Eyrolles', 'informatique', 'Video', null, 76, 'MOV', null);

INSERT INTO DocumentAuthors (reference, author_id) VALUES (1, 1);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (2, 10);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (3, 3);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (4, 6);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (5, 5);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (6, 7);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (7, 4);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (8, 8);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (9, 9);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (10, 8);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (11, 10);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (12, 5);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (13, 2);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (14, 9);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (15, 2);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (16, 10);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (17, 6);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (18, 2);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (19, 9);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (20, 2);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (2, 3);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (6, 6);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (11, 2);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (16, 4);
INSERT INTO DocumentAuthors (reference, author_id) VALUES (20, 9);

INSERT INTO DocumentKeywords (reference, keyword) VALUES (1, 'educational');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (1, 'SQL');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (2, 'nsfw');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (2, 'SQL');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (3, 'educational');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (3, 'SQL');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (4, 'educational');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (4, 'Java');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (5, 'educational');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (5, 'Java');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (6, 'heart-warming');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (6, 'gruesome');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (7, 'Java');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (7, 'entertaining');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (8, 'formules');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (8, 'poetic');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (9, 'incisive');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (9, 'mind-twister');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (10, 'mind-twister');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (10, 'geometrie');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (11, 'compiler');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (11, 'relaxing');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (12, 'wholesome');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (12, 'Java');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (13, 'amazing');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (13, 'espace');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (14, 'mind-blowing');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (14, 'philosophical');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (15, 'symfony');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (15, 'artwork');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (16, 'apprentissage');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (16, 'entertaining');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (17, 'quantique');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (17, 'mind-twister');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (18, 'poetic');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (18, 'autobiographie');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (19, 'funny');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (19, 'Mac');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (20, 'controversial');
INSERT INTO DocumentKeywords (reference, keyword) VALUES (20, 'Systeme');

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


-- ********* BORROWINGS ZONE ********* --
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
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (2, 11, to_date('2021-04-24', 'YYYY-MM-DD'), to_date('2021-04-27', 'YYYY-MM-DD'));
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
INSERT INTO Borrow (borrower, copy, borrowing_date, return_date) VALUES (15, 18, to_date('2019-07-12', 'YYYY-MM-DD'), null);

COMMIT;