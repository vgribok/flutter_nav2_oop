import 'package:example/src/models/book.dart';
import 'package:example/src/screens/book_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/provider.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  const BookListPath({BuildContext? context}) :
        super(
          context: context,
          tabIndex: BooksListScreen.navTabIndex,
          resource: resourceName);

  static RoutePath? fromUri(Uri uri, BuildContext context) =>
      uri.path == '/' || uri.isSingleSegmentPath(resourceName) ?
        BookListPath(context: context) : null;

  // SelectedBookState selectedBookState(NavAwareState navState) =>
  //     stateByType<SelectedBookState>(navState)!;

  @override
  Future<void> configureStateFromUri() {
    Provider.of<SelectedBookState>(context!, listen: false).value = null;
    return super.configureStateFromUri();
  }
}
