part of flutter_nav2_oop;

typedef NavAwareAppStateFactory = NavAwareAppState Function();

class NavAwareApp extends StatefulWidget {

  final NavAwareAppStateFactory stateFactory;

  const NavAwareApp({Key? key, required this.stateFactory })
      : super(key: key);

  @override
  State<NavAwareApp> createState() => stateFactory();
}

/// Encapsulates boilerplate of the app initialization
/// that wires together [NavAwareState]-aware subclass of
/// [RouterDelegate], the [RouteInformationParser], and
/// wrapping application UI in the [MaterialApp.router] Widget.
class NavAwareAppState extends State<NavAwareApp>
      with RestorationMixin {

  /// Application name
  final String _appTitle;
  final NavAwareRouteInfoParser _routeInformationParser;
  final String applicationId;
  final ThemeData? _theme;
  final NavStateRestorer _navStateRestorer;

  NavAwareAppState({
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
    _navStateRestorer = NavStateRestorer(navType: navType, tabs: tabs),
    _theme = theme;

  NavAwareState get navState => _navStateRestorer.value;

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context) =>
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
    });

  /// Returns the name of the application
  String get appTitle => _appTitle;

  @override
  String? get restorationId => applicationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_navStateRestorer, "navigation-state");
  }
}
