import 'package:example/src/routing/user_profile_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:provider/src/change_notifier_provider.dart';

class UserProfileScreen extends NavScreen {

  static const int navTabIndex = 1;

  const UserProfileScreen(List<ChangeNotifierProvider> providers) : super(
    screenTitle: 'User Profile',
    tabIndex: navTabIndex,
    providers: providers
  );

  @override
  Widget buildBody(BuildContext context)  =>
      const Center(
        child: Text('User Profile will go here'),
      );

  @override
  RoutePath get routePath => const UserProfilePath();
}