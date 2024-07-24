import 'package:example/src/dal/books_data_access.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  final Book selectedBook;

  BookDetailsScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
  {
    required this.selectedBook,
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
              Text(selectedBook.title, style: Theme.of(context).textTheme.headlineSmall),
              Text(selectedBook.author, style: Theme.of(context).textTheme.titleMedium),
            ],
          ],
        ),
      );

  @override
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
    booksProvider.setSelectedBook(ref, null);
  }

  @override
  RoutePath get routePath => BookDetailsPath(bookId: selectedBook.id);
}