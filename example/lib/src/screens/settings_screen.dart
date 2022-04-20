import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends NavScreen {
  static const int navTabIndex = 2;

  const SettingsScreen() :
    super(
      tabIndex: navTabIndex,
      screenTitle: 'Settings'
    );

  @override
  Widget buildBody(BuildContext context) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Navigation Mode:'),
            Consumer<NavAwareState>(
              builder: (context, navState, child) =>
                Wrap(
                  spacing: 10, runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ChoiceChip(
                        label: const Text('Auto'),
                        selected: navState.navigationType == null,
                        onSelected: (selected) => selected ? navState.navigationType = null : null
                    ),
                    ChoiceChip(
                      label: const Text('Bottom Tab Bar'),
                      selected: navState.navigationType == NavType.BottomTabBar,
                      onSelected: (selected) => selected ? navState.navigationType = NavType.BottomTabBar : null
                    ),
                    ChoiceChip(
                      label: const Text('Side Drawer'),
                      selected: navState.navigationType == NavType.Drawer,
                      onSelected: (selected) => selected ? navState.navigationType = NavType.Drawer : null
                    ),
                    ChoiceChip(
                        label: const Text('Vertical Rail'),
                        selected: navState.navigationType == NavType.VerticalRail,
                        onSelected: (selected) => selected ? navState.navigationType = NavType.VerticalRail : null
                    ),
                  ]
                )
            ),
            const Divider(thickness: 1, indent: 50, endIndent: 50),
            ElevatedButton(
              child: const Text('Show Modal Dialog'),
              onPressed: () => Provider.of<SettingsShowModalState>(context, listen: false).showSettingsModal = true
            )
          ]
        )
      );

  @override
  RoutePath get routePath => const SettingsPath();

  // SettingsShowModalState get showSettingsModalState =>
  //   stateByType<>()!;

  @override
  NavScreen? topScreen(BuildContext context) =>
    Provider.of<SettingsShowModalState>(context, listen: true).showSettingsModal ?
      SettingsChildModalDialog(parent: this) : null;
}