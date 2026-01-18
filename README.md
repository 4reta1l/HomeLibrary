Home Library Management App

Project written in Swift.

Objective:
The goal of this project is to design and develop a Home Library Management App, allowing users to
effectively manage their personal book collections. This app will help users keep track of the books
they own, their reading progress, and organize them in categories such as genre, author, or series.


Key Features:

1. Book Management: \n
  o Add new books with details such as title, author, genre, publication year, ISBN, and number of pages.
  o Edit or remove book entries.
  o Search for books by title and author.
  o Filter books by author, genre, or year.

2. Reading Progress:
  o Track reading progress for each book (e.g., unread, reading, completed).
  o Option to add and update notes for each book.

3. Categorization:
   o Option to create custom categories.

4. Library Overview:
   o Display total number of books, categories, and reading status breakdown (e.g., number of unread, reading, or completed books).
   o Display a summary page with recommended books based on user’s library.

5. User Interaction:
   o Simple and intuitive user interface.

6. Export & Import Data:
   o Ability to export the library data in formats like CSV or JSON.
   o Option to import books from external sources (e.g., CSV file).

7. Business rules:
   o Each book can have many author but it doesn’t have to have one
   o Each author can write many books (at least one)
   o Each publisher can publish many books (at least one)
   o Each book is published by exactly one publisher
   o Each series can have many books (at least one)
   o Each book belongs to at most one series
   o Each series can be written by many authors (at least one)
   o Each author can have many books’ series
   o Each book can represent many genres but it doesn’t have to represent any
   o Each genre can have many books but it doesn’t have to have one
   o Each book can belong to one category
   o Each category can have many books but it doesn’t have to have one
