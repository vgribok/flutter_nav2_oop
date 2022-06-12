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

  static AsyncValue<List<Book>> watchForBooks(WidgetRef ref) =>
    _booksProvider.watch(ref);

  /// We need to store selected book as a Restorable to maintain its state
  /// even when its route is not store in the Navigator history.
  static final RestorableProvider<RestorableIntN> _selectedBookIdProvider =
      RestorableProvider(
          (_) => RestorableIntN(null),
          restorationId: "selected-book-id"
      );

  static List<RestorableProvider> get ephemerals => [_selectedBookIdProvider];

  static final StateProvider<Book?> _selectedBookProvider =
    StateProvider<Book?>(
      (ref) {
        final int? selectedBookId = ref.watch(_selectedBookIdProvider).value;
        if(selectedBookId == null) return null;
        final List<Book>? books = ref.watch(_booksProvider).value;
        return bookById(books, selectedBookId);
      }
    );

  static Book? bookById(List<Book>? books, int? bookId) =>
    bookId == null ? null : books?.firstSafe((book) => book.id == bookId);

  static Book? watchForSelectedBook(WidgetRef ref) =>
      _selectedBookProvider.watch(ref);

  static void setSelectedBook(WidgetRef ref, Book? book) =>
      ref.read(_selectedBookIdProvider).value = book?.id;

  static Future<bool> validateAndSetSelectedBookId(WidgetRef ref, int bookId) async {
    final List<Book> books = await _booksProvider.getUnwatchedFuture(ref);
    final Book? selectedBook = bookById(books, bookId);
    if(selectedBook == null) return false;
    setSelectedBook(ref, selectedBook);
    return true;
  }
}