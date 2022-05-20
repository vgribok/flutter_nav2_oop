import 'package:flutter_nav2_oop/all.dart';

class SettingsPath extends RoutePath {
  static const String resourceName = 'settings';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTabIndex = 2;

  SettingsPath({required super.tabIndex}) :
    super(resource: resourceName)
  {
    assert(tabIndex == defaultTabIndex);
  }

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? SettingsPath(tabIndex: defaultTabIndex) : null;
}
