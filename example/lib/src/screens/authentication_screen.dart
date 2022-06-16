import 'package:example/src/dal/amplify_dal.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

abstract class AuthenticatedScreen extends TabNavScreen {

  const AuthenticatedScreen(super.tabIndex,
        {
        /// Screen title
        required super.screenTitle,
        /// Optional user-supplied key.
        /// If not supplied, route URI
        /// is used as the key
        super.key,
        });

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
        AuthenticatedView(key: ValueKey("auth-view-$screenTitle"),
            child: buildAuthenticatedBody(context, ref)
        );

  @protected
  Widget buildAuthenticatedBody(BuildContext context, WidgetRef ref);

  @override
  List<Widget>? buildAppBarActions(BuildContext context, WidgetRef ref) =>
      [
        if(AmplifyDal.watchForUserSignedInStatus(ref))
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Sign out ${AmplifyDal.watchForAuthenticatedUser(ref)?.username}",
              onPressed: () => AmplifyDal.signOut()
          )
      ];
}