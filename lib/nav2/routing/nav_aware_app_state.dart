import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_info.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';

import 'nav_aware_route_info_parser.dart';
import 'nav_aware_routing_delegate.dart';

/// Encapsulates boilerplate of the [State] initialization
/// that wires together [TabNavState]-aware subclass of
/// [RouterDelegate], the [RouteInformationParser], and
/// wrapping application UI in the [MaterialApp.router] Widget.
class NavAwareAppState<T extends StatefulWidget> extends State<T> {

  /// [TabNavState] instance that lives as long as
  ///  app state does
  final TabNavState navState;

  /// Application name
  final String _appTitle;

  final NavAwareRouterDelegate _routerDelegate;
  final NavAwareRouteInfoParser _routeInformationParser;

  NavAwareAppState({
    /// Application name
    required String appTitle,
    /// Application state holder instance
    required this.navState,
    /// Collection of factory methods test-converting
    /// user-typed URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// Application navigation tab definitions
    required List<TabInfo> tabs
  }) :
    _appTitle = appTitle,
    _routeInformationParser = NavAwareRouteInfoParser(routeParsers: routeParsers),
    _routerDelegate = NavAwareRouterDelegate(
        navState: navState
    )
  {
    navState.addTabs(tabs);
  }

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appTitle,
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }

  /// Returns the name of the application
  String get appTitle => _appTitle;
}
