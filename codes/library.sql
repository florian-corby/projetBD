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

DROP TABLE Rights CASCADE CONSTRAINTS;
CREATE TABLE Rights (
    cat_borrower VARCHAR2(250),
    cat_document VARCHAR2(250),
    duration INT,
    borrowing_max INT,
    CONSTRAINTS PK_Rights PRIMARY KEY (cat_borrower, cat_document, duration)
);

DROP TABLE Document CASCADE CONSTRAINTS;
CREATE TABLE Document (
    reference INT,
    title VARCHAR2(250),
    key_word VARCHAR2(250),
    author INT,
    editor VARCHAR2(250),
    theme VARCHAR2(250),
    category VARCHAR2(250),
    qte INT,    
    CONSTRAINT PK_Document PRIMARY KEY (reference),
    CONSTRAINT FK_Document_Author FOREIGN KEY (author) REFERENCES Author(id),
    CONSTRAINT FK_Document_Editor FOREIGN KEY (editor) REFERENCES Editor(name),
);

DROP TABLE Book CASCADE CONSTRAINTS;
CREATE TABLE Book (
    reference INT,
    page INT,    
    CONSTRAINTS PK_Book PRIMARY KEY (reference),
    CONSTRAINT FK_Book_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);

DROP TABLE Video CASCADE CONSTRAINTS;
CREATE TABLE Video (
    reference INT,
    time INT,
    format VARCHAR2(250),
    CONSTRAINTS PK_Video PRIMARY KEY (reference),
    CONSTRAINT FK_Video_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);

DROP TABLE DVD CASCADE CONSTRAINTS;
CREATE TABLE DVD (
    reference INT,
    time INT,
    CONSTRAINTS PK_DVD PRIMARY KEY (reference),
    CONSTRAINT FK_DVD_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);

DROP TABLE CD CASCADE CONSTRAINTS;
CREATE TABLE CD (
    reference INT,
    time INT,
    subtitle INT,    
    CONSTRAINTS PK_CD PRIMARY KEY (reference),
    CONSTRAINT FK_CD_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);

DROP TABLE Copy CASCADE CONSTRAINTS;
CREATE TABLE Copy (
    id INT,
    department INT,
    reference INT,    
    CONSTRAINTS PK_Copy PRIMARY KEY (id),
    CONSTRAINT FK_Copy_Document FOREIGN KEY (reference) REFERENCES Document(reference)
);

DROP TABLE Borrower CASCADE CONSTRAINTS;
CREATE TABLE Borrower (
    id INT,
    name VARCHAR2(250),
    fst_name VARCHAR2(250),
    address VARCHAR2(250),
    phone NUMBER(10),
    category VARCHAR2(250),    
    CONSTRAINTS PK_Borrower PRIMARY KEY (id)
);

DROP TABLE Borrow CASCADE CONSTRAINTS;
CREATE TABLE Borrow (
    borrower INT,
    copy INT,
    borrowing_date DATE,
    return_date DATE,
    CONSTRAINTS PK_Borrow PRIMARY KEY (borrower, copy, borrowing_date),
    CONSTRAINT FK_Borrow_Borrower FOREIGN KEY (borrower) REFERENCES Borrower(id),
    CONSTRAINT FK_Borrow_Copy FOREIGN KEY (copy) REFERENCES Copy(id)
);