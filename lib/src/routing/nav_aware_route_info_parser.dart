// ignore_for_file: avoid_renaming_method_parameters

part of flutter_nav2_oop;

/// Factory method signature for converting URLs
/// to [RoutePath] instances
typedef RoutePathFactory = RoutePath? Function(Uri);

/// Abstracts away parsing URLs typed by users into the web browser address bar,
/// and then updating application state to show either a corresponding screen,
/// or a 404 screen, if entered address was invalid.
class NavAwareRouteInfoParser extends RouteInformationParser<RoutePath> {

  /// Riverpod context reference
  final WidgetRef ref;

  @protected
  _NavModelBase get navModel => _NavAwareAppBase.navModelFactory(ref);

  /// Collection of parsers each serving as a factory
  /// for instantiating [RoutePath] subclass corresponding
  /// to entered URL
  List<RoutePathFactory> get routeParsers => navModel.routeParsers;

  const NavAwareRouteInfoParser(this.ref);

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    /// Let each route factory test-parse the URL.
    RoutePath? path = routeParsers
      .map((parser) => parser(uri))
      .firstSafe((path) => path != null);

    // None of URL parsers have recognized the URL.
    // Return the 404 route object.
    path ??= getNotFoundRoute(uri);

    return Future.value(path);
  }

  @protected
  RoutePath getNotFoundRoute(Uri uri) => NotFoundRoutePath(notFoundUri: uri);

  @override
  RouteInformation? restoreRouteInformation(RoutePath path) =>
      path._routeInformation;
}
