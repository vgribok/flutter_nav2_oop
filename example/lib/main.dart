import 'package:example/src/models/book.dart';
import 'package:example/src/routing/counter_path.dart';
import 'package:example/src/screens/counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  runApp(ProviderScope(child: BooksApp()));
}

class BooksApp extends NavAwareApp {

  BooksApp({super.key}) :
      super(
        applicationId: "nav-aware-books-sample",
        appTitle: 'Books With Navigation',
        theme: myTheme,
        initialPath: const CounterPath(),

        routeParsers: [
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
          TabInfo(
              icon: Icons.home,
              title: 'Books',
              rootScreenFactory: () => const BooksListScreen()
          ),
          TabInfo(
            icon: Icons.plus_one,
            title: 'Counter',
            rootScreenFactory: () => const CounterScreen()
          ),
          TabInfo(
              icon: Icons.settings,
              title: 'Settings',
              rootScreenFactory: () => const SettingsScreen()
          ),
          TabInfo(
              icon: Icons.person,
              title: 'User',
              rootScreenFactory: () => const UserProfileScreen()
          ),
        ]
      );
}