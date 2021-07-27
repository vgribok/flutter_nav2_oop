import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/utility/uri_extensions.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/screens/book_list_screen.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  BookListPath() :
        super(
          navTabIndex: BooksListScreen.navTabIndex,
          resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.path == '/' || uri.isSingleSegmentPath(resourceName) ?
        BookListPath() : null;

  ValueNotifier<Book?> selectedBook(Iterable<ChangeNotifier> stateItems) =>
      myState<ValueNotifier<Book?>>(stateItems);

  @override
  Future<void> configureState(TabNavState navState, List<ChangeNotifier> stateItems) {
    selectedBook(stateItems).value = null;
    return super.configureState(navState, stateItems);
  }
}
