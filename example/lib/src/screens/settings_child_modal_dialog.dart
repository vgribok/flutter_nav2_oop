import 'package:example/src/extension-classes/build_context_extensions.dart';
import 'package:example/src/models/show_settings_modal_state.dart';
import 'package:example/src/routing/settings_modal_child_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

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
            Text('Full-Screen Modal Dialog'),
            Divider(thickness: 1, indent: 50, endIndent: 50),
            ElevatedButton(
                child: Text('Close Me'),
                onPressed: () => close(context)
            )
          ]
        )
    );

  @override
  RoutePath get routePath => SettingsModalChildPath();

  /// Convenience accessor to the state object
  @protected
  ShowSettingsModalState get showSettingsModalState =>
      stateByType<ShowSettingsModalState>()!;

  @override
  void updateStateOnScreenRemovalFromNavStackTop() =>
    // Set the state that will hide this screen
    // when UI is rebuilt due to this state change
    showSettingsModalState.showSettingsModal = false;

  @override
  List<Widget>? buildAbbBarActions(BuildContext context) =>
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