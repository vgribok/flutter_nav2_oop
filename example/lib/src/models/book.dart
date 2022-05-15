import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Book {
  final String title;
  final String author;

  const Book(this.title, this.author);

  factory Book.fromId(int id) => Books.allBooks[id];

  int get id => Books.allBooks.indexOf(this);

  Key get key => ValueKey("book-$author-$title");
}

class Books {
  static const List<Book> allBooks = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  static final selectedBookProvider = StateProvider<Book?>((ref) => null);

  static bool isValidBookId(int? bookId) {
    return bookId != null && bookId >= 0 && bookId < allBooks.length;
  }

  static int bookId(Book? book) => book?.id ?? -1;
  static Book? bookById(int bookId) => isValidBookId(bookId) ? null : Book.fromId(bookId);
}
