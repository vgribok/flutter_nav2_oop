import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/utility/uri_extensions.dart';
import 'package:flutter_nav2_oop/src/screens/settings_screen.dart';

class SettingsPath extends RoutePath {

  static const String resourceName = 'settings';

  const SettingsPath() :
    super(
      navTabIndex: SettingsScreen.navTabIndex,
      resource: resourceName
    );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? SettingsPath() : null;
}
