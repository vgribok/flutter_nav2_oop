import 'package:example/src/models/book.dart';
import 'package:example/src/screens/book_list_screen.dart';
import 'package:flutter_nav2_oop/all.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  const BookListPath() :
        super(
          tabIndex: BooksListScreen.navTabIndex,
          resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.path == '/' || uri.isSingleSegmentPath(resourceName) ?
        const BookListPath() : null;

  SelectedBookState selectedBookState(NavAwareState navState) =>
      stateByType<SelectedBookState>(navState)!;

  @override
  Future<void> configureStateFromUri(NavAwareState navState) {
    selectedBookState(navState).value = null;
    return super.configureStateFromUri(navState);
  }
}
