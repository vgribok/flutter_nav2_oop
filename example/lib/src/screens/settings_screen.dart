import 'package:example/src/routing/settings_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

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