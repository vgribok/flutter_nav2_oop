import 'package:example/src/routing/user_profile_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

class UserProfileScreen extends NavScreen {

  static const int navTabIndex = 3;

  const UserProfileScreen(TabNavModel navState) : super(
    screenTitle: 'User Profile',
    tabIndex: navTabIndex,
    navState: navState
  );

  @override
  Widget buildBody(BuildContext context)  =>
      Center(
        child: Text('User Profile will go here'),
      );

  @override
  RoutePath get routePath => UserProfilePath();
}