part of flutter_nav2_oop;

class NavAwareApp extends ConsumerWidget {

  /// Application name
  final String _appTitle;
  final String applicationId;
  final ThemeData? _theme;
  late List<RoutePathFactory> _routeParsers;
  final List<RestorableProvider<RestorableProperty?>>? globalRestorableProviders;
  final RoutePath initialPath;

  /// A singleton of [TabNavModel] accessible via [Provider]
  static late ChangeNotifierProvider<TabNavModel> navModelProvider;

  /// A singleton of the [NavControlType] accessible via [RestorableProvider]
  static late RestorableProvider<RestorableEnumN<NavControlType?>> navControlTypeProvider;

  NavAwareApp({
    /// Used for state restoration
    required this.applicationId,
    /// Application name
    required String appTitle,
    /// Collection of factory methods test-converting
    /// user-typed URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// Initial route to be shown on application start
    required this.initialPath,
    /// Application navigation tab definitions
    required List<TabInfo> tabs,
    /// Application color theme
    ThemeData? theme,
    /// Navigation type. Auto if not specified.
    NavControlType? navType,
    /// Restorable state providers with global scope
    this.globalRestorableProviders,

    super.key
  }) :
    _appTitle = appTitle,
    _theme = theme
  {
    navModelProvider = ChangeNotifierProvider(
            (ref) => TabNavModel(tabs: tabs)
    );

    navControlTypeProvider = RestorableProvider<RestorableEnumN<NavControlType>>(
            (ref) => RestorableEnumN<NavControlType>(NavControlType.values, initialValue: navType),
            restorationId: "nav-control-type"
    );

    _routeParsers = [...routeParsers, _parseHome];
  }

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Future<void> future = initialPath.configureStateFromUri(ref); // TODO: allow time for this to complete
    
    return MaterialApp.router(
        title: appTitle,
        theme: _theme,
        routerDelegate: NavAwareRouterDelegate(ref),
        routeInformationParser: NavAwareRouteInfoParser(
            ref, routeParsers: _routeParsers),
        restorationScopeId: "app-router-restoration-scope",
        debugShowCheckedModeBanner: false, // Hide 'Debug' ribbon on the AppBar,

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
                providers: [
                  navControlTypeProvider,
                  ... globalRestorableProviders ?? []
                ],
                child: router! // ?? const SizedBox.shrink(),
            )
    );
  }

  /// Returns the name of the application
  String get appTitle => _appTitle;

  /// Returns path object for the "/" (home) route
  RoutePath? _parseHome(Uri uri) => uri.path == '/' ? initialPath : null;
}
