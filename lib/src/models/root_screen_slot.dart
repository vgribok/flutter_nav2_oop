part of flutter_nav2_oop;

typedef RootScreenFactory = NavScreen Function(WidgetRef ref);

class RootScreenSlot {

  final RootScreenFactory _rootScreenFactory;

  /// Collection of factory methods test-converting
  /// user-typed (Web) URLs into [RoutePath] subclass instances
  final List<RoutePathFactory> routeParsers;

  RootScreenSlot({
    required RootScreenFactory rootScreenFactory,
    required this.routeParsers
  }) : _rootScreenFactory = rootScreenFactory;

  @protected
  NavScreen getRootScreen(WidgetRef ref) =>
      _rootScreenFactory(ref);

  /// Calculates the basis of the screen navigation stack
  /// for the tab, when it's selected.
  ///
  /// The last screen in the returned collection will be displayed,
  /// unless the framework needs to show the 404 screen on top of it
  /// in response to user's invalid input into browser's address bar.
  Iterable<NavScreen> _screenStack(WidgetRef ref) sync* {

    // Let application code instantiate the root screen for the tab
    final NavScreen rootScreen = getRootScreen(ref);
    yield rootScreen;

    // Build screen stack by calling each screen's [topScreen]
    // property to see whether the screen needs to show another
    // screen on top
    for (NavScreen? nextScreen = rootScreen.topScreen(ref);
    nextScreen != null;
    nextScreen = nextScreen.topScreen(ref))
    {
      yield nextScreen;
    }
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