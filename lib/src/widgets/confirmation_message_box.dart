part of flutter_nav2_oop;

class ConfirmationMessageBox extends StatelessWidget {

  final List<Widget> children;
  final String title;
  final String cancelButtonText;
  final String continueButtonText;
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

  factory ConfirmationMessageBox.simple({
    String title = "Are you sure?",
    String mainText = "Cancel or continue?",
    String? finePrint,
    String cancelButtonText = "Cancel",
    String continueButtonText = "Continue",
    required void Function(BuildContext) continueButtonOnPressHandler,
    Key? key
  }) =>
      ConfirmationMessageBox(
        title: title,
        children: [
          ListTile(leading: const Icon(Icons.question_mark),
              title: Text(mainText),
              subtitle: finePrint == null ? null : Text(finePrint),
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
          ),
          OutlinedButton(
            child: Text(continueButtonText),
            onPressed: () {
              Navigator.of(context).pop();
              continueButtonOnPressHandler(context);
            },
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