import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_details_screen.dart';

class BooksListScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  const BooksListScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key})
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
        : BookDetailsScreen(tabIndex, // Comment this line to enable non-tab navigation
            selectedBook: Book.fromId(selectedBookId),
            selectedBookId: selectedBookId,
        );
    }

  @override
  RoutePath get routePath => BookListPath();
}
