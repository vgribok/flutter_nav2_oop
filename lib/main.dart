import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_info.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/nav_aware_app_state.dart';
import 'package:flutter_nav2_oop/src/models/book.dart';
import 'package:flutter_nav2_oop/src/routing/book_details_path.dart';
import 'package:flutter_nav2_oop/src/routing/book_list_path.dart';
import 'package:flutter_nav2_oop/src/routing/settings_path.dart';
import 'package:flutter_nav2_oop/src/routing/user_profile_path.dart';
import 'package:flutter_nav2_oop/src/screens/book_list_screen.dart';
import 'package:flutter_nav2_oop/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/src/screens/user_profile_screen.dart';

void main() {
  runApp(BooksApp());
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends NavAwareAppState<BooksApp> {

  _BooksAppState() :
      super(
          appTitle: 'Books App',
          navState: TabNavState(),
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
              rootScreenFactory: (nvState) => SettingsScreen(nvState))
          ],
          routeParsers: [
            BookListPath.fromUri,
            BookDetailsPath.fromUri,
            UserProfilePath.fromUri,
            SettingsPath.fromUri
          ],
        )
  {
    navState.assertSingleStateItemOfEachType();
  }
}