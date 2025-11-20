import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/dal/settings_data_access.dart';
import 'package:flutter_nav2_oop/all.dart';

class SettingsModalChildPath extends RoutePath {

  static const String resourceName = '${SettingsPath.resourceName}/modal-child';

  SettingsModalChildPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.pathsMatch(resourceName) ? SettingsModalChildPath() : null;

  @override
  bool configureStateFromUri(WidgetRef ref) {
    SettingsDataAccess.showDialog(ref);
    return true;
  }
}