import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_details_screen.dart';

class BooksListScreen extends NavScreen {

  const BooksListScreen({super.key, required super.tabIndex})
      : super(screenTitle: 'Books');

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {

    final RestorableValue<int?> selectedBookState = Books.selectedBookProvider.writable(ref);

    return ListView(children: [
      for (var book in Books.allBooks)
        ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () => selectedBookState.value = book.id,
          key: book.key,
        )
    ]);
  }

  @override
  NavScreen? topScreen(WidgetRef ref) {
    final int? selectedBookId = ref.watch(Books.selectedBookProvider).value;

    return selectedBookId == null
        ? null
        : BookDetailsScreen(
            selectedBook: Book.fromId(selectedBookId),
            selectedBookId: selectedBookId,
            tabIndex: tabIndex,
        );
    }

  @override
  RoutePath get routePath => BookListPath(tabIndex: tabIndex);
}
