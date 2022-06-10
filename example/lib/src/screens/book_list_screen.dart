import 'package:example/src/dal/books_data_access.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_details_screen.dart';

class BooksListScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  const BooksListScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key})
      : super(screenTitle: 'Books');

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    BookData.watchForBooks(ref).when(
      error: (e, stack) => Center(child: Text("Error: $e")),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (books) =>
        ListView(children: [
          for (Book book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => BookData.setSelectedBook(ref, book),
              key: book.key,
            )
        ])
    );

  @override
  NavScreen? topScreen(WidgetRef ref) {
    final Book? selectedBook = BookData.watchForSelectedBook(ref);

    return selectedBook == null
        ? null
        : BookDetailsScreen(tabIndex, // Comment this line to enable non-tab navigation
            selectedBook: selectedBook
        );
    }

  @override
  RoutePath get routePath => BookListPath();
}
