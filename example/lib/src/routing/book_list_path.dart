import 'package:example/src/models/book.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  BookListPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? BookListPath() : null;

  @override
  bool configureStateFromUri(WidgetRef ref) {
    Books.setSelectedBook(ref, null);
    return true;
  }
}
