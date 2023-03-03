// ignore_for_file: avoid_renaming_method_parameters

part of flutter_nav2_oop;

class NavAwareRouterDelegate extends _NavAwareRouterDelegateBase<NavModel> {

  NavAwareRouterDelegate(super.ref);

  @override
  NavModel get navModel => _NavAwareAppBase.navModelFactory(ref) as NavModel;
}

/// Abstracts away boilerplate implementation of the
/// [RouterDelegate] and supplies navigation logic.
///
/// Its [build] method returns [Navigator] Widget, with
/// [Page] stack back navigation arrow handler supplied by
/// the framework.
abstract class _NavAwareRouterDelegateBase<T extends NavModelBase>
    extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Riverpod state accessor
  final WidgetRef ref;

  T get navModel;

  late bool _attachedListenerToNavState = false;

  _NavAwareRouterDelegateBase(this.ref);

  bool get appInitializationCompleted =>
      _NavAwareAppBase.appInitProvider.watchAsyncValue(ref).value ?? false;

  @override
  Widget build(BuildContext context) =>
    _NavAwareAppBase.appInitProvider.watchAsyncValue(ref).when(
        loading: () =>
            _buildNavigatorWidget(context, [const AppInitWaitScreen()]),
        error: (err, stack) =>
            _buildNavigatorWidget(context, [AppInitErrorScreen(err, stack,
                onRetry: () => _NavAwareAppBase.appInitProvider.invalidate(ref)
            )]),
        data: (_) =>
            // Call the function converting state into the stack of screens.
            _buildNavigatorWidget(context, navModel.buildNavigatorScreenStack(ref))
    );

  Widget _buildNavigatorWidget(BuildContext context, Iterable<NavScreen> screens) {

    _attachDelegateListenerToNavStateNotifier();

    final pageStack = screens.map((screen) => screen._page).toList();

    // Feed page stack and standard back arrow
    // handler to the Navigator object
    return Navigator(
        key: navigatorKey,
        // transitionDelegate: NoAnimationTransitionDelegate(),
        pages: pageStack,
        onPopPage: _onBackButtonPress,
        restorationScopeId: "main-navigator"
    );
  }


  /// Standard handler of the back arrow navigation button
  bool _onBackButtonPress(Route route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    final NavScreen navScreen = route.navScreen;
    navScreen.updateStateOnScreenRemovalFromNavStackTop(ref);

    return true;
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
  RoutePath get currentConfiguration => appInitializationCompleted ?
      navModel.buildNavigatorScreenStack(ref).last.routePath :
      const RoutePath(resource: "/");


  /// Updates application navigation state based on
  /// user-typed URL, so that a screen corresponding
  /// to the entered route would be on top of the
  /// navigation stack.
  @override
  Future<void> setNewRoutePath(RoutePath path) =>
     path._configureStateFromUriFuture(ref);

  /// Called when routing delegate's ephemeral state gets restored
  @override
  Future<void> setRestoredRoutePath(RoutePath path) =>
    // skips calling super to skip calling [setNewRoutePath]
    // which changes selected tab and this way messes up
    // restored state.
    path._configureStateFromUriFuture(ref);

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  /// Need to attach [RouterDelegate] listener to [NavModel]
  /// notifier to repaint the screen when tabs are clicked.
  /// Attaching can be done only after the [RestorableProvider]
  /// was registered and navModel is accessible.
  void _attachDelegateListenerToNavStateNotifier() {
    if(!_attachedListenerToNavState) {
      // Have to do it here because access to [NavModel]
      // is absent in the constructor due to restorable
      // not getting registered by then. Had to have this hack here
      // as it's unclear what would be a better place to attach.
      _attachedListenerToNavState = true;
      navModel.addListener(notifyListeners);
    }
  }
}
