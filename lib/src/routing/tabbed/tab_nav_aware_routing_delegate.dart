// ignore_for_file: avoid_renaming_method_parameters

part of flutter_nav2_oop;

class TabNavAwareRouterDelegate extends _NavAwareRouterDelegateBase<TabNavModel> {

  TabNavAwareRouterDelegate(super.ref);

  @override
  TabNavModel get navModel => _NavAwareAppBase.navModelFactory(ref) as TabNavModel;

  @override
  Future<void> setNewRoutePath(RoutePath path) {
    navModel.selectedTabIndex = (path as TabRoutePathAdapter).tabIndex;
    return super.setNewRoutePath(path);
  }
}