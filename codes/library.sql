-- ============================================================= --
-- ================== Script de création BD ==================== --
-- ============================================================= --

DROP TABLE Theme CASCADE CONSTRAINTS;
CREATE TABLE Theme (
    theme VARCHAR2(250),
    CONSTRAINT PK_Theme PRIMARY KEY (theme)
);

DROP TABLE Editor CASCADE CONSTRAINTS;
CREATE TABLE Editor (
    name VARCHAR2(250),
    address VARCHAR2(250),
    phone INT,
    CONSTRAINT PK_Editor PRIMARY KEY (name)
);

DROP TABLE Author CASCADE CONSTRAINTS;
CREATE TABLE Author (
    id INT,
    name VARCHAR2(250),
    fst_name VARCHAR2(250),
    address VARCHAR2(250),
    birth DATE,
    CONSTRAINT PK_Author PRIMARY KEY (id)
);

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


DROP TABLE Document CASCADE CONSTRAINTS;
CREATE TABLE Document (
    reference INT,
    title VARCHAR2(250),
    key_word VARCHAR2(250),
    author INT,
    editor VARCHAR2(250),
    theme VARCHAR2(250),
    category VARCHAR2(250) NOT NULL,
    qte INT,
    CONSTRAINT PK_Document PRIMARY KEY (reference),
    CONSTRAINT FK_Document_Author FOREIGN KEY (author) REFERENCES Author(id),
    CONSTRAINT FK_Document_Editor FOREIGN KEY (editor) REFERENCES Editor(name),
    CONSTRAINT FK_Document_Theme FOREIGN KEY (theme) REFERENCES Theme(theme),
    CONSTRAINT FK_Document_Category FOREIGN KEY (category) REFERENCES CatDoc(cat_document),
    CONSTRAINT Check_Document_qte CHECK (qte >= 0)
);

DROP TABLE Book CASCADE CONSTRAINTS;
CREATE TABLE Book (
    reference INT,
    page INT,    
    CONSTRAINT PK_Book PRIMARY KEY (reference),
    CONSTRAINT FK_Book_Document FOREIGN KEY (reference) REFERENCES Document(reference),
    CONSTRAINT Check_Book_page CHECK (page > 0)
);

DROP TABLE Video CASCADE CONSTRAINTS;
CREATE TABLE Video (
    reference INT,
    time INT,
    format VARCHAR2(250),
    CONSTRAINT PK_Video PRIMARY KEY (reference),
    CONSTRAINT FK_Video_Document FOREIGN KEY (reference) REFERENCES Document(reference),
    CONSTRAINT Check_Video_time CHECK (time > 0)
);

DROP TABLE DVD CASCADE CONSTRAINTS;
CREATE TABLE DVD (
    reference INT,
    time INT,
    CONSTRAINT PK_DVD PRIMARY KEY (reference),
    CONSTRAINT FK_DVD_Document FOREIGN KEY (reference) REFERENCES Document(reference),
    CONSTRAINT Check_DVD_time CHECK (time > 0)
);

DROP TABLE CD CASCADE CONSTRAINTS;
CREATE TABLE CD (
    reference INT,
    time INT,
    subtitle INT,    
    CONSTRAINT PK_CD PRIMARY KEY (reference),
    CONSTRAINT FK_CD_Document FOREIGN KEY (reference) REFERENCES Document(reference),
    CONSTRAINT Check_CD_time CHECK (time > 0),
    CONSTRAINT Check_CD_subtitle CHECK (subtitle >= 0)
);

DROP TABLE Copy CASCADE CONSTRAINTS;
CREATE TABLE Copy (
    id INT,
    aisleID INT,
    reference INT NOT NULL,    
    CONSTRAINT PK_Copy PRIMARY KEY (id),
    CONSTRAINT FK_Copy_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);

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
    CONSTRAINT FK_Borrow_Borrower FOREIGN KEY (borrower) REFERENCES Borrower(id),
    CONSTRAINT FK_Borrow_Copy FOREIGN KEY (copy) REFERENCES Copy(id)
);


-- ============================================================= --
-- ================== Script de création BD ==================== --
-- ============================================================= --

CREATE ASSERTION Assert_Document_category BEFORE INSERT ON Document CHECK 
((SELECT Count(*)
FROM Document doc, Book b, CD c, DVD dvd, Video v
WHERE doc.reference = b.reference 
OR doc.reference = c.reference 
OR doc.reference = dvd.reference 
OR doc.reference = v.reference
GROUP BY reference) = 1);