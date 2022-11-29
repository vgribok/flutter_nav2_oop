import 'package:example/src/routing/settings_modal_child_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsChildModalDialog extends FullScreenModalDialog {

  const SettingsChildModalDialog({super.key})
    : super(screenTitle: 'Modal Demo');

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Full-Screen Modal Dialog'),
            ErrorDisplay("An example of error message,", null,
                errorContext: "Demo of the error output",
                onRetry: () => "Does nothing".debugPrint()
            ),
            const Divider(thickness: 1, indent: 50, endIndent: 50),
            ElevatedButton(
                child: const Text('Close Me'),
                onPressed: () => close(context)
            )
          ]
        )
    );

  @override
  RoutePath get routePath => SettingsModalChildPath();

  @override
  // ignore: must_call_super
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) =>
    // Set the state that will hide this screen
    // when UI is rebuilt due to this state change
    SettingsScreen.showSettingsDialogProvider.writable(ref).state = false;

  @override
  List<Widget>? buildAppBarActions(BuildContext context, WidgetRef ref) =>
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