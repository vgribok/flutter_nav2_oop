import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';

class RoutePath {

  final String resource;
  final int navTabIndex;

  const RoutePath({
    required this.navTabIndex,
    required this.resource
  });

  Future<void> configureState(TabNavState navState, List<ChangeNotifier> stateItems) {
    navState.selectedTabIndex = navTabIndex;
    return Future.value();
  }

  String get location => '/$resource/';

  RouteInformation? get routeInformation => RouteInformation(location: location);

  T myState<T extends ChangeNotifier>(Iterable<ChangeNotifier> stateItems) =>
      stateItems.singleWhere((element) => element is T) as T;
}
