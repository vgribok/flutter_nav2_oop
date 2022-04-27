import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends NavScreen {
  static const navTabIndex = 0;

  final Book selectedBook;
  final int selectedBookId;

  BookDetailsScreen({
    required this.selectedBook,
    required this.selectedBookId,
    required List<ChangeNotifierProvider> providers
  }) : super(
    screenTitle: selectedBook.title,
    tabIndex: navTabIndex,
    providers: providers
  );

  @override
  Widget buildBody(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Text(selectedBook.title, style: Theme.of(context).textTheme.headline6),
              Text(selectedBook.author, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      );

  // SelectedBookState get selectedBookState => stateByType<SelectedBookState>()!;

  @override
  void updateStateOnScreenRemovalFromNavStackTop(NavAwareState navState, BuildContext context) {
    super.updateStateOnScreenRemovalFromNavStackTop(navState, context);
    Provider.of<SelectedBookState>(context, listen: false).selectedBook = null;
  }

  @override
  RoutePath get routePath => BookDetailsPath(bookId: selectedBookId);
}