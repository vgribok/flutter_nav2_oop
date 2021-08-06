import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

class SettingsScreen extends NavScreen {
  static const int navTabIndex = 2;

  const SettingsScreen(NavAwareState navState) :
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
            Text('Navigation Mode:'),
            Wrap(children: [
              ChoiceChip(
                //avatar: Icon(Icons.arrow_back),
                label: Text('Bottom Tab Bar'),
                selected: navState.navigationType == NavType.BottomTabBar,
                onSelected: (selected) => selected ? navState.navigationType = NavType.BottomTabBar : null
              ),
              Text('  '),
              ChoiceChip(
                //avatar: Icon(Icons.menu),
                label: Text('Side Drawer'),
                selected: navState.navigationType == NavType.Drawer,
                onSelected: (selected) => selected ? navState.navigationType = NavType.Drawer : null
              ),
            ]),
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
  NavScreen? get topScreen =>
    showSettingsModalState.showSettingsModal ?
      SettingsChildModalDialog(parent: this) : null;
}