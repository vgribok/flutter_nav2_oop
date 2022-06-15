import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/amplifyconfiguration.dart';

FutureProvider<void> get appInitFutureProvider => AmplifyDal._amplifyInitFutureProvider;

class AmplifyDal {

  static final FutureProvider<void> _amplifyInitFutureProvider = FutureProvider<void>(
      (ref) async {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
        await _amplifyUserSignedInProvider.future;
      }
  );

  static final FutureProvider<bool> _amplifyUserSignedInProvider = FutureProvider(
          (ref) async => (await Amplify.Auth.fetchAuthSession()).isSignedIn
  );

  static bool watchForUserSignedInStatus(WidgetRef ref) =>
      ref.watch(_amplifyUserSignedInProvider).value ?? false;

  static Future<SignOutResult> signOut() => Amplify.Auth.signOut();
}