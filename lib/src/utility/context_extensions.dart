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

  /// Fires and forgets, but shows error in the snack bar on exception
  Future<void> fireAsync({ required Future<void> Function() stateMutator, required String onErrorMessage}) async {
    try {
      await stateMutator();
    } on Exception catch (e) {
      e.debugPrint();
      showSnackBar(onErrorMessage);
    }
  }

  Size get safeAreaSize => MediaQuery.of(this).size;
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
}