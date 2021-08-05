import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Settings screen'),
            Divider(thickness: 1, indent: 50, endIndent: 50),
            ElevatedButton(
              child: Text('Show Modal Dialog'),
              onPressed: () => showSettingsModalState.showSettingsModal = true
            )
          ]
        )
      );

  @override
  RoutePath get routePath => SettingsPath();

  ShowSettingsModalState get showSettingsModalState =>
    stateByType<ShowSettingsModalState>()!;

  @override
  TabbedNavScreen? get topScreen =>
    showSettingsModalState.showSettingsModal ?
      SettingsChildModalDialog(parent: this) : null;
}