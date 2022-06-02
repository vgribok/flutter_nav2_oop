// ignore_for_file: avoid_renaming_method_parameters

part of flutter_nav2_oop;

/// Abstracts away parsing URLs typed by users into the web browser address bar,
/// and then updating application state to show either a corresponding screen,
/// or a 404 screen, if entered address was invalid.
class TabNavAwareRouteInfoParser extends NavAwareRouteInfoParser {

  const TabNavAwareRouteInfoParser(super.ref, {required super.routeParsers});

  @override
  RoutePath getNotFoundRoute(Uri uri) =>
    NotFoundRoutePath(notFoundUri: uri)
        .tabbed(tabIndex: _tabNavModel.selectedTabIndex);

  TabNavModel get _tabNavModel => _NavAwareAppBase.navModelFactory(ref) as TabNavModel;
}
