part of '../../../all.dart';

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
  NavModelBase navModel(WidgetRef ref) => routePath.navModel(ref);

  @override
  Future<bool> configureStateFromUriFuture(WidgetRef ref) =>
      routePath.configureStateFromUriFuture(ref);

  @override
  bool configureStateFromUri(WidgetRef ref) =>
    routePath.configureStateFromUri(ref);

  @override
  String get location => routePath.location;
}
