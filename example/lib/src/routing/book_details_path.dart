import 'package:example/src/models/book.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'book_list_path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsPath extends DetailsRoutePath {

  static const String resourceName = BookListPath.resourceName; // 'books'

  BookDetailsPath({required int bookId}) : super(
    resource: resourceName,
    id: bookId
  );

  static RoutePath? fromUri(Uri uri) =>
    DetailsRoutePath.fromUri(resourceName, uri, (stringId) {
      int? bookId = int.tryParse(stringId);
      return bookId == null ? null : BookDetailsPath(bookId: bookId);
    });

  @override
  bool configureStateFromUri(WidgetRef ref) {
    if(!Books.isValidBookId(id)) {
      return false;
    }
    Books.selectedBookProvider.writable(ref).value = id;
    return true;
  }
}