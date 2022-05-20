import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsModalChildPath extends RoutePath {

  static const String resourceName = '${SettingsPath.resourceName}/modal-child';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTaxIndex = 1;

  const SettingsModalChildPath({required super.tabIndex}) :
      super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.pathsMatch(resourceName) ? const SettingsModalChildPath(tabIndex: SettingsPath.defaultTabIndex) : null;

  @override
  void configureStateFromUri(WidgetRef ref) =>
    SettingsScreen.showSettingsDialogProvider.writable(ref).state = true;
}