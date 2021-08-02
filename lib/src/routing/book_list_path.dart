import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/utility/uri_extensions.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/screens/book_list_screen.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  const BookListPath() :
        super(
          tabIndex: BooksListScreen.navTabIndex,
          resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.path == '/' || uri.isSingleSegmentPath(resourceName) ?
        BookListPath() : null;

  SelectedBookState selectedBookState(TabNavState navState) =>
      stateByType<SelectedBookState>(navState)!;

  @override
  Future<void> configureStateFromUri(TabNavState navState) {
    selectedBookState(navState).value = null;
    return super.configureStateFromUri(navState);
  }
}
