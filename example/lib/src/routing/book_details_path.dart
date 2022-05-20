import 'package:example/src/models/book.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'book_list_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsPath extends DetailsRoutePath {

  static const String resourceName = BookListPath.resourceName; // 'books'

  BookDetailsPath({required int bookId, required super.tabIndex}) : super(
    resource: resourceName,
    id: bookId
  ) {
    assert(tabIndex == BookListPath.defaultTabIndex);
  }

  static RoutePath? fromUri(Uri uri) =>
    DetailsRoutePath.fromUri(resourceName, uri, (stringId) {
      int? bookId = int.tryParse(stringId);
      return Books.isValidBookId(bookId) ? BookDetailsPath(bookId: bookId!, tabIndex: BookListPath.defaultTabIndex) : null;
    });

  @override
  void configureStateFromUri(WidgetRef ref) =>
    Books.selectedBookProvider.writable(ref).value = id;
}