import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';
import 'package:flutter_nav2_oop/src/routing/settings_path.dart';

class SettingsScreen extends TabbedNavScreen {
  static const int navTabIndex = 2;

  const SettingsScreen(TabNavState navState) :
    super(
      tabIndex: navTabIndex,
      navState: navState,
      screenTitle: 'Settings'
    );

  @override
  Widget buildBody(BuildContext context) =>
      Center(
        child: Text('Settings screen'),
      );

  @override
  RoutePath get routePath => SettingsPath();
}