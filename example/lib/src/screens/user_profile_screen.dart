import 'package:example/src/routing/user_profile_path.dart';
import 'package:example/src/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/src/dal/amplify_dal.dart';

class UserProfileScreen extends AuthenticatedScreen { // Subclass NavScreen to enable non-tab navigation

  const UserProfileScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
        {super.key}) :
        super(screenTitle: 'User Profile');

  @override
  Widget buildAuthenticatedBody(BuildContext context, WidgetRef ref)  =>
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('TBD: User Profile will go here'),
            const Divider(thickness: 1, indent: 50, endIndent: 50),
            TextButton(onPressed: () => AmplifyDal.signOut(),
                child: const Text("Sign Out")
            )
          ]
        ));

  @override
  RoutePath get routePath => UserProfilePath();
}