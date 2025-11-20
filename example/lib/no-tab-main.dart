import 'package:example/src/providers/books_provider.dart';
import 'package:example/src/providers/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:example/theme.dart';
import 'package:flutter_nav2_oop/all.dart';

/// Run this file to see NON-tab-based navigation demo
void main() {
  runApp(theApp.riverpodApp);
}
/// Simulating some long-ish async app initialization
/// logic, possibly with exceptions thrown
Future<void> _appInitSimulator(Ref ref) async {
  // Simulating an error in the initialization routine
  await Future.delayed(const Duration(milliseconds: 3000));
  //throw UnimplementedError("Something bad has happened..");
}

NavAwareApp get theApp => NavAwareApp (
    applicationId: "nav-aware-books-sample",
    appTitle: 'Books With Navigation',
    theme: mainColor.toTheme(),
    darkTheme: mainColor.toDarkTheme(),
    initialPath: BookDetailsPath(bookId: 2),
    appGlobalStateInitProvider: FutureProvider(_appInitSimulator),
    key: const ValueKey("books-sample-app"),

    // Remove throw and uncomment screen constructor to support non-tab navigation
    rootScreenFactory: (ref) => throw UnimplementedError(), //const BooksListScreen(),

    routeParsers: const [
      BookListPath.fromUri,
      BookDetailsPath.fromUri,
      // UserProfilePath.fromUri,
      // SettingsPath.fromUri,
      // SettingsModalChildPath.fromUri,
      // CounterPath.fromUri
    ],

    globalRestorableProviders: [
      restorableSelectedBookIdProvider,
      restorableCounterProvider,
    ]
);
