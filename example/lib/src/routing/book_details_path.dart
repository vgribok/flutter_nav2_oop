import 'package:example/src/models/book.dart';
import 'package:example/src/screens/book_details_screen.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'book_list_path.dart';

class BookDetailsPath extends DetailsRoutePath {

  static const String resourceName = BookListPath.resourceName; // 'books'

  const BookDetailsPath({required int bookId}) : super(
    navTabIndex: BookDetailsScreen.navTabIndex,
    resource: resourceName,
    id: bookId
  );

  static RoutePath? fromUri(Uri uri) =>
    DetailsRoutePath.fromUri(resourceName, uri, (stringId) {
      int? bookId = int.tryParse(stringId);
      return Books.isValidBookId(bookId) ? BookDetailsPath(bookId: bookId!) : null;
    });

  SelectedBookState selectedBookState(TabNavModel navState) =>
      stateByType<SelectedBookState>(navState)!;

  @override
  Future<void> configureStateFromUri(TabNavModel navState) {
    selectedBookState(navState).value = Books.allBooks[id];
    return super.configureStateFromUri(navState);
  }
}