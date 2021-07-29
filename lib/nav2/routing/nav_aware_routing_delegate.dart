import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

import 'no_animation_transition_delegate.dart';

class NavAwareRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final TabNavState navState;

  NavAwareRouterDelegate({
    required this.navState,
  }) :
    navigatorKey = GlobalKey<NavigatorState>()
  {
    navState.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {

    final List<Page<dynamic>> pageStack =
      navState.buildNavigatorScreenStack()
          .map((screen) => screen.page)
          .toList();

    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: pageStack,
      onPopPage: onBackButtonPress,
    );
  }

  bool onBackButtonPress(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    dynamic page = route.settings;
    TabbedNavScreen navScreen = page.child as TabbedNavScreen;
    navScreen.removeFromNavStackTop();

    return true;
  }

  @override
  RoutePath get currentConfiguration =>
      navState.buildNavigatorScreenStack().last.routePath;

  @override
  Future<void> setNewRoutePath(RoutePath path) =>
      path.configureStateFromUri(navState);
}
