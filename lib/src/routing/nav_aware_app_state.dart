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
  final List<ChangeNotifier>? _stateItems; // TODO: set them via MultiProvider
  final List<RoutePathFactory> _routeParsers;

  final ThemeData? _theme;

  NavAwareApp({
    /// Application name
    required String appTitle,
    /// Application state holder instance
    required this.navState,
    /// Collection of factory methods test-converting
    /// user-typed URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// A collection of state objects used by screens belonging
    /// to the tab
    List<ChangeNotifier>? stateItems,
    /// Application navigation tab definitions
    required List<TabInfo> tabs,
    /// Application color theme
    ThemeData? theme
  }) :
    _appTitle = appTitle,
    _routerDelegate = NavAwareRouterDelegate(navState: navState),
    _routeParsers = routeParsers,
    _stateItems = stateItems ?? const [],
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
          routeInformationParser: NavAwareRouteInfoParser(context, _routeParsers),
          restorationScopeId: 'root',
          debugShowCheckedModeBanner: false // Hide 'Debug' ribbon on the AppBar
      );
    });

  /// Returns the name of the application
  String get appTitle => _appTitle;
}
