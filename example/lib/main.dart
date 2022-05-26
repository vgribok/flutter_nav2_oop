import 'package:example/src/models/book.dart';
import 'package:example/src/routing/counter_path.dart';
import 'package:example/src/screens/counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:example/src/routing/settings_modal_child_path.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/routing/user_profile_path.dart';
import 'package:example/src/screens/book_list_screen.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:example/src/screens/user_profile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter_nav2_oop/all.dart';

void main() {
  runApp(theApp.riverpodApp);
}

NavAwareApp get theApp => NavAwareApp (
  applicationId: "nav-aware-books-sample",
  appTitle: 'Books With Navigation',
  theme: myTheme,
  initialPath: CounterPath(tabIndex: CounterPath.defaultTabIndex),
  key: const ValueKey("books-sample-app"),

  routeParsers: const [
    BookListPath.fromUri,
    BookDetailsPath.fromUri,
    UserProfilePath.fromUri,
    SettingsPath.fromUri,
    SettingsModalChildPath.fromUri,
    CounterPath.fromUri
  ],

  globalRestorableProviders: [
    Books.selectedBookProvider,
    CounterScreen.counterProvider
  ],

  tabs: [
    TabScreenSlot(Icons.home, title: 'Books',
        rootScreenFactory: (tabIndex, ref) => BooksListScreen(tabIndex)),
    TabScreenSlot(Icons.plus_one, title: 'Counter',
        rootScreenFactory: (tabIndex, ref) => CounterScreen(tabIndex)),
    TabScreenSlot(Icons.settings, title: 'Settings',
        rootScreenFactory: (tabIndex, ref) => SettingsScreen(tabIndex)),
    TabScreenSlot(Icons.person, title: 'User',
        rootScreenFactory: (tabIndex, ref) => UserProfileScreen(tabIndex)),
  ]
);
