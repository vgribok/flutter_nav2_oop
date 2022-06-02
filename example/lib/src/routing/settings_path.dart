import 'package:flutter_nav2_oop/all.dart';

class SettingsPath extends RoutePath {
  static const String resourceName = 'settings';

  SettingsPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? SettingsPath() : null;
}
