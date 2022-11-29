import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/src/models/book.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';

extension BookEx on Book {
  Key get key => ValueKey("book-$id");
}

final BooksProvider booksProvider = BooksProvider();

class BooksProvider extends FutureProviderFacade<List<Book>> {

  BooksProvider() : super(
    (ref) async {

        // Simulate long-ish API call to retrieve data
        await Future.delayed(const Duration(milliseconds: 750));
        // Simulate throwing an exception
        final int timestamp = DateTime.now().second;
        if((timestamp % 3) == 0) {
          throw Exception("Demo exception to simulate data retrieval failure");
        }

        return [
          const Book(id: 0, title: 'Stranger in a Strange Land', author: 'Robert A. Heinlein'),
          const Book(id: 1, title: 'Foundation', author: 'Isaac Asimov'),
          const Book(id: 2, title: 'Fahrenheit 451', author: 'Ray Bradbury'),
        ];
    }
  );

  final _selectedBookIdProvider = RestorableIntProviderFacadeN(
      restorationId: "selected-book-id"
  );

  List<RestorableProvider> get ephemerals => [_selectedBookIdProvider.restorableProvider];

  late final StateProvider<Book?> _selectedBookProvider = StateProvider<Book?>(
      (ref) {
        final int? selectedBookId = _selectedBookIdProvider.watchValue2(ref);
        if(selectedBookId == null) return null;
        final List<Book>? books = watchForValue2(ref);
        return _bookById(books, selectedBookId);
      }
  );

  static Book? _bookById(List<Book>? books, int? bookId) =>
      bookId == null ? null : books?.firstSafe((book) => book.id == bookId);

  Book? watchForSelectedBook(WidgetRef ref) =>
      _selectedBookProvider.watch(ref);

  void setSelectedBook(WidgetRef ref, Book? book) =>
      _selectedBookIdProvider.setValue(ref, book?.id);

  Future<bool> validateAndSetSelectedBookId(WidgetRef ref, int bookId) async {
    final List<Book> books = await getUnwatchedFuture(ref);
    final Book? selectedBook = _bookById(books, bookId);
    if(selectedBook == null) return false;
    setSelectedBook(ref, selectedBook);
    return true;
  }
}
