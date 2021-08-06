import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

import 'book_details_screen.dart';

class BooksListScreen extends NavScreen {
  static const int navTabIndex = 0;

  const BooksListScreen(NavAwareState navState)
      : super(screenTitle: 'Books', tabIndex: navTabIndex, navState: navState);

  @override
  Widget buildBody(BuildContext context) => ListView(children: [
        for (var book in Books.allBooks)
          ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            onTap: () => selectedBookState.selectedBook = book,
          )
      ]);

  @protected
  SelectedBookState get selectedBookState => stateByType<SelectedBookState>()!;

  @protected
  Book? get selectedBook => selectedBookState.selectedBook;

  @override
  NavScreen? get topScreen => selectedBook == null
      ? null
      : BookDetailsScreen(
          selectedBook: selectedBook!,
          selectedBookId: selectedBookState.selectedBookId,
          navState: navState);

  @override
  RoutePath get routePath => BookListPath();
}
