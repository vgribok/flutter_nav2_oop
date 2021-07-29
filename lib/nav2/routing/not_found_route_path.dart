import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';

class NotFoundRoutePath extends RoutePath {

  final Uri notFoundUri;

  const NotFoundRoutePath({required this.notFoundUri, required int navTabIndex}) :
    super(navTabIndex: navTabIndex, resource: '404-page-not-found');

  @override
  Future<void> configureStateFromUri(TabNavState navState) {
    navState.notFoundUri = notFoundUri;
    return Future.value();
  }
}
