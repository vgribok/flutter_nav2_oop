part of flutter_nav2_oop;

// TODO: Refactor the project to make routes primary sources of state and sole factories of screens
/// Represents current navigation state as a URI.
/// [RoutePath]s gets constructed by [NavScreen]s to report current
/// screen path, and by the typed URL parser (for Web).
///
/// Provides bi-directional mapping between
/// routes and corresponding state objects.
class RoutePath {

  /// Resource name, as in REST.
  /// It's usually a plural noun.
  final String resource;

  /// Index of the tab associated with this route.
  final int tabIndex;

  const RoutePath({
    required this.tabIndex,
    required this.resource
  });

  @protected
  static TabNavModel navState(WidgetRef ref) => ref.read(NavAwareApp.navModelProvider);

  /// Framework calls this method to let subclasses construct valid
  /// state from a URL typed by a user into browser's address bar.
  /// User if need async, and for sync cases override [configureStateFromUri].
  ///
  /// Classes overriding this method should call `super` method
  /// to ensure correct selected tab switching.
  /// Overriding this method is not required if all that needed
  /// is changing current navigation tab.
  @protected
  @mustCallSuper
  Future<void> configureStateFromUriFuture(WidgetRef ref) {
    navState(ref).selectedTabIndex = tabIndex;
    configureStateFromUri(ref);
    return Future.value();
  }

  /// Framework calls this method to let subclasses construct valid
  /// state from a URL typed by a user into browser's address bar.
  ///
  /// Overriding this method is not required if all that needed
  /// is changing current navigation tab.  @protected
  void configureStateFromUri(WidgetRef ref) {}

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
}
