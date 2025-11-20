import 'package:example/src/models/book.dart';
import 'package:example/src/providers/books_provider.dart' as providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BooksDataAccess {
  AsyncValue<List<Book>> getBooks(WidgetRef ref) => 
      ref.watch(providers.booksProvider);
  
  int? getSelectedBookId(WidgetRef ref) => 
      ref.watch(providers.restorableSelectedBookIdProvider).value;
  
  void setSelectedBookId(WidgetRef ref, int? id) => 
      ref.read(providers.restorableSelectedBookIdProvider).value = id;
  
  Book? getSelectedBook(WidgetRef ref) {
    final bookId = getSelectedBookId(ref);
    if (bookId == null) return null;
    final books = ref.watch(providers.booksProvider).value;
    if (books == null) return null;
    try {
      return books.firstWhere((b) => b.id == bookId);
    } catch (_) {
      return null;
    }
  }

  Future<bool> selectBookIfExists(WidgetRef ref, int bookId) async {
    final books = await ref.read(providers.booksProvider.future);
    final exists = books.any((b) => b.id == bookId);
    if (exists) setSelectedBookId(ref, bookId);
    return exists;
  }

  void invalidate(WidgetRef ref) => ref.invalidate(providers.booksProvider);

  List<NotifierProvider> get ephemerals => [
    providers.restorableSelectedBookIdProvider,
  ];
}

final booksProvider = BooksDataAccess();
