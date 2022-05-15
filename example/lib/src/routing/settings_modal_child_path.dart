import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsModalChildPath extends RoutePath {

  static const String resourceName = '${SettingsPath.resourceName}/modal-child';

  const SettingsModalChildPath() :
      super(
        tabIndex: SettingsScreen.navTabIndex,
        resource: resourceName
      );

  static RoutePath? fromUri(Uri uri) =>
      uri.pathsMatch(resourceName) ? const SettingsModalChildPath() : null;

  @override
  Future<void> configureStateFromUri(TabNavModel navState, WidgetRef ref) {
    super.configureStateFromUri(navState, ref);
    SettingsScreen.showSettingsDialogProvider.writable(ref).state = true;
    return Future.value();
  }
}