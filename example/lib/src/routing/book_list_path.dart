import 'package:example/src/models/book.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTabIndex = 0;

  BookListPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? BookListPath() : null;

  @override
  void configureStateFromUri(WidgetRef ref) =>
    Books.selectedBookProvider.writable(ref).value = null;
}
