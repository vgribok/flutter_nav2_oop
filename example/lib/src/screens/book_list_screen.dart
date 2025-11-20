import 'package:example/src/dal/books_data_access.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'book_details_screen.dart';

class BooksListScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  const BooksListScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key})
      : super(screenTitle: 'Books');

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
      AsyncValueAwaiter<List<Book>>(
        asyncData: booksProvider.getBooks(ref),
        onRetry: () => booksProvider.invalidate(ref),
        builder: (books) => RefreshIndicator(
          onRefresh: () async => booksProvider.invalidate(ref),
          child: ListView(
            children: [
              for (final book in books)
                ListTile(
                  key: ValueKey(book.id),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () => booksProvider.setSelectedBookId(ref, book.id),
                )
            ],
          ),
        ),
      );

  @override
  NavScreen? topScreen(WidgetRef ref) {
    final Book? selectedBook = booksProvider.getSelectedBook(ref);
    return selectedBook == null
        ? null
        : BookDetailsScreen(tabIndex, selectedBook: selectedBook);
  }

  @override
  RoutePath get routePath => BookListPath();
}
