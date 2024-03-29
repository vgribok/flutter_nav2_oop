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
      CenteredColumn(
          children: [
            const Text('Full-Screen Modal Dialog'),
            Expanded(child: ErrorDisplay("An example of a very long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "a reaaally, very, super long, a reaaally, very, super long, "
                "\nerror message,",
                StackTrace.fromString(
                    'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                        'Stack line with function call details.\n'
                ),
                errorContext: "Demo of the error output",
                onRetry: () => context.showSnackBar("Retry is invoked")
            )),
            const Divider(thickness: 1, indent: 50, endIndent: 50),
            ElevatedButton(
                child: const Text('Close Me'),
                onPressed: () => close(context)
            )
          ]
    );

  @override
  RoutePath get routePath => SettingsModalChildPath();

  @override
  // ignore: must_call_super
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) =>
    // Set the state that will hide this screen
    // when UI is rebuilt due to this state change
    SettingsScreen.showSettingsDialogProvider.setValue(ref, false);

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