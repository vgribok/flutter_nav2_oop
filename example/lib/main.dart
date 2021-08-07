import 'package:flutter/material.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/models/show_settings_modal_state.dart';
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
  runApp(BooksApp());
}

class BooksApp extends NavAwareAppState {

  BooksApp() :
    super(
      appTitle: 'Books App',
      theme: myTheme,
      navState: NavAwareState(NavType.Drawer),
      tabs: [
        TabInfo(
            icon: Icons.home,
            title: 'Books',
            stateItems: [SelectedBookState()],
            rootScreenFactory: (nvState) => BooksListScreen(nvState)),
        TabInfo(
            icon: Icons.person,
            title: 'User',
            rootScreenFactory: (nvState) => UserProfileScreen(nvState)),
        TabInfo(
            icon: Icons.settings,
            title: 'Settings',
            stateItems: [ShowSettingsModalState()],
            rootScreenFactory: (nvState) => SettingsScreen(nvState))
      ],
      routeParsers: [
        BookListPath.fromUri,
        BookDetailsPath.fromUri,
        UserProfilePath.fromUri,
        SettingsPath.fromUri,
        SettingsModalChildPath.fromUri
      ],
    )
  {
    navState.assertSingleStateItemOfEachType();
  }
}