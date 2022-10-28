// ignore_for_file: sort_child_properties_last

part of flutter_nav2_oop;

/// Message box with binary answer buttons (yes/no,
/// stop/continue, OK/Cancel, etc).
/// The dialog closes self when either button is pressed
/// without disrupting navigation history stack
class ConfirmationMessageBox extends StatelessWidget {

  /// Optional children. If not specified, the
  /// [ListTitle] widget with the question mark icon and
  /// the "Cancel or continue?" text is shown
  final List<Widget> children;
  /// Optional title text. If not specified, "Are you sure?"
  /// is shown
  final String title;
  /// Optional cancel button text. Default value is "Cancel"
  final String cancelButtonText;
  /// Optional continue button test. Default value is "Continue"
  final String continueButtonText;
  /// The handler of the Continue button tap
  final void Function(BuildContext) continueButtonOnPressHandler;

  const ConfirmationMessageBox({
    this.title = "Are you sure?",
    this.children = const <Widget>[
      ListTile(leading: Icon(Icons.question_mark),
        title: Text("Cancel or continue?")
      )
    ],
    this.cancelButtonText = "Cancel",
    this.continueButtonText = "Continue",
    required this.continueButtonOnPressHandler,
    super.key
  });

  /// A quick way to show a confirm/cancel dialog.
  factory ConfirmationMessageBox.simple({
    /// Window title text
    String title = "Are you sure?",
    /// The main question
    String mainText = "Cancel or continue?",
    /// Optional string explaining the context
    String? finePrint,
    String cancelButtonText = "Cancel",
    String continueButtonText = "Continue",
    /// A function called when the Continue button is pressed
    required void Function(BuildContext) continueButtonOnPressHandler,
    Key? key
  }) =>
      ConfirmationMessageBox(
        title: title,
        children: [
          ListTile(leading: const Icon(Icons.question_mark),
              title: Text(mainText, key: const ValueKey("confirmation box title")),
              subtitle: finePrint == null ? null : Text(finePrint, key: const ValueKey("confirmation box subtitle")),
          )
        ],
        cancelButtonText: cancelButtonText,
        continueButtonText: continueButtonText,
        continueButtonOnPressHandler: continueButtonOnPressHandler,
        key: key,
      );

  @override
  Widget build(BuildContext context) =>
      AlertDialog(
        titlePadding: const EdgeInsets.all(15),
        contentPadding: const EdgeInsets.all(15),
        insetPadding: const EdgeInsets.all(20),
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(children: children),
        ),
        actions: [
          ElevatedButton(
            child: Text(cancelButtonText),
            onPressed: () => Navigator.of(context).pop(),
            key: const ValueKey("confirmation box cancel button")
          ),
          OutlinedButton(
            child: Text(continueButtonText),
            onPressed: () {
              Navigator.of(context).pop();
              continueButtonOnPressHandler(context);
            },
              key: const ValueKey("confirmation box continue button")
          ),
        ],
      );

  Future<void> show(BuildContext context, {bool barrierDismissible = true}) =>
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible, // user must tap button!
        builder: (BuildContext context) => this
      );
}