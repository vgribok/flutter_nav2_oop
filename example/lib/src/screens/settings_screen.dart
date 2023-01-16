import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  static final StateProvider<bool> showSettingsDialogProvider = StateProvider<bool>((ref) => false);

  const SettingsScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key}) :
      super(screenTitle: 'Settings');

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {

    final NavControlType? navControlType = TabNavAwareApp.navControlTypeProvider.watchValue(ref);

    return CenteredColumn(
            children: [
              const Text('Navigation Mode:'),
              Wrap(
                  spacing: 10, runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ChoiceChip(
                        label: const Text('Auto'),
                        selected: navControlType == null,
                        onSelected: (selected) => _selectNavType(selected, ref, null)
                    ),
                    ChoiceChip(
                        label: const Text('Bottom Tab Bar'),
                        selected: navControlType == NavControlType.BottomTabBar,
                        onSelected: (selected) => _selectNavType(selected, ref, NavControlType.BottomTabBar)
                    ),
                    ChoiceChip(
                        label: const Text('Side Drawer'),
                        selected: navControlType == NavControlType.Drawer,
                        onSelected: (selected) => _selectNavType(selected, ref, NavControlType.Drawer)
                    ),
                    ChoiceChip(
                        label: const Text('Vertical Rail'),
                        selected: navControlType == NavControlType.VerticalRail,
                        onSelected: (selected) => _selectNavType(selected, ref, NavControlType.VerticalRail)
                    ),
                  ]
              ),
              const Divider(thickness: 1, indent: 50, endIndent: 50),
              ElevatedButton(
                  child: const Text('Show Modal Dialog'),
                  onPressed: () => SettingsScreen.showSettingsDialogProvider.setValue(ref, true)
              )
            ]
    );
  }

  void _selectNavType(bool selected, WidgetRef ref, NavControlType? navControlType) {
    if(selected) TabNavAwareApp.navControlTypeProvider.setValue(ref, navControlType);
  }

  @override
  RoutePath get routePath => SettingsPath();

  @override
  NavScreen? topScreen(WidgetRef ref) => ref.watch(showSettingsDialogProvider) ?
      const SettingsChildModalDialog() : null;
}