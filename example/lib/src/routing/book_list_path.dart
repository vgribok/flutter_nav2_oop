import 'package:example/src/models/book.dart';
import 'package:example/src/screens/book_list_screen.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  const BookListPath() :
      super(
        tabIndex: BooksListScreen.navTabIndex,
        resource: resourceName
      );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? const BookListPath() : null;

  @override
  Future<void> configureStateFromUri(WidgetRef ref) {
    Books.selectedBookProvider.writable(ref).value = null;
    return super.configureStateFromUri(ref);
  }
}
