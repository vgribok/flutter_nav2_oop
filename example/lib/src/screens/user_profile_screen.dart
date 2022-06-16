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
  Widget buildAuthenticatedBody(BuildContext context, WidgetRef ref) {
    // if(!AmplifyDal.watchForUserSignedInStatus(ref)) return _noAttributesUI;

    final AuthUser? user = AmplifyDal.watchForAuthenticatedUser(ref);
    if(user == null) return _noAttributesUI;
    final List<MapEntry<String, String>> userAttributes =
        AmplifyDal.watchForUserAttributes(ref)?.toList() ?? [];
    userAttributes.insertAll(0, [
      MapEntry("username", user.username),
      MapEntry("user_id", user.userId)
    ]);

    return ListView(children: [
      for (MapEntry<String, String> entry in userAttributes)
        ListTile(
          title: Text(entry.key),
          subtitle: Text(entry.value),
          key: ValueKey("user-attribute-${user.userId}-${entry.key}"),
        )
    ]);
  }

  Widget get _noAttributesUI =>
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('User has no attributes'),
            TextButton(onPressed: () => AmplifyDal.signOut(), child: const Text("Sign Out"))
          ]
        ));

  @override
  RoutePath get routePath => UserProfilePath();
}