import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
  Widget buildAuthenticatedBody(BuildContext context, WidgetRef ref) =>
    AsyncValueAwaiter<List<MapEntry<String, String>>?>(
      asyncData: userAttributesProvider.watchAsyncValue(ref),
      waitText: "Loading user information...",
      builder: (attributes) =>
        (attributes ?? []).isEmpty ? const WaitIndicator(waitText: "Loading user information...") :
                ListView(children: [
                  for (MapEntry<String, String> entry in attributes ?? [])
                    ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                      key: ValueKey("user-attribute-${entry.key}-${entry.value}"),
                    )
                ])
    );

  @override
  RoutePath get routePath => UserProfilePath();
}