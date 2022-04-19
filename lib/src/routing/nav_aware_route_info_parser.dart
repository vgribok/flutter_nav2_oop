part of flutter_nav2_oop;

/// Factory method signature for converting URLs
/// to [RoutePath] instances
typedef RoutePathFactory = RoutePath? Function(Uri, BuildContext);

/// Abstracts away parsing URLs typed by users into the web browser address bar,
/// and then updating application state to show either a corresponding screen,
/// or a 404 screen, if entered address was invalid.
class NavAwareRouteInfoParser extends RouteInformationParser<RoutePath> {

  /// Collection of parsers each serving as a factory
  /// for instantiating [RoutePath] subclass corresponding
  /// to entered URL
  final List<RoutePathFactory> routeParsers;

  /// Build context
  final BuildContext context;

  const NavAwareRouteInfoParser(this.context, this.routeParsers);

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    /// Let each route factory test-parse the URL.
    RoutePath? path = routeParsers
      .map((parser) => parser(uri, context))
      .firstSafe((path) => path != null);

    // None of URL parsers have recognized the URL.
    // Return the 404 route object.
    return Future.value(
        path ?? NotFoundRoutePath(context, notFoundUri: uri)
    );
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath configuration)
      => configuration._routeInformation;
}
