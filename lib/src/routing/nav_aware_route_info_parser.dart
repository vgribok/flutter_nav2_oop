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
  final List<RoutePathFactory> _routeParsers;

  final WidgetRef ref;

  const NavAwareRouteInfoParser(this.ref, {required List<RoutePathFactory> routeParsers})
    : _routeParsers = routeParsers;

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    /// Let each route factory test-parse the URL.
    RoutePath? path = _routeParsers
      .map((parser) => parser(uri))
      .firstSafe((path) => path != null);

    // None of URL parsers have recognized the URL.
    // Return the 404 route object.
    return Future.value(
        path ?? NotFoundRoutePath(notFoundUri: uri)
    );
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath path) => path._routeInformation;
}
