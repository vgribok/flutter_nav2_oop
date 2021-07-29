import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/details_route_path.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/utility/uri_extensions.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/screens/book_details_screen.dart';
import 'package:flutter_nav2_oop/src/screens/book_list_screen.dart';

import 'book_list_path.dart';

class BookDetailsPath extends DetailsRoutePath {

  static const String resourceName = BookListPath.resourceName; // 'books'

  const BookDetailsPath({required int bookId}) : super(
    navTabIndex: BookDetailsScreen.navTabIndex,
    resource: resourceName,
    id: bookId
  );

  static RoutePath? fromUri(Uri uri) {
    final pathSegments = uri.nonEmptyPathSegments;

    if(pathSegments.length == 2 && pathSegments[0] == resourceName) {
      int? bookId = int.tryParse(uri.pathSegments[1]);
      if(bookId != null && BooksListScreen.isValidBookId(bookId)) {
        return BookDetailsPath(bookId: bookId);
      }
    }
    return null;
  }

  @override
  Future<void> configureStateFromUri(TabNavState navState) {
    navState.selectedBook.value = Books.allBooks[id];
    return super.configureStateFromUri(navState);
  }
}