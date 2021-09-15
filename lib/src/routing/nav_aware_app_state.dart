part of flutter_nav2_oop;

/// Encapsulates boilerplate of the app initialization
/// that wires together [NavAwareState]-aware subclass of
/// [RouterDelegate], the [RouteInformationParser], and
/// wrapping application UI in the [MaterialApp.router] Widget.
class NavAwareApp extends StatelessWidget {

  /// [NavAwareState] instance that lives as long as
  ///  app state does
  final NavAwareState navState;

  /// Application name
  final String _appTitle;

  final NavAwareRouterDelegate _routerDelegate;
  final NavAwareRouteInfoParser _routeInformationParser;

  final ThemeData? _theme;

  NavAwareApp({
    /// Application name
    required String appTitle,
    /// Application state holder instance
    required this.navState,
    /// Collection of factory methods test-converting
    /// user-typed URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// Application navigation tab definitions
    required List<TabInfo> tabs,
    /// Application color theme
    ThemeData? theme
  }) :
    _appTitle = appTitle,
    _routeInformationParser = NavAwareRouteInfoParser(routeParsers: routeParsers),
    _routerDelegate = NavAwareRouterDelegate(navState: navState),
    _theme = theme
  {
    navState.addTabs(tabs);
  }

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context) =>
    OrientationBuilder(builder: (context, orientation) {
      navState.isPortrait = orientation == Orientation.portrait;

      return MaterialApp.router(
          title: appTitle,
          theme: _theme,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
          restorationScopeId: 'root',
          debugShowCheckedModeBanner: false // Hide 'Debug' ribbon on the AppBar
      );
    });

  /// Returns the name of the application
  String get appTitle => _appTitle;
}
