import 'package:flutter/material.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';
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

  /// We need to store selected book as a Restorable to maintain its state
  /// even when its route is not store in the Navigator history.
  static final RestorableProvider<RestorableIntN> _selectedBookProvider = RestorableProvider(
    (_) => RestorableIntN(null),
    restorationId: "selected-book-id"
  );

  static List<RestorableProvider> get ephemerals => [_selectedBookProvider];

  static int? watchForSelectedBook(WidgetRef ref) =>
      ref.watch(_selectedBookProvider).value;

  static void setSelectedBook(WidgetRef ref, int? bookId) =>
    ref.read(_selectedBookProvider).value = bookId;

    static bool isValidBookId(int? bookId) {
    return bookId != null && bookId >= 0 && bookId < allBooks.length;
  }

  static int bookId(Book? book) => book?.id ?? -1;
  static Book? bookById(int bookId) => isValidBookId(bookId) ? Book.fromId(bookId) : null;
}
