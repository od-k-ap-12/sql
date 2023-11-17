--USE master

--IF EXISTS (SELECT name FROM master.sys.databases WHERE name='LibraryDB')
--DROP DATABASE LibraryDB
--GO

--CREATE DATABASE LibraryDB
--GO

USE LibraryDB; 
GO

--INSERT INTO Books (Title, Author, PublicationYear, Genre, CopiesAvailable) VALUES ('To Kill a Mockingbird', 'Harper Lee', 1960, 'Fiction', 5), ('1984', 'George Orwell', 1949, 'Science Fiction', 7), ('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Fiction', 3), ('Pride and Prejudice', 'Jane Austen', 1813, 'Fiction', 8), ('The Catcher in the Rye', 'J.D. Salinger', 1951, 'Fiction', 4), ('The Hobbit', 'J.R.R. Tolkien', 1937, 'Fantasy', 6), ('The Lord of the Rings', 'J.R.R. Tolkien', 1954, 'Fantasy', 10), ('Brave New World', 'Aldous Huxley', 1932, 'Science Fiction', 5), ('Fahrenheit 451', 'Ray Bradbury', 1953, 'Science Fiction', 6), ('The Alchemist', 'Paulo Coelho', 1988, 'Fiction', 4), ('Moby-Dick', 'Herman Melville', 1851, 'Adventure', 2), ('War and Peace', 'Leo Tolstoy', 1869, 'Historical Fiction', 3), ('The Odyssey', 'Homer', -800, 'Epic', 7), ( 'Crime and Punishment', 'Fyodor Dostoevsky', 1866, 'Crime', 5), ('The Shining', 'Stephen King', 1977, 'Horror', 4)


--CREATE TYPE genre
--FROM nvarchar(100) NOT NULL
--GO

--CREATE TABLE BookGenres
--(
--GenreId int PRIMARY KEY IDENTITY(1,1),
--GenreName genre NOT NULL
--)
--GO
--INSERT INTO BookGenres
--VALUES('Science Fiction'),('Fiction'),('Fantasy'),('Adventure'),('Epic'),('Crime'),('Horror')

--CREATE TABLE Books 
--( 
--BookID int PRIMARY KEY IDENTITY(1,1), 
--Title nvarchar(100) NOT NULL,
--Author nvarchar(100) NOT NULL, 
--PublicationYear int, 
--GenreID int NOT NULL FOREIGN KEY REFERENCES BookGenres(GenreId) , 
--CopiesAvailable int 
--);

--INSERT INTO Books (Title, Author, PublicationYear, GenreID, CopiesAvailable) VALUES ('To Kill a Mockingbird', 'Harper Lee', 1960, 2, 5), ('1984', 'George Orwell', 1949, 1, 7), ('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 2, 3), ('Pride and Prejudice', 'Jane Austen', 1813, 2, 8), ('The Catcher in the Rye', 'J.D. Salinger', 1951, 2, 4), ('The Hobbit', 'J.R.R. Tolkien', 1937, 3, 6), ('The Lord of the Rings', 'J.R.R. Tolkien', 1954, 3, 10), ('Brave New World', 'Aldous Huxley', 1932, 1, 5), ('Fahrenheit 451', 'Ray Bradbury', 1953, 1, 6), ('The Alchemist', 'Paulo Coelho', 1988, 2, 4), ('Moby-Dick', 'Herman Melville', 1851, 4, 2), ('War and Peace', 'Leo Tolstoy', 1869, 2, 3), ('The Odyssey', 'Homer', -800, 5, 7), ( 'Crime and Punishment', 'Fyodor Dostoevsky', 1866, 6, 5), ('The Shining', 'Stephen King', 1977, 7, 4)


--1. Треба створити власний тип даних для жанрів книг. 

--Та застосувати його для таблиці BookGenres

--2. Треба створити правила для кількості доступних примірників книг

--3. Створити та прив’язати правило для року публікації (от 1600 року)

--4. Змінити правило для року публікації (от 1800 року до поточного)

CREATE RULE copiesavailable_rule  
AS   
@range<= 50
 
GO
 
EXEC sp_bindrule copiesavailable_rule, 'Books.CopiesAvailable'
GO

CREATE RULE publicationyear_rule  
AS   
@range>= 1600
GO
 
EXEC sp_bindrule copiesavailable_rule, 'Books.PublicationYear'

DROP RULE publicationyear_rule
GO


CREATE RULE publicationyear_rule  
AS   
@range>= 1800 AND @range<=2023
GO
 
EXEC sp_bindrule copiesavailable_rule, 'Books.PublicationYear'

--5. Створити тимчасову локальну таблицю, в яку обрати всі книжки жанру 'Horror’

--6. Створити тимчасову глобальну таблицю, в яку обрати всі книжки, які були опубліковані після 1982 року. 


SELECT Books.Title INTO #horrortemp 
FROM Books, BookGenres
WHERE Books.GenreID=BookGenres.GenreId AND BookGenres.GenreName='Horror'
GO

SELECT * FROM #horrortemp
GO

SELECT Books.Title, Books.PublicationYear INTO ##after1982temp 
FROM Books
WHERE Books.PublicationYear>1982
GO

SELECT * FROM ##after1982temp
GO


