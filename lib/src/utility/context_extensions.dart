part of flutter_nav2_oop;

extension ContextEx on BuildContext {

  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  void showFancySnackBar({required Widget content}) =>
      ScaffoldMessenger.of(this).showSnackBar(
          SnackBar(
              content: content,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              behavior: SnackBarBehavior.floating
          )
      );

  void showSnackBar(String text) => showFancySnackBar(content: Text(text));

  Future<void> fireAsync({ required Future Function() stateMutator, required String onErrorMessage}) async {
    try {
      await stateMutator();
    } on Exception catch (e) {
      e.debugPrint();
      showSnackBar(onErrorMessage);
    }
  }
}