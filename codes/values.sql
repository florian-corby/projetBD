-- ======================================= --
-- =======REMPLISSAGE DE LA BASE========= --
-- ======================================= -- 

INSERT INTO Theme (theme) 
VALUES ('informatique'), 
    ('mathematiques'),
    ('physique'),
    ('anglais'),
    ('sport');

INSERT INTO Editor (name, address, phone)
VALUES ('Dunod', '11 rue Paul Bert 92247 Malakof CEDEX' ,0202020202),
    ('Eyrolles', '12 rue Paul Bert 92247 Malakof CEDEX', 0301050608),
    ('DupondEtDupont', '13 rue Paul Bert 92247 Malakof CEDEX', 0908536274),
    ('Laffont', '14 rue Paul Bert 92247 Malakof CEDEX', 0538759531);

INSERT INTO Author (id, name, fst_name, address, birth)
VALUES (1, 'Taylor', 'Allen', '1 impasse Swift 86000 Poitiers', 1975-02-25),
    (2, 'Legendre', 'Florian', '2 avenue des Gorons 69000 Lyon', 1265-07-15),
    (3, 'Berthelot', 'Yann', '3 strada italiana 00144 Rome', 2000-12-12),
    (4, 'Fradet', 'Amandine', '4 chemin des chemins 31000 Toulouse', 1995-09-26),
    (5, 'Pelle', 'Sarah', '16 rue de la vieille 34000 Montpellier', 1965-06-04),
    (6, 'Ere', 'Axel', '43 Place au beurre 29000 Quimper', 1972-11-11),
    (7, 'Glace', 'Brice', 'rue du chat qui peche 75000 Paris', 1982-09-24),
    (8, 'Cepacare', 'Ciceron', 'impasse de la these 13000 Marseille', 1999-01-01),
    (9, 'Guetta', 'David', 'rue de la pie qui boit 35400 Saint-Malo', 1998-03-05),
    (10, 'Fer', 'Lucie', '6 rue des enfers 72650 Saint-Saturnin', 1969-06-16);

INSERT INTO CatBorrower (cat_borrower, borrowing_max)
VALUES ('Staff', 10),
    ('Professional', 5),
    ('Public', 3);

INSERT INTO CatDoc (cat_document)
VALUES ('Book'),
    ('CD'),
    ('DVD'),
    ('Video');

INSERT INTO Rights (cat_borrower, cat_document, duration)
VALUES ('Staff', 'Book', 9),
    ('Staff', 'CD', 5),
    ('Staff', 'DVD', 4),
    ('Staff', 'Video', 3),
    ('Professional', 'Book', 11),
    ('Professional', 'CD', 4),
    ('Professional', 'DVD', 3),
    ('Professional', 'Video', 2),
    ('Public', 'Book', 3),
    ('Public', 'CD', 3),
    ('Public', 'DVD', 2),
    ('Public', 'Video', 1);

INSERT INTO Document (reference, title, key_word, author, editor, theme, category, qte)
VALUES (1, 'SQL pour les nuls', 'SQL', 1, 'Taylor', 'informatique', 'Book', 50),
    (2, 'SQL pour les non nuls', 'SQL', 2, 'Eyrolles', 'informatique', 'Book', 1),
    (3, 'SQL pour les gens ni nuls ni non nuls', 'SQL', 3, 'Dunod', 'informatique', 'Book', 5),
    (4, 'Reussir a coder les yeux fermes', 'Java', 4, 'Laffont', 'informatique', 'Book', 2),
    (5, 'Programmer en Java', 'Java', 5, 'Dunod', 'informatique', 'Book', 2),
    (6, 'Seance de remise en forme', 'fitness', 2, 'DupondEtDupont', 'sport', 'CD', 4),
    (7, 'Conception des echecs version sorcier', 'Java', 3, 'Dunod', 'informatique', 'CD', 4),
    (8, 'Les lois universelles de la physique', 'formules', 4, 'Eyrolles', 'physique', 'CD', 6),
    (9, 'Un et un font deux', 'addition', 2, 'Dunod', 'mathematiques', 'CD', 8),
    (10, 'La geometrie des espaces', 'geometrie', 6, 'Laffont', 'mathematiques', 'CD', 5),
    (11, 'La compilation des programmes', 'compiler', 7, 'Dunod', 'informatique', 'DVD', 1),
    (12, 'Reviser la programmation orientee objet', 'Java', 8, 'Eyrolles', 'informatique', 'DVD', 9),
    (13, 'Elon Musk in space', 'autobiographie', 9, 'DupondEtDupont', 'anglais', 'DVD', 5),
    (14, 'Brian is in the kitchen', 'apprentissage', 10, 'DupondEtDupont', 'anglais', 'DVD', 1),
    (15, 'Apprendre Symfony en 150 minutes', 'symfony', 2, 'Dunod', 'informatique', 'DVD', 7),
    (16, 'Premiers pas en informatique', 'OCaml', 3, 'Laffont', 'informatique', 'Video', 10),
    (17, 'Tout savoir sur la physique quantique', 'quantique', 4, 'Eyrolles', 'physique', 'Video', 2),
    (18, 'Les etoiles de Thomas Pesquet', 'espace', 5, 'Laffont', 'physique', 'Video', 4),
    (19), 'Les logiciels pour Mac', 'Mac', 6, 'Dunod', 'informatique', 'Video', 3,
    (20, 'Linux contre Windows', 'Systeme', 7, 'Eyrolles', 'informatique', 'Video', 7);

INSERT INTO Book (reference, page)
VALUES (1, 1750),
    (2, 329),
    (3, 11),
    (4, 255),
    (5, 666);

INSERT INTO Video(reference, time, format)
VALUES (16, 160, 'MP4'),
    (17, 170, 'MP4'),
    (18, 180, 'AVI'),
    (19, 190, 'AVI'),
    (20, 200, 'FLV');

INSERT INTO DVD(reference, time)
VALUES (11, 110),
    (12, 120),
    (13, 130),
    (14, 140),
    (15, 150);

INSERT INTO CD(reference, time, subtitle)
VALUES (6, 60, 0),
    (7, 70, 5),
    (8, 80, 15),
    (9, 90, 2),
    (10, 1000, 1);

INSERT INTO Copy (id, aisleID, reference)
VALUES (1, 1, 1),
    (2, 1, 2),
    (3, 1, 3),
    (4, 1, 4),
    (5, 1, 5),
    (6, 2, 6),
    (7, 2, 7),
    (8, 2, 8),
    (9, 2, 9),
    (10, 2, 10),
    (11, 3, 11),
    (12, 3, 12),
    (13, 3, 13),
    (14, 3, 14),
    (15, 3, 15),
    (16, 4, 16),
    (17, 4, 17),
    (18, 4, 18),
    (19, 4, 19),
    (20, 4, 20);

INSERT INTO Borrower (id, name, fst_name, address, phone, category)
VALUES (1, 'Dupont', 'Dupond', 'chemin des Dupon 49000 Angers', 0745821559, Public),
    (2, 'Legendre', 'Florian', '2 avenue des Gorons 69000 Lyon', 1265071501, Professional),
    (3, 'Berthelot', 'Yann', '3 strada italiana 00144 Rome', 2000121212, Professional),
    (4, 'Fradet', 'Amandine', '4 chemin des chemins 31000 Toulouse', 1995092645, Staff),
    (5, 'Manaudou', 'Laurent', '5 avenue du sud 13000 Marseille', 0154985275, Professional),
    (6, 'Hulot', 'Nicolas', '6 avenue du Sud 13000 Marseille', 0512584758, Staff),
    (7, 'Dupond', 'Dupont', 'chemin des Dupon 49000 Angers', 0154585652, Public),
    (8, 'Dupons', 'Desponts', 'chemin des Dupon 49000 Angers', 0215457885, Public),
    (9, 'Duponh', 'Dhupon', 'chemin des Dupon 49000 Angers', 0326569885, Public),
    (10, 'Baba', 'Ali', 'rue des tresors 00144 Rome', 0665588996, Staff),
    (11, 'Sensei', 'Kuro', 'impasse des tentacules 13000 Angers', 0448822335, Public),
    (12, 'Nook', 'Tom', 'chemin des iles mysteres 59000 Lille', 0201554488, Staff),
    (13, 'Meli', 'Melo', 'chemin des iles mysteres 59000 Lille', 0554893265, Staff),
    (14, 'Trump', 'Donald', '45 avenue Washington 77000 Melun', 0654321548, Public),
    (15, 'Apeupres', 'Jean-Michel', '222 Banker Strit 11000 Carcassone', 0102030405, Professional);

INSERT INTO Borrow (borrower, copy, borrowing_date, return_date)
VALUES (1, 1, 2018-11-16, 2018-11-19),
    (1, 15, 2019-03-03, 2019-03-05),
    (2, 11, 2021-04-24, 2020-04-27),
    (3, 12, 2021-01-01, 2020-01-03),
    (5, 13, 2020-12-13, 2019-12-16),
    (15, 14, 2021-03-31, 2021-04-03),
    (12, 1, 2020-04-21, 2020-04-30),
    (12, 6, 2020-04-21, 2020-04-26),
    (12, 11, 2020-04-21, 2020-04-25),
    (12, 16, 2020-04-21, 2020-04-24),
    (2, 2, 2021-02-12, 2021-02-23),
    (2, 7, 2021-02-12, 2021-02-16),
    (2, 11, 2021-02-12, 2021-02-15),
    (2, 17, 2021-02-12, 2021-02-14),
    (11, 3, 2019-07-07, 2019-07-10),
    (11, 8, 2019-07-07, 2019-07-10),
    (11, 11, 2019-07-07, 2019-07-09),
    (11, 18, 2019-07-10, 2019-07-11);