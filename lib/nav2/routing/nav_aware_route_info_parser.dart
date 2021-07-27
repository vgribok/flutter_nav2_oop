import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/not_found_route_path.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';

typedef RoutePathFactory = RoutePath? Function(Uri);

class NavAwareRouteInfoParser extends RouteInformationParser<RoutePath> {

  final List<RoutePathFactory> routeParsers;
  final TabNavState navState;

  NavAwareRouteInfoParser({required this.navState, required this.routeParsers});

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    for (RoutePathFactory routePathFactory in routeParsers) {
      RoutePath? path = routePathFactory(uri);
      if (path != null) {
        return Future.value(path);
      }
    }

    return Future.value(NotFoundRoutePath(notFoundUri: uri, navTabIndex: navState.selectedTabIndex));
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath path) => path.routeInformation;
}
