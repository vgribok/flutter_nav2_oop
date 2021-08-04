import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/all.dart';

class SettingsPath extends RoutePath {

  static const String resourceName = 'settings';

  const SettingsPath() :
    super(
      tabIndex: SettingsScreen.navTabIndex,
      resource: resourceName
    );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? SettingsPath() : null;
}
