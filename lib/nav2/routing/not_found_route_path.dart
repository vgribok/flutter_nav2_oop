import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';

/// Route object representing invalid
/// user-typed browser web address URL
class NotFoundRoutePath extends RoutePath {

  /// Invalid URL typed int by the user
  /// into the web browser address bar
  final Uri notFoundUri;

  const NotFoundRoutePath({required this.notFoundUri}) :
    super(tabIndex: 0, resource: '404-page-not-found');

  @override
  Future<void> configureStateFromUri(TabNavState navState) {
    navState.notFoundUri = notFoundUri;
    return Future.value();
  }
}
