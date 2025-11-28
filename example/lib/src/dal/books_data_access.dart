import 'package:example/src/models/book.dart';
import 'package:example/src/providers/books_provider.dart' as providers;
import 'package:flutter_nav2_oop/all.dart';

extension BookListEx on List<Book> {
  Book? getById(int? bookId) =>
      bookId == null ? null : firstSafeWhere((b) => b.id == bookId);
  
  bool existsById(int bookId) => any((b) => b.id == bookId);
}

class BooksDataAccess {
  // Provider access helpers
  int? _watchSelectedBookId(WidgetRef ref) => 
      ref.watch(providers.restorableSelectedBookIdProvider).value;
  
  void _setSelectedBookId(WidgetRef ref, int? id) => 
      ref.read(providers.restorableSelectedBookIdProvider).value = id;
  
  // Public API
  AsyncValue<List<Book>> getBooks(WidgetRef ref) => 
      ref.watch(providers.booksProvider);
  
  Future<List<Book>> getBooksAsync(WidgetRef ref) async =>
      await ref.read(providers.booksProvider.future);
  
  int? getSelectedBookId(WidgetRef ref) => _watchSelectedBookId(ref);
  
  void setSelectedBookId(WidgetRef ref, int? id) => _setSelectedBookId(ref, id);
  
  Book? getSelectedBook(WidgetRef ref) {
    final bookId = _watchSelectedBookId(ref);
    if (bookId == null) return null;
    
    final books = ref.watch(providers.booksProvider).value;
    return books?.getById(bookId);
  }

  Future<bool> selectBookIfExists(WidgetRef ref, int bookId) async {
    final books = await getBooksAsync(ref);
    final exists = books.existsById(bookId);
    if (exists) setSelectedBookId(ref, bookId);
    return exists;
  }

  void invalidate(WidgetRef ref) => ref.invalidate(providers.booksProvider);
}

final booksDal = BooksDataAccess();
