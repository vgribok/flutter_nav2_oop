import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/routing/book_list_path.dart';
import 'package:flutter_nav2_oop/src/screens/book_details_screen.dart';

class BooksListScreen extends TabbedNavScreen {

  static const int navTabIndex = 0;

  static final ValueNotifier<Book?> selectedBook = ValueNotifier(null);

  static int get selectedBookId => selectedBook.value == null ? -1 : books.indexOf(selectedBook.value!);
  static set selectedBookId(int bookId) => selectedBook.value = books[bookId];

  static final List<Book> books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  BooksListScreen({required TabNavState navState}) :
    super(
        pageTitle: 'Books',
        tabIndex: navTabIndex,
        navState: navState
    );

  @override
  Widget buildBody(BuildContext context) =>
      ListView(
          children: [
            for (var book in books)
              ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => selectedBook.value = book,
              )
          ]
      );

  static bool isValidBookId(int bookId) {
    return bookId >= 0 && bookId < books.length;
  }

  @override
  TabbedNavScreen? get topScreen =>
      selectedBook.value == null ? null : BookDetailsScreen(selectedBook: selectedBook, selectedBookId: selectedBookId, navState: navState);

  @override
  RoutePath get routePath => BookListPath();
}
