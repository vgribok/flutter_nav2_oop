import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends NavScreen {
  static const int navTabIndex = 2;

  const SettingsScreen(TabNavModel navState) :
    super(
      tabIndex: navTabIndex,
      navState: navState,
      screenTitle: 'Settings'
    );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Navigation Mode:'),
            Wrap(
              spacing: 10, runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ChoiceChip(
                    label: Text('Auto'),
                    selected: navState.navigationType == null,
                    onSelected: (selected) => selected ? navState.navigationType = null : null
                ),
                ChoiceChip(
                  label: Text('Bottom Tab Bar'),
                  selected: navState.navigationType == NavType.BottomTabBar,
                  onSelected: (selected) => selected ? navState.navigationType = NavType.BottomTabBar : null
                ),
                ChoiceChip(
                  label: Text('Side Drawer'),
                  selected: navState.navigationType == NavType.Drawer,
                  onSelected: (selected) => selected ? navState.navigationType = NavType.Drawer : null
                ),
                ChoiceChip(
                    label: Text('Vertical Rail'),
                    selected: navState.navigationType == NavType.VerticalRail,
                    onSelected: (selected) => selected ? navState.navigationType = NavType.VerticalRail : null
                ),
              ]
            ),
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

  SettingsShowModalState get showSettingsModalState =>
    stateByType<SettingsShowModalState>()!;

  @override
  NavScreen? get topScreen =>
    showSettingsModalState.showSettingsModal ?
      SettingsChildModalDialog(parent: this) : null;
}