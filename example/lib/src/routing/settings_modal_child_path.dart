import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/provider.dart';

class SettingsModalChildPath extends RoutePath {

  static const String resourceName = '${SettingsPath.resourceName}/modal-child';

  const SettingsModalChildPath({BuildContext? context}) :
      super(
        context: context,
        tabIndex: SettingsScreen.navTabIndex,
        resource: resourceName
      );

  static RoutePath? fromUri(Uri uri, BuildContext context) =>
      uri.pathsMatch(resourceName) ? SettingsModalChildPath(context: context) : null;

  @override
  Future<void> configureStateFromUri() {
    super.configureStateFromUri();
    Provider.of<SettingsShowModalState>(context!, listen: false).showSettingsModal = true;
    return Future.value();
  }
}