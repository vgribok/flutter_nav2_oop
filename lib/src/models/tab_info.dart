part of flutter_nav2_oop;

/// Signature of a method instantiating a root screen for a tab
typedef TabRootScreenFactory = TabbedNavScreen Function(TabNavState navState);

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

  /// A collection of state objects used by screens belonging
  /// to the tab
  final List<ChangeNotifier> _stateItems;

  const TabInfo({
    /// Tab icon
    required this.icon,
    /// Optional tab title
    this.title,
    /// Function instantiating the root screen of the tab.
    required this.rootScreenFactory,
    /// A collection of state objects used by screens belonging
    /// to the tab
    List<ChangeNotifier>? stateItems
  })
      : _stateItems = stateItems ?? const [];

  /// A collection of state objects used by screens belonging
  /// to the tab
  List<ChangeNotifier> get stateItems => _stateItems;

  /// Calculates the basis of the screen navigation stack
  /// for the tab, when it's selected.
  ///
  /// The last screen in the returned collection will be displayed,
  /// unless the framework needs to show the 404 screen on top of it
  /// in response to user's invalid input into browser's address bar.
  Iterable<TabbedNavScreen> _screenStack(TabNavState navState) sync* {

    // Let application code instantiate the root screen for the tab
    final TabbedNavScreen rootScreen = rootScreenFactory(navState);
    yield rootScreen;

    // Build screen stack by calling each screen's [topScreen]
    // property to see whether the screen needs to show another
    // screen on top
    for (TabbedNavScreen? nextScreen = rootScreen.topScreen;
        nextScreen != null;
        nextScreen = nextScreen.topScreen)
      yield nextScreen;
  }

  /// Finds a state object by its type in tab's state object collection
  T? stateByType<T extends ChangeNotifier>() =>
      stateItems.firstSafe((e) => e is T) as T?;

  /// Attaches external listener of state change notifications.
  ///
  /// This method, along with the [_removeListener] method,
  /// optimize number of UI rebuilds by ignoring state
  /// changes affecting inactive tab screens.
  void _addListener(VoidCallback listener) =>
      _stateItems.forEach((stateItem) {
        assert(!stateItem.hasListeners);
        stateItem.addListener(listener);
      });

  /// Removes external listener of state change notifications
  ///
  /// This method, along with the [_addListener] method,
  /// optimize number of UI rebuilds by ignoring state
  /// changes affecting inactive tab screens.
  void _removeListener(VoidCallback listener) =>
      _stateItems.forEach((stateItem) {
        assert(stateItem.hasListeners);
        stateItem.removeListener(listener);
        assert(!stateItem.hasListeners);
      });
}
