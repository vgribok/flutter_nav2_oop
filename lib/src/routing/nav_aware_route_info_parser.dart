part of flutter_nav2_oop;

/// Factory method signature for converting URLs
/// to [RoutePath] instances
typedef RoutePathFactory = RoutePath? Function(Uri);

/// Abstracts away parsing URLs typed by users into the web browser address bar,
/// and then updating application state to show either a corresponding screen,
/// or a 404 screen, if entered address was invalid.
class NavAwareRouteInfoParser extends RouteInformationParser<RoutePath> {

  /// Collection of parsers each serving as a factory
  /// for instantiating [RoutePath] subclass corresponding
  /// to entered URL
  final List<RoutePathFactory> routeParsers;

  const NavAwareRouteInfoParser({required this.routeParsers});

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    /// Let each route factory to test-parse the URL.
    for (RoutePathFactory routePathFactory in routeParsers) {
      RoutePath? path = routePathFactory(uri);
      if (path != null) {
        return Future.value(path);
      }
    }

    // None of URL parsers recognized the URL.
    // Return the 404 route object.
    return Future.value(
      NotFoundRoutePath(notFoundUri: uri));
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath path) => path._routeInformation;
}
