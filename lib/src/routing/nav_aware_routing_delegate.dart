part of flutter_nav2_oop;

/// Abstracts away boilerplate implementation of the
/// [RouterDelegate] and supplies tab-aware navigation logic.
///
/// Its [build] method returns [Navigator] Widget, with
/// [Page] stack back navigation arrow handler supplied by
/// the framework.
class NavAwareRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final Ref ref;

  /// Application state reference holder
  NavAwareState get navState => ref.read(NavAwareApp.navModelProvider);

  NavAwareRouterDelegate(this.ref,
  ) {
    navState.addListener(this.notifyListeners);
  }

  @override
  Widget build(BuildContext context) {

    // Call the function converting state
    // into the stack of screens.
    final List<Page<dynamic>> pageStack =
      navState._buildNavigatorScreenStack()
          .map((screen) => screen._page)
          .toList();

    // Feed page stack and standard back arrow
    // handler to the Navigator object
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: pageStack,
      onPopPage: _onBackButtonPress,
      restorationScopeId: "main-navigator",
    );
  }

  /// Standard handler of the back arrow navigation button
  bool _onBackButtonPress(Route route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    NavScreen navScreen = _screenFromRoute(route);
    navScreen.updateStateOnScreenRemovalFromNavStackTop();

    return true;
  }

  static NavScreen _screenFromRoute(Route route) {
    dynamic page = route.settings; // Cast settings to Page
    // Cast page.child to TabbedNavScreen
    NavScreen navScreen = page.child as NavScreen;
    return navScreen;
  }

  /// Returns current route associated with the top nav stack screen.
  ///
  /// Unfortunately original currentConfiguration property getter
  /// has very little context to efficiently do its work. To
  /// work around this limitation, this override implementation
  /// has to find current top screen by rebuilding the entire screen stack
  /// (although current/top screen is well known to the system but not
  /// supplied here), and then ask the screen for its route.
  @override
  RoutePath get currentConfiguration =>
      navState._buildNavigatorScreenStack().last.routePath;

  /// Updates application navigation state based on
  /// user-typed URL, so that a screen corresponding
  /// to the entered route would be on top of the
  /// navigation stack.
  @override
  Future<void> setNewRoutePath(RoutePath path) =>
      path.configureStateFromUri(navState);

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
