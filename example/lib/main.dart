import 'package:example/src/dal/stories_data.access.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/routing/counter_path.dart';
import 'package:example/src/routing/story/stories_path.dart';
import 'package:example/src/routing/story/story_path.dart';
import 'package:example/src/screens/counter_screen.dart';
import 'package:example/src/screens/story/stories_list_screen.dart';
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

/// Run this file to see tab-based navigation demo
void main() {
  runApp(theApp.riverpodApp);
}

TabNavAwareApp get theApp => TabNavAwareApp(
  applicationId: "nav-aware-books-sample",
  appTitle: 'Books With Navigation',
  theme: myTheme,
  initialPath: CounterPath(),
  key: const ValueKey("books-sample-app"),

  globalRestorableProviders: [
    ...Books.ephemerals,
    ...CounterScreen.ephemerals,
    ...Stories.ephemerals,
    ...StoryEx.ephemerals
  ],

  tabs: [
    // Comment out this section to enable non-tab navigation demo
    TabScreenSlot(Icons.home, title: 'Books',
        rootScreenFactory: (tabIndex, ref) => BooksListScreen(tabIndex),
        routeParsers: [ BookListPath.fromUri, BookDetailsPath.fromUri ]
    ),
    TabScreenSlot(Icons.plus_one, title: 'Counter',
        rootScreenFactory: (tabIndex, ref) => CounterScreen(tabIndex),
        routeParsers: [ CounterPath.fromUri ]
    ),
    TabScreenSlot(Icons.settings, title: 'Settings',
        rootScreenFactory: (tabIndex, ref) => SettingsScreen(tabIndex),
        routeParsers: [ SettingsPath.fromUri, SettingsModalChildPath.fromUri ]
    ),
    TabScreenSlot(Icons.person, title: 'User',
        rootScreenFactory: (tabIndex, ref) => UserProfileScreen(tabIndex),
        routeParsers: [ UserProfilePath.fromUri ]
    ),
    TabScreenSlot(
        Icons.interests, title: "Stories",
        rootScreenFactory: (tabIndex, ref) => StoriesListScreen(tabIndex),
        routeParsers: [ StoriesPath.fromUri, StoryPath.fromUri ]
    )
  ]
);
