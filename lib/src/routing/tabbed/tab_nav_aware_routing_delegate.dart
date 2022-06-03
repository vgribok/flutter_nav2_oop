// ignore_for_file: avoid_renaming_method_parameters

part of flutter_nav2_oop;

class TabNavAwareRouterDelegate extends _NavAwareRouterDelegateBase<TabNavModel> {

  TabNavAwareRouterDelegate(super.ref);

  @override
  TabNavModel get navModel => _NavAwareAppBase.navModelFactory(ref) as TabNavModel;

  @override
  Future<void> setNewRoutePath(RoutePath path) {
    final int tabIndex = (path as TabRoutePathAdapter).tabIndex;
    // navModel._setSelectedTabIndex(tabIndex, byUser: true);
    navModel.selectedTabIndex = tabIndex;
    return super.setNewRoutePath(path);
  }
}