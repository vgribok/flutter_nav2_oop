import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/provider.dart';

import 'book_details_screen.dart';

class BooksListScreen extends NavScreen {
  static const int navTabIndex = 0;

  const BooksListScreen()
      : super(screenTitle: 'Books', tabIndex: navTabIndex);

  @override
  Widget buildBody(BuildContext context) =>
      ListView(children: [
        for (var book in Books.allBooks)
          ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            onTap: () =>
                Provider.of<SelectedBookState>(context, listen: false)
                    .selectedBook = book,
          )
      ]);

  // @protected
  // SelectedBookState get selectedBookState => stateByType<SelectedBookState>()!;

  // @protected
  // Book? get selectedBook => selectedBookState.selectedBook;

  @override
  NavScreen? topScreen(BuildContext context) {
    final SelectedBookState selectedBookState = Provider.of<SelectedBookState>(context, listen: true);
    final Book? selectedBook = selectedBookState.selectedBook;
    return selectedBook == null
        ? null
        : BookDetailsScreen(
            selectedBook: selectedBook!,
            selectedBookId: selectedBookState.selectedBookId
            );
  }

  @override
  RoutePath get routePath => const BookListPath();
}
