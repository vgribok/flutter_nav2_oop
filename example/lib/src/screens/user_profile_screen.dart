import 'package:example/src/routing/user_profile_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends NavScreen {

  static const int navTabIndex = 3;

  const UserProfileScreen({super.key}) : super(
    screenTitle: 'User Profile',
    tabIndex: navTabIndex,
  );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref)  =>
      const Center(
        child: Text('User Profile will go here'),
      );

  @override
  RoutePath get routePath => const UserProfilePath();
}