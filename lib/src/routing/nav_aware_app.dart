part of flutter_nav2_oop;

class NavAwareApp extends _NavAwareAppBase<NavModel> {
  /// A singleton of [TabNavModel] accessible via [Provider]
  static late RestorableProvider<_NavStateRestorer> _privateNavModelProvider;

  NavAwareApp({
    /// Used for state restoration
    required super.applicationId,
    /// Application name
    required super.appTitle,
    /// Collection of factory methods test-converting
    /// user-typed (Web) URLs into [RoutePath] subclass instances
    required super.routeParsers,
    /// Initial route to be shown on application start
    required super.initialPath,
    /// Application color theme
    super.theme,
    /// Restorable state providers with global scope
    super.globalRestorableProviders,
    required RootScreenFactory rootScreenFactory,
    super.key
  }) {
    _privateNavModelProvider = RestorableProvider(
        (_) => _NavStateRestorer(NavModel(rootScreenFactory)),
        restorationId: "nav-state-restorer"
      );
  }

  @override
  @protected
  RestorableProvider get navModelProvider => _privateNavModelProvider;

  static NavModel navModelFactory(WidgetRef ref) =>
      ref.read(_privateNavModelProvider).value;

  static NavModel watchNavModelFactory(WidgetRef ref) =>
      ref.watch(_privateNavModelProvider).value;

  @override
  @protected
  NavModel navModel(WidgetRef ref) => navModelFactory(ref);

  @override
  @protected
  NavModel watchNavModel(WidgetRef ref) => watchNavModelFactory(ref);

  @override
  @protected
  NavAwareRouterDelegate createRouterDelegate(WidgetRef ref) =>
      NavAwareRouterDelegate(ref);
}

abstract class _NavAwareAppBase<T extends _NavModelBase> extends ConsumerWidget {

  /// Application name
  final String _appTitle;
  final String applicationId;
  final ThemeData? _theme;
  final List<RoutePathFactory> _routeParsers;
  final List<RestorableProvider<RestorableProperty?>>? globalRestorableProviders;

  static late _NavModelBase Function(WidgetRef) navModelFactory;

  @protected
  RestorableProvider get navModelProvider;

  @protected
  T navModel(WidgetRef ref);

  @protected
  T watchNavModel(WidgetRef ref);

  _NavAwareAppBase({
    /// Used for state restoration
    required this.applicationId,
    /// Application name
    required String appTitle,
    /// Collection of factory methods test-converting
    /// user-typed (Web) URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// Initial route to be shown on application start
    required RoutePath initialPath,
    /// Application color theme
    ThemeData? theme,
    /// Restorable state providers with global scope
    this.globalRestorableProviders,
    super.key
  }) :
    _appTitle = appTitle,
    _theme = theme,
    _routeParsers = [
      ...routeParsers,
      (uri) => _parseHome(uri, initialPath)
    ]
  {
    navModelFactory = (ref) => navModel(ref);
  }

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      MaterialApp.router(
        title: appTitle,
        theme: _theme,
        routerDelegate: createRouterDelegate(ref),
        routeInformationParser: NavAwareRouteInfoParser(
            ref, routeParsers: _routeParsers),
        restorationScopeId: "app-router-restoration-scope",
        debugShowCheckedModeBanner: false,
        // Hide 'Debug' ribbon on the AppBar,

        // An observation critical to successfully implementing restorable state
        // with the [MaterialApp.router] is that the builder can be used to
        // supply restoration scope (restorationId). The key bit here is that
        // you don't have to supply your own child to the builder - the child
        // comes from the [MaterialApp], but that is not obvious unless one
        // analyzed the framework source code. The real child supplier is still the
        // RouterDelegate's Build() method. You're welcome :-).
        builder: (context, router) =>
            RestorableProviderRegister(
                restorationId: 'application-ephemeral-state',
                providers: restorableProviders,
                child: router! // ?? const SizedBox.shrink(),
            )
    );

  @protected
  @mustCallSuper
  List<RestorableProvider<RestorableProperty?>> get restorableProviders =>
    [
      navModelProvider,
      ... globalRestorableProviders ?? []
    ];

  /// Returns the name of the application
  String get appTitle => _appTitle;

  /// Returns path object for the "/" (home) route
  static RoutePath? _parseHome(Uri uri, RoutePath initPath) =>
      uri.path == '/' ? initPath : null;

  /// Returns [ProviderScope] - a required wrapper for an app
  /// using Riverpod state management.
  ProviderScope get riverpodApp => ProviderScope(child: this);

  @protected
  _NavAwareRouterDelegateBase createRouterDelegate(WidgetRef ref);
}