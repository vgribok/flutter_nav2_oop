import 'package:example/src/dal/books_data_access.dart';
import 'package:flutter_nav2_oop/all.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  BookListPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? BookListPath() : null;

  @override
  bool configureStateFromUri(WidgetRef ref) {
    booksProvider.setSelectedBookId(ref, null);
    return true;
  }
}
