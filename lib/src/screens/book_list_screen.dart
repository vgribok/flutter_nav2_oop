import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/routing/book_list_path.dart';
import 'package:flutter_nav2_oop/src/screens/book_details_screen.dart';

class BooksListScreen extends TabbedNavScreen {
  static const int navTabIndex = 0;

  const BooksListScreen(TabNavState navState)
      : super(screenTitle: 'Books', tabIndex: navTabIndex, navState: navState);

  @override
  Widget buildBody(BuildContext context) => ListView(children: [
        for (var book in Books.allBooks)
          ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            onTap: () => selectedBookState.value = book,
          )
      ]);

  SelectedBookState get selectedBookState => stateByType<SelectedBookState>()!;
  Book? get selectedBook => selectedBookState.selectedBook;

  @override
  TabbedNavScreen? get topScreen => selectedBook == null
      ? null
      : BookDetailsScreen(
          selectedBook: selectedBook!,
          selectedBookId: selectedBookState.selectedBookId,
          navState: navState);

  @override
  RoutePath get routePath => BookListPath();
}
