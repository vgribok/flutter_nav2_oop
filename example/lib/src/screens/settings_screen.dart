import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends NavScreen {
  static const int navTabIndex = 2;

  SettingsScreen(TabNavModel navState) :
    super(
      tabIndex: navTabIndex,
      navState: navState,
      screenTitle: 'Settings'
    );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {

    final RestorableEnumN<NavControlType?> restorableNavControlType = ref.watch(NavAwareApp.navControlTypeProvider);
    final NavControlType? navControlType = restorableNavControlType.enumValue;

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Navigation Mode:'),
              Wrap(
                  spacing: 10, runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ChoiceChip(
                        label: const Text('Auto'),
                        selected: navControlType == null,
                        onSelected: (selected) =>
                            selected ? restorableNavControlType.enumValue = null : null
                    ),
                    ChoiceChip(
                        label: const Text('Bottom Tab Bar'),
                        selected: navControlType == NavControlType.BottomTabBar,
                        onSelected: (selected) =>
                        selected ? restorableNavControlType.enumValue = NavControlType.BottomTabBar
                                : null
                    ),
                    ChoiceChip(
                        label: const Text('Side Drawer'),
                        selected: navControlType == NavControlType.Drawer,
                        onSelected: (selected) =>
                          selected ? restorableNavControlType.enumValue = NavControlType.Drawer : null
                    ),
                    ChoiceChip(
                        label: const Text('Vertical Rail'),
                        selected: navControlType == NavControlType.VerticalRail,
                        onSelected: (selected) =>
                          selected ? restorableNavControlType.enumValue = NavControlType.VerticalRail
                            : null
                    ),
                  ]
              ),
              const Divider(thickness: 1, indent: 50, endIndent: 50),
              ElevatedButton(
                  child: const Text('Show Modal Dialog'),
                  onPressed: () =>
                    showSettingsModalState.showSettingsModal = true
              )
            ]
        )
    );
  }

  @override
  RoutePath get routePath => SettingsPath();

  SettingsShowModalState get showSettingsModalState =>
    stateByType<SettingsShowModalState>()!;

  @override
  NavScreen? get topScreen =>
    showSettingsModalState.showSettingsModal ?
      SettingsChildModalDialog(parent: this) : null;
}