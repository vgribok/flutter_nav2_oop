import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_details_screen.dart';

class BooksListScreen extends NavScreen {
  static const int navTabIndex = 0;

  const BooksListScreen(TabNavModel navState, {super.key})
      : super(screenTitle: 'Books', tabIndex: navTabIndex, navState: navState);

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {

    StateController<Book?> selectedBookState = Books.selectedBookProvider.writabe(ref);

    return ListView(children: [
      for (var book in Books.allBooks)
        ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () => selectedBookState.state = book,
          key: book.key,
        )
    ]);
  }

  @override
  NavScreen? topScreen(WidgetRef ref) {
    Book? selectedBook = ref.watch(Books.selectedBookProvider);

    return selectedBook == null
        ? null
        : BookDetailsScreen(
        selectedBook: selectedBook,
        selectedBookId: selectedBook.id,
        navState: navState);
  }

  @override
  RoutePath get routePath => const BookListPath();
}
