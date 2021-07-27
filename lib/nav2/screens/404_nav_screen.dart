import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/routing/not_found_route_path.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

typedef NotFoundScreenFactory = UrlNotFoundScreen Function(TabNavState navState);

class UrlNotFoundScreen extends TabbedNavScreen {

  static NotFoundScreenFactory notFoundScreenFactory = (navState) { return UrlNotFoundScreen(navState: navState);};

  static String defaultMessage = 'Following URI is incorrect: ';
  static String defaultTitle = 'Resource not found';

  final Uri notFoundUri;

  UrlNotFoundScreen({required TabNavState navState}) :
    notFoundUri = navState.notFoundUri!,
    super(
      pageTitle: defaultTitle,
      tabIndex: navState.selectedTabIndex,
      navState: navState
    );

  @override
  Widget buildBody(BuildContext context) =>
    Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(defaultMessage),
          Text(
              '\"${navState.notFoundUri}\"',
              style: TextStyle(fontWeight: FontWeight.bold)
          )
        ])
    );

  @override
  void removeFromNavStackTop() => navState.notFoundUri = null;

  @override
  RoutePath get routePath => NotFoundRoutePath(notFoundUri: notFoundUri, navTabIndex: tabIndex);
}