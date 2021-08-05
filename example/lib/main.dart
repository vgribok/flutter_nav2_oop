// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/routing/user_profile_path.dart';
import 'package:example/src/screens/book_list_screen.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:example/src/screens/user_profile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

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
          theme: myTheme,
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
    //TabbedNavScreen.tabBarBuilder = buildFancyTabBar;
  }

  // Widget buildFancyTabBar(BuildContext context, Iterable<TabInfo> tabs, int initialSelection, void Function(int index) tapHandler) =>
  //     ConvexAppBar.badge(
  //       <int, dynamic>{0: Books.allBooks.length.toString()},
  //       style: TabStyle.reactCircle,
  //       items: tabs.map((tab) => TabItem(icon: tab.icon, title: tab.title)).toList(),
  //       onTap: tapHandler,
  //       initialActiveIndex: initialSelection,
  //       backgroundColor: myTheme.primaryColorDark,
  //       badgeTextColor: myTheme.primaryColorLight,
  //       badgeColor: Colors.blueAccent,
  //     );
}