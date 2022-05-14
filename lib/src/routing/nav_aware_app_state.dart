part of flutter_nav2_oop;

class NavAwareApp extends ConsumerWidget {

  /// Application name
  final String _appTitle;
  final String applicationId;
  final ThemeData? _theme;
  final List<RoutePathFactory> routeParsers;

  // static final navModelProvider = RestorableProvider<NavType>(
  //
  // );

  /// A singleton of [NavAwareState] accessible via [Provider]
  static late Provider<NavAwareState> navModelProvider;

  /// A singleton [Router] accessible via [Provider]
  static final _routerDelegateProvider = Provider<NavAwareRouterDelegate>(
      (ref) => NavAwareRouterDelegate(ref)
  );

  NavAwareApp({
    /// Used for state restoration
    required this.applicationId,
    /// Application name
    required String appTitle,
    /// Collection of factory methods test-converting
    /// user-typed URLs into [RoutePath] subclass instances
    required this.routeParsers,
    /// Application navigation tab definitions
    required List<TabInfo> tabs,
    /// Application color theme
    ThemeData? theme,
    /// Navigation type. Auto if not specified.
    NavType? navType,
  }) :
    _appTitle = appTitle,
    _theme = theme
  {
    navModelProvider = Provider(
            (ref) => NavAwareState(tabs: tabs, navType: navType)
    );
  }

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
          MaterialApp.router(
              title: appTitle,
              theme: _theme,
              routerDelegate: ref.read(_routerDelegateProvider),
              routeInformationParser: NavAwareRouteInfoParser(ref, routeParsers: routeParsers),
              restorationScopeId: "app-router-restoration-scope",
              debugShowCheckedModeBanner: false, // Hide 'Debug' ribbon on the AppBar,
              // builder: (context, child) => RestorableProviderRegister(
              //   restorationId: 'application-ephemeral-state',
              //   providers: [
              //     // primaryMaterialColorProvider,
              //   ],
              //   child: child! // ?? const SizedBox.shrink(),
              // )
      );

  /// Returns the name of the application
  String get appTitle => _appTitle;
}
