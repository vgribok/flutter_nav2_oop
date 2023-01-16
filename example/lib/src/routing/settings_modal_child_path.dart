import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsModalChildPath extends RoutePath {

  static const String resourceName = '${SettingsPath.resourceName}/modal-child';

  SettingsModalChildPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.pathsMatch(resourceName) ? SettingsModalChildPath() : null;

  @override
  bool configureStateFromUri(WidgetRef ref) {
    SettingsScreen.showSettingsDialogProvider.setValue(ref, true);
    return true;
  }
}