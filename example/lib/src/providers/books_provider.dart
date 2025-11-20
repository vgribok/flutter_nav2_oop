import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';
import 'package:example/src/models/book.dart';

part 'books_provider.g.dart';

final restorableSelectedBookIdProvider = restorableProvider<RestorableIntN>(
  create: (ref) => RestorableIntN(null),
  restorationId: 'selected-book-id',
);

@riverpod
Future<List<Book>> books(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 750));
  final int timestamp = DateTime.now().second;
  if ((timestamp % 10) == 0) {
    throw Exception("Demo exception - retry to load books");
  }
  return const [
    Book(id: 0, title: 'Stranger in a Strange Land', author: 'Robert A. Heinlein'),
    Book(id: 1, title: 'Foundation', author: 'Isaac Asimov'),
    Book(id: 2, title: 'Fahrenheit 451', author: 'Ray Bradbury'),
  ];
}
