import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nav2_oop/all.dart';

class SettingsPath extends RoutePath {

  static const String resourceName = 'settings';

  const SettingsPath(BuildContext context) :
    super(
      context,
      tabIndex: SettingsScreen.navTabIndex,
      resource: resourceName
    );

  static RoutePath? fromUri(Uri uri, BuildContext context) =>
      uri.isSingleSegmentPath(resourceName) ? SettingsPath(context) : null;
}
