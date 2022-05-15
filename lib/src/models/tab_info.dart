part of flutter_nav2_oop;

/// Signature of a method instantiating a root screen for a tab
typedef TabRootScreenFactory = NavScreen Function();

/// Defines both mutable and immutable parts of navigation tab's state.
///
/// Its' supplied by the app to define tab names, icons, root widgets and
/// parts of application state handled by the stack of screens.
class TabInfo {
  /// Tab icon
  final IconData icon;

  /// Optional tab title
  final String? title;

  /// Function instantiating the root screen of the tab.
  ///
  /// The framework implements navigation flow that puts
  /// the root screen at the top of the navigation stack
  /// when the tab gets selected.
  final TabRootScreenFactory rootScreenFactory;

  const TabInfo({
    /// Tab icon
    required this.icon,
    /// Optional tab title
    this.title,
    /// Function instantiating the root screen of the tab.
    required this.rootScreenFactory,
  });

  /// Calculates the basis of the screen navigation stack
  /// for the tab, when it's selected.
  ///
  /// The last screen in the returned collection will be displayed,
  /// unless the framework needs to show the 404 screen on top of it
  /// in response to user's invalid input into browser's address bar.
  Iterable<NavScreen> _screenStack(WidgetRef ref) sync* {

    // Let application code instantiate the root screen for the tab
    final NavScreen rootScreen = rootScreenFactory();
    yield rootScreen;

    // Build screen stack by calling each screen's [topScreen]
    // property to see whether the screen needs to show another
    // screen on top
    for (NavScreen? nextScreen = rootScreen.topScreen(ref);
        nextScreen != null;
        nextScreen = nextScreen.topScreen(ref))
      yield nextScreen;
  }

  /// Returns `true` if this tab has more than one screen
  /// in its screen stack.
  bool hasMultipleScreensInStack(WidgetRef ref) =>
      _screenStack(ref).take(2).length == 2;

  /// Returns `true` if this tab has only one screen
  /// in its screen stack.
  bool hasOnlyOneScreenInStack(WidgetRef ref) =>
      _screenStack(ref).take(2).length == 1;
}
