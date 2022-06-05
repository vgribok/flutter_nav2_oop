part of flutter_nav2_oop;

/// Represents current navigation state as a URI.
/// [RoutePath]s gets constructed by [NavScreen]s to report current
/// screen path, and by the typed URL parser (for Web).
///
/// Provides bi-directional mapping between
/// routes and corresponding state objects.
/// Routes are not aware of screens - only of the state.
/// Screens are aware of routes, i.e. screens report to the system
/// which route Web browser should be showing.
class RoutePath {

  /// Resource name, as in REST.
  /// It's usually a plural noun.
  final String resource;

  const RoutePath({
    required this.resource
  });

  @protected
  _NavModelBase navModel(WidgetRef ref) => _NavAwareAppBase.navModelFactory(ref);

  Future<void> _configureStateFromUriFuture(WidgetRef ref) async {
    navModel(ref).notFoundUri = null; // cleans up 404 url before another attempt at paring user-typed URL
    if(configureStateFromUri(ref)) {
      if(await configureStateFromUriFuture(ref)) {
        return;
      }
    }
    navModel(ref).notFoundUri = uri;
  }

  /// Framework calls this method to let subclasses construct valid
  /// state from a URL typed by a user into browser's address bar.
  /// User if need async, and for sync cases override [configureStateFromUri].
  /// Returns false if URL can't be converted into a valid state,
  /// 404 page will be rendered.
  ///
  /// Overriding this method is not required if all that needed
  /// is changing current navigation tab.
  @protected
  Future<bool> configureStateFromUriFuture(WidgetRef ref) async =>
    true;

  /// Framework calls this method to let subclasses construct valid
  /// state from a URL typed by a user into browser's address bar.
  /// Returns false if URL can't be converted into a valid state,
  /// 404 page will be rendered.
  ///
  /// Overriding this method is not required if all that needed
  /// is changing current navigation tab.
  @protected
  bool configureStateFromUri(WidgetRef ref) => true;

  /// Returns location URI for the given route.
  ///
  /// This string will be shown in the browser address bar after
  /// navigation actions change the current route. This
  /// typically happens when the change of app state leads to
  /// another top screen displayed.
  /// Default behavior is to return '/resourcename/' string.
  String get location => '/$resource/';

  /// Maps current route object to Flutter-required [RouteInformation] object
  RouteInformation? get _routeInformation => RouteInformation(location: location);

  TabRoutePathAdapter tabbed({required int tabIndex}) =>
      TabRoutePathAdapter(tabIndex: tabIndex, routePath: this);

  Uri get uri => Uri.parse("${Uri.base}$location");
}
