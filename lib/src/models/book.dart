import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';

class Book {
  final String title;
  final String author;

  const Book(this.title, this.author);
}

class Books {
  static const List<Book> allBooks = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  static bool isValidBookId(int? bookId) {
    return bookId != null && bookId >= 0 && bookId < allBooks.length;
  }

  static int bookId(Book? book) => book == null ? -1 : allBooks.indexOf(book);
  static Book? bookById(int bookId) => isValidBookId(bookId) ? null : allBooks[bookId];
}

class SelectedBookState extends ValueNotifier<Book?> {

  SelectedBookState() : super(null);

  Book? get selectedBook => value;
  set selectedBook(Book? book) => value = book;

  int get selectedBookId => Books.bookId(selectedBook);
  set selectedBookId(int bookId) => selectedBook = Books.bookById(bookId);
}

extension NavStateExtensions on TabNavState {
  /// This is all-tabs-wide search for the [SelectedBookState] object.
  ///
  /// It's easier to use than similar tab-, screen- and route-specific
  /// methods, but it requires the programmer to be sure that
  /// there is only a single [SelectedBookState] object in all tab state
  /// collections.
  SelectedBookState get selectedBookState => this.stateByType<SelectedBookState>();
}