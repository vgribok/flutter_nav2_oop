import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter_nav2_oop/all.dart';

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
  Future<void> configureStateFromUri(TabNavModel navState) {
    super.configureStateFromUri(navState);
    stateByType<SettingsShowModalState>(navState)!.showSettingsModal = true;
    return Future.value();
  }
}