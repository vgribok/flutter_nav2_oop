import 'package:example/src/models/book.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTabIndex = 0;

  const BookListPath({required super.tabIndex}) :
      super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? const BookListPath(tabIndex: defaultTabIndex) : null;

  @override
  void configureStateFromUri(WidgetRef ref) =>
    Books.selectedBookProvider.writable(ref).value = null;
}
