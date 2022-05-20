import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsModalChildPath extends RoutePath {

  static const String resourceName = '${SettingsPath.resourceName}/modal-child';

  SettingsModalChildPath({required super.tabIndex}) :
      super(resource: resourceName)
  {
    assert(tabIndex == SettingsPath.defaultTabIndex);
  }

  static RoutePath? fromUri(Uri uri) =>
      uri.pathsMatch(resourceName) ? SettingsModalChildPath(tabIndex: SettingsPath.defaultTabIndex) : null;

  @override
  void configureStateFromUri(WidgetRef ref) =>
    SettingsScreen.showSettingsDialogProvider.writable(ref).state = true;
}