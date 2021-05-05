-- ============================================================================== --
-- ============================ CRÉATION DE LA BD =============================== --
-- ============================================================================== --
-- Auteurs de ce script: Yann Berthelot, Amandine Fradet, Florian Legendre


-- ********* RIGHTS ZONE ********* --
DROP TABLE CatBorrower CASCADE CONSTRAINTS;
CREATE TABLE CatBorrower (
    cat_borrower VARCHAR2(250),
    borrowing_max INT NOT NULL,
    CONSTRAINT PK_CatBorrower PRIMARY KEY(cat_borrower),
    CONSTRAINT Check_Borrower_borrowingMax CHECK (borrowing_max > 0)
);


DROP TABLE CatDoc CASCADE CONSTRAINTS;
CREATE TABLE CatDoc (
    cat_document VARCHAR2(250),
    CONSTRAINT PK_CatDoc PRIMARY KEY(cat_document)
);


DROP TABLE Rights CASCADE CONSTRAINTS;
CREATE TABLE Rights (
    cat_borrower VARCHAR2(250),
    cat_document VARCHAR2(250),
    duration INT NOT NULL,
    
    CONSTRAINT PK_Rights PRIMARY KEY (cat_borrower, cat_document),
    CONSTRAINT FK_Rights_Borrower FOREIGN KEY (cat_borrower) REFERENCES CatBorrower(cat_borrower),
    CONSTRAINT FK_Rights_Document FOREIGN KEY (cat_document) REFERENCES CatDoc(cat_document),
    CONSTRAINT Check_Rights_duration CHECK (duration > 0)
);



-- ********* DOCUMENT ZONE ********* --
DROP TABLE Author CASCADE CONSTRAINTS;
CREATE TABLE Author (
    id INT,
    name VARCHAR2(250),
    fst_name VARCHAR2(250),
    address VARCHAR2(250),
    birth DATE,
    CONSTRAINT PK_Author PRIMARY KEY (id)
);


DROP TABLE Editor CASCADE CONSTRAINTS;
CREATE TABLE Editor (
    name VARCHAR2(250),
    address VARCHAR2(250),
    phone INT,
    CONSTRAINT PK_Editor PRIMARY KEY (name)
);


DROP TABLE Keyword CASCADE CONSTRAINTS;
CREATE TABLE Keyword (
    keyword VARCHAR2(250),
    CONSTRAINT PK_Keyword PRIMARY KEY (keyword)
);


DROP TABLE Theme CASCADE CONSTRAINTS;
CREATE TABLE Theme (
    theme VARCHAR2(250),
    CONSTRAINT PK_Theme PRIMARY KEY (theme)
);


DROP TABLE Document CASCADE CONSTRAINTS;
CREATE TABLE Document (
    reference INT,
    title VARCHAR2(250),
    qte INT DEFAULT 0,
    editor VARCHAR2(250),
    theme VARCHAR2(250),
    category VARCHAR2(250) NOT NULL,
    pages INT,
    time INT,
    format VARCHAR2(250),
    nbSubtitles INT,
    CONSTRAINT PK_Document PRIMARY KEY (reference),
    CONSTRAINT FK_Document_Editor FOREIGN KEY (editor) REFERENCES Editor(name),
    CONSTRAINT FK_Document_Theme FOREIGN KEY (theme) REFERENCES Theme(theme),
    CONSTRAINT FK_Document_Category FOREIGN KEY (category) REFERENCES CatDoc(cat_document),
    CONSTRAINT Check_Document_qte CHECK (qte >= 0)
);


DROP TABLE DocumentAuthors CASCADE CONSTRAINTS;
CREATE TABLE DocumentAuthors (
    reference INT,
    author_id INT,
    CONSTRAINT PK_DocumentAuthors PRIMARY KEY (reference, author_id),
    CONSTRAINT FK_DocumentAuthors_reference FOREIGN KEY (reference) REFERENCES Document(reference),
    CONSTRAINT FK_DocumentAuthors_author_id FOREIGN KEY (author_id) REFERENCES Author(id)
);


DROP TABLE DocumentKeywords CASCADE CONSTRAINTS;
CREATE TABLE DocumentKeywords (
    reference INT,
    keyword VARCHAR2(250),
    CONSTRAINT PK_DocumentKeywords PRIMARY KEY (reference, keyword),
    CONSTRAINT FK_DocumentKeywords_reference FOREIGN KEY (reference) REFERENCES Document(reference),
    CONSTRAINT FK_DocumentKeywords_keyword FOREIGN KEY (keyword) REFERENCES Keyword(keyword)
);


DROP TABLE Copy CASCADE CONSTRAINTS;
CREATE TABLE Copy (
    id INT,
    aisleID INT NOT NULL,
    reference INT NOT NULL,    
    CONSTRAINT PK_Copy PRIMARY KEY (id),
    CONSTRAINT FK_Copy_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);



-- ********* BORROWINGS ZONE ********* --
DROP TABLE Borrower CASCADE CONSTRAINTS;
CREATE TABLE Borrower (
    id INT,
    name VARCHAR2(250),
    fst_name VARCHAR2(250),
    address VARCHAR2(250),
    phone NUMBER(10),
    category VARCHAR2(250) NOT NULL,    
    CONSTRAINT PK_Borrower PRIMARY KEY (id),
    CONSTRAINT FK_Borrower_Category FOREIGN KEY (category) REFERENCES CatBorrower(cat_borrower)
);


DROP TABLE Borrow CASCADE CONSTRAINTS;
CREATE TABLE Borrow (
    borrower INT,
    copy INT,
    borrowing_date DATE,
    return_date DATE,
    CONSTRAINT PK_Borrow PRIMARY KEY (borrower, copy, borrowing_date),
    CONSTRAINT FK_Borrow_Borrower FOREIGN KEY (borrower) REFERENCES Borrower(id) ON DELETE CASCADE,
    CONSTRAINT FK_Borrow_Copy FOREIGN KEY (copy) REFERENCES Copy(id)
);


COMMIT;