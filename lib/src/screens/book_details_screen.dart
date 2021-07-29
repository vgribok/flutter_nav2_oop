import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/routing/book_details_path.dart';

class BookDetailsScreen extends TabbedNavScreen {
  static const navTabIndex = 0;

  final Book selectedBook;
  final int selectedBookId;

  BookDetailsScreen({
    required this.selectedBook,
    required this.selectedBookId,
    required TabNavState navState
  }) : super(
    pageTitle: selectedBook.title,
    tabIndex: navTabIndex,
    navState: navState
  );

  @override
  Widget buildBody(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Text(selectedBook.title, style: Theme.of(context).textTheme.headline6),
              Text(selectedBook.author, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      );

  @override
  void removeFromNavStackTop() {
    super.removeFromNavStackTop();
    navState.selectedBook.value = null;
  }

  @override
  RoutePath get routePath => BookDetailsPath(bookId: selectedBookId);
}