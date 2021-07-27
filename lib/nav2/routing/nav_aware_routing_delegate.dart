import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

class NavAwareRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final TabNavState navState;
  final List<ChangeNotifier> _stateItems;

  NavAwareRouterDelegate({
    required this.navState,
    required List<ChangeNotifier>? stateItems,
  }) :
    navigatorKey = GlobalKey<NavigatorState>(),
    _stateItems = [...?stateItems]
  {
    navState.addListener(notifyListeners);
    _stateItems.forEach((stateItem) => stateItem.addListener(notifyListeners));
  }

  @override
  Widget build(BuildContext context) {

    final List<Page<dynamic>> pageStack =
      navState.buildNavigatorScreenStack()
          .map((screen) => screen.page)
          .toList();

    return Navigator(
      key: navigatorKey,
      //transitionDelegate: NoAnimationTransitionDelegate(),
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
      path.configureState(navState, _stateItems);
}
