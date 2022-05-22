import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsScreen extends NavScreen {

  final Book selectedBook;
  final int selectedBookId;

  BookDetailsScreen(super.tabIndex,
  {
    required this.selectedBook,
    required this.selectedBookId,
    super.key,
  }) : super(
    screenTitle: selectedBook.title,
  );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
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

  @override
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
    Books.selectedBookProvider.writable(ref).value = null;
  }

  @override
  RoutePath get routePath => BookDetailsPath(bookId: selectedBookId, tabIndex: tabIndex);
}