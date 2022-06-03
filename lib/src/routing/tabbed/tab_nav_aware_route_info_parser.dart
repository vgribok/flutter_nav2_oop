// ignore_for_file: avoid_renaming_method_parameters

part of flutter_nav2_oop;

/// Abstracts away parsing URLs typed by users into the web browser address bar,
/// and then updating application state to show either a corresponding screen,
/// or a 404 screen, if entered address was invalid.
class TabNavAwareRouteInfoParser extends NavAwareRouteInfoParser {

  const TabNavAwareRouteInfoParser(super.ref);

  @override
  RoutePath getNotFoundRoute(Uri uri)   {
    final int tabIndex = _tabNavModel.selectedTabIndex;
    final notFoundPath = NotFoundRoutePath(notFoundUri: uri);
    final notFoundPathTabbed = notFoundPath.tabbed(tabIndex: tabIndex);
    return notFoundPathTabbed;
  }


  TabNavModel get _tabNavModel => _NavAwareAppBase.navModelFactory(ref) as TabNavModel;
}
