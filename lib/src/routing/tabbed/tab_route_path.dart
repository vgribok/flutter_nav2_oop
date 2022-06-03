part of flutter_nav2_oop;

class TabRoutePathAdapter extends RoutePath {

  /// Index of the tab associated with this route.
  final int tabIndex;
  final RoutePath routePath;

  TabRoutePathAdapter({
    required this.tabIndex,
    required this.routePath
  }) : super(resource: routePath.resource);

  TabNavModel tabNavState(WidgetRef ref) => navModel(ref) as TabNavModel;

  @override
  _NavModelBase navModel(WidgetRef ref) => routePath.navModel(ref);

  @override
  Future<void> configureStateFromUriFuture(WidgetRef ref) =>
      routePath.configureStateFromUriFuture(ref);

  @override
  void configureStateFromUri(WidgetRef ref) =>
    routePath.configureStateFromUri(ref);

  @override
  String get location => routePath.location;
}
