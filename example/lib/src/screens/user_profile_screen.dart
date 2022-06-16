import 'package:example/src/routing/user_profile_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  const UserProfileScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
          {super.key}) :
        super(screenTitle: 'User Profile');

  @override
  Widget buildBody(BuildContext context, WidgetRef ref)  =>
      const Center(
        child: Text('User Profile will go here'),
      );

  @override
  RoutePath get routePath => UserProfilePath();
}