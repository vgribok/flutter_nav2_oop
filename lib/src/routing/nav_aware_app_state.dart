part of flutter_nav2_oop;

class NavAwareApp extends StatelessWidget {

  /// Application name
  final String _appTitle;
  final NavAwareRouteInfoParser _routeInformationParser;
  final String applicationId;
  final ThemeData? _theme;
  final NavAwareState navState;

  NavAwareApp({
    /// Used for state restoration
    required this.applicationId,
    /// Application name
    required String appTitle,
    /// Collection of factory methods test-converting
    /// user-typed URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// Application navigation tab definitions
    required List<TabInfo> tabs,
    /// Application color theme
    ThemeData? theme,
    /// Navigation type. Auto if not specified.
    NavType? navType,
  }) :
    _appTitle = appTitle,
    _routeInformationParser = NavAwareRouteInfoParser(routeParsers: routeParsers),
    navState = NavAwareState(navType: navType, tabs: tabs),
    _theme = theme;

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context) =>
      ProviderScope(child:
        OrientationBuilder(builder: (context, orientation) {
          navState.isPortrait = orientation == Orientation.portrait;

          return MaterialApp.router(
              title: appTitle,
              theme: _theme,
              routerDelegate: NavAwareRouterDelegate(navState: navState),
              routeInformationParser: _routeInformationParser,
              restorationScopeId: "app-router-restoration-scope",
              debugShowCheckedModeBanner: false // Hide 'Debug' ribbon on the AppBar
          );
        }        )
      );

  /// Returns the name of the application
  String get appTitle => _appTitle;
}
