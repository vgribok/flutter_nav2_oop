import 'package:example/src/extension-classes/build_context_extensions.dart';
import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_modal_child_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/provider.dart';

class SettingsChildModalDialog extends FullScreenModalDialog {

  SettingsChildModalDialog({required NavScreen parent})
    : super(
        parent: parent,
        screenTitle: 'Modal Demo',
    );

  @override
  Widget buildBody(BuildContext context) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Full-Screen Modal Dialog'),
            const Divider(thickness: 1, indent: 50, endIndent: 50),
            ElevatedButton(
                child: const Text('Close Me'),
                onPressed: () => close(context)
            )
          ]
        )
    );

  @override
  RoutePath get routePath => const SettingsModalChildPath();

  // /// Convenience accessor to the state object
  // @protected
  // SettingsShowModalState get showSettingsModalState =>
  //     stateByType<SettingsShowModalState>()!;

  @override
  void updateStateOnScreenRemovalFromNavStackTop(NavAwareState navState, BuildContext context) =>
    // Set the state that will hide this screen
    // when UI is rebuilt due to this state change
    Provider.of<SettingsShowModalState>(context, listen: true).showSettingsModal = false;

  @override
  List<Widget>? buildAppBarActions(BuildContext context) =>
    [
      IconButton(
        icon: const Icon(Icons.save),
        tooltip: 'Save data',
        onPressed: () => _onSaveTap(context)
      )
    ];

  void _onSaveTap(BuildContext context) {
    context.showSnackBar('Save button pressed');
    close(context);
  }
}