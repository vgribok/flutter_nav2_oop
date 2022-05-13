part of flutter_nav2_oop;

class NavAwareApp extends ConsumerWidget {

  /// Application name
  final String _appTitle;
  final String applicationId;
  final ThemeData? _theme;
  final NavAwareState navState;
  final List<RoutePathFactory> routeParsers;

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
    navState = NavAwareState(navType: navType, tabs: tabs),
    _theme = theme;

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ProviderScope(child:
        OrientationBuilder(builder: (context, orientation) {
          navState.isPortrait = orientation == Orientation.portrait;

          return MaterialApp.router(
              title: appTitle,
              theme: _theme,
              routerDelegate: NavAwareRouterDelegate(ref, navState: navState),
              routeInformationParser: NavAwareRouteInfoParser(ref, routeParsers: routeParsers),
              restorationScopeId: "app-router-restoration-scope",
              debugShowCheckedModeBanner: false // Hide 'Debug' ribbon on the AppBar
          );
        })
      );

  /// Returns the name of the application
  String get appTitle => _appTitle;
}
