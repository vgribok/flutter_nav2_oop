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

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get safeAreaSize => mediaQuery.size;
  EdgeInsets get safeAreaPadding => mediaQuery.padding;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  void navigateBack() => Navigator.pop(this);

  NavigatorState get navigator => Navigator.of(this);

  void showModal(FullScreenModalDialog modalDialog) => navigator.push(modalDialog.getRoute(this));

  Route<dynamic>? get currentRoute {
    bool isFirst = true;
    Route<dynamic>? currentRoute;

    // Use this trick to pick the top route in the nav stack
    // but never actually pop any route.
    navigator.popUntil((Route<dynamic> route) {
      if(isFirst) {
        isFirst = false;
        currentRoute = route;
      }
      // Tell to not pop the route.
      return true;
    });
    return currentRoute;
  }

  NavScreen? get currentScreen => currentRoute?.navScreen;
}