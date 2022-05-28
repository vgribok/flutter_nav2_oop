part of flutter_nav2_oop;

class TabRoutePathAdapter extends RoutePath {

  /// Index of the tab associated with this route.
  final int tabIndex;
  final RoutePath routePath;

  TabRoutePathAdapter({
    required this.tabIndex,
    required this.routePath
  }) : super(resource: routePath.resource);

  TabNavModel tabNavState(WidgetRef ref) => navState(ref) as TabNavModel;

  @override
  _NavModelBase navState(WidgetRef ref) => routePath.navState(ref);

  @override
  Future<void> configureStateFromUriFuture(WidgetRef ref) =>
      routePath.configureStateFromUriFuture(ref);

  @override
  void configureStateFromUri(WidgetRef ref) {
    routePath.configureStateFromUri(ref);
    tabNavState(ref)._setSelectedTabIndex(tabIndex, byUser: true);
  }

  @override
  String get location => routePath.location;
}
