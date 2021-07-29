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

  static final ValueNotifier<Book?> selectedBook = ValueNotifier(null);
}

extension NavStateExtensions on TabNavState {
  ValueNotifier<Book?> get selectedBook => this.stateByType<ValueNotifier<Book?>>();

  int get selectedBookId => selectedBook.value == null ? -1 : Books.allBooks.indexOf(selectedBook.value!);
  set selectedBookId(int bookId) => selectedBook.value = Books.allBooks[bookId];
}