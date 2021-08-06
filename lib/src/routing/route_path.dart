part of flutter_nav2_oop;

/// Represents current navigation state as a URI.
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

  /// Framework calls this method to let subclasses construct valid
  /// state from a URL typed by a user into browser's address bar.
  ///
  /// Classes overriding this method should call `super` method
  /// to ensure correct selected tab switching.
  /// Overriding this method is not required if all that needed
  /// is changing current navigation tab.
  @protected
  Future<void> configureStateFromUri(NavAwareState navState) {
    navState.selectedTabIndex = tabIndex;
    return Future.value();
  }

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

  /// Convenience method surfacing [NavAwareState] ability
  /// to find state object by its type
  T? stateByType<T extends ChangeNotifier>(
      NavAwareState navState,
      {
        /// Set to true to search all tab state
        /// object collections, as opposed to
        /// just screen's tab state object collection
        bool stateObjectIsInAnotherTab = false
      }) =>
    navState.stateByType<T>(tabIndex: tabIndex, searchOtherTabs: stateObjectIsInAnotherTab);
}
