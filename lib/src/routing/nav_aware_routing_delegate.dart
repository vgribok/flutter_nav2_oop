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

  /// Riverpod state accessor
  final WidgetRef ref;

  /// Application state reference holder
  TabNavModel get navState => ref.read(NavAwareApp.navModelProvider);

  NavAwareRouterDelegate(this.ref) {
    navState.addListener(notifyListeners);
  }

  @override
  Future<void> setInitialRoutePath(RoutePath configuration) {
    return super.setInitialRoutePath(configuration);
  }

  @override
  Widget build(BuildContext context) {

    // Call the function converting state
    // into the stack of screens.
    final List<Page<dynamic>> pageStack =
      navState._buildNavigatorScreenStack(ref)
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
      // initialRoute: "/counter",
    );
  }

  /// Standard handler of the back arrow navigation button
  bool _onBackButtonPress(Route route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    NavScreen navScreen = _screenFromRoute(route);
    navScreen.updateStateOnScreenRemovalFromNavStackTop(ref);

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
      navState._buildNavigatorScreenStack(ref).last.routePath;

  /// Updates application navigation state based on
  /// user-typed URL, so that a screen corresponding
  /// to the entered route would be on top of the
  /// navigation stack.
  @override
  Future<void> setNewRoutePath(RoutePath path) =>
      path.configureStateFromUri(ref);

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
