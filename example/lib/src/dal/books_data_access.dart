import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/src/models/book.dart';

extension BookEx on Book {
  Key get key => ValueKey("book-$id");
}

class BookData {

  static final FutureProvider<List<Book>> _booksProvider = FutureProvider<List<Book>>((ref) async {
    // Simulate long-ish API call to retrieve data
    await Future.delayed(const Duration(milliseconds: 750));

    return [
      const Book(id: 0, title: 'Stranger in a Strange Land', author: 'Robert A. Heinlein'),
      const Book(id: 1, title: 'Foundation', author: 'Isaac Asimov'),
      const Book(id: 2, title: 'Fahrenheit 451', author: 'Ray Bradbury'),
    ];
  });

  static Future<List<Book>> getUnwatchedBooksFuture(WidgetRef ref) =>
    _booksProvider.getUnwatchedFuture(ref);
  static AsyncValue<List<Book>> watchForBooks(WidgetRef ref) =>
    _booksProvider.watch(ref);

  /// We need to store selected book as a Restorable to maintain its state
  /// even when its route is not store in the Navigator history.
  static final RestorableProvider<RestorableIntN> _selectedBookProvider = RestorableProvider(
          (_) => RestorableIntN(null),
      restorationId: "selected-book-id"
  );

  static List<RestorableProvider> get ephemerals => [_selectedBookProvider];

  static Book? watchForSelectedBook(WidgetRef ref) {
    final int? selectedBookId = ref.watch(_selectedBookProvider).value;
    if(selectedBookId == null) return null;
    final List<Book>? books = watchForBooks(ref).value;
    return books?.firstSafe((book) => book.id == selectedBookId);
  }

  static void setSelectedBook(WidgetRef ref, Book? book) =>
      ref.read(_selectedBookProvider).value = book?.id;

  static Future<bool> validateAndSetSelectedBookId(WidgetRef ref, int bookId) async {
    final List<Book> books = await BookData.getUnwatchedBooksFuture(ref);
    final Book? selectedBook = books.firstSafe((book) => book.id == bookId);
    if(selectedBook == null) return false;
    BookData.setSelectedBook(ref, selectedBook);
    return true;
  }
}