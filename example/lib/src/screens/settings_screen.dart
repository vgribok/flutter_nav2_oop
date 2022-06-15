import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/authentication_screen.dart';
import 'package:example/src/screens/settings_child_modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends AuthenticatedScreen { // Subclass NavScreen to enable non-tab navigation

  static final StateProvider<bool> showSettingsDialogProvider = StateProvider<bool>((ref) => false);

  const SettingsScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key}) :
      super(screenTitle: 'Settings');

  @override
  Widget buildAuthenticatedBody(BuildContext context, WidgetRef ref) {

    final RestorableEnumN<NavControlType?> restorableNavControlType =
        ref.watch(TabNavAwareApp.navControlTypeProvider);
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
                  onPressed: () => SettingsScreen.showSettingsDialogProvider.writable(ref).state = true
              )
            ]
        )
    );
  }

  @override
  RoutePath get routePath => SettingsPath();

  @override
  NavScreen? topScreen(WidgetRef ref) => ref.watch(showSettingsDialogProvider) ?
      const SettingsChildModalDialog() : null;
}