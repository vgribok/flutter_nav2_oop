import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/amplifyconfiguration.dart';

FutureProvider<void> get appInitFutureProvider => FutureProvider((ref) async {
  await ref.read(AmplifyDal._amplifyInitFutureProvider.future);
  ref.watch(AmplifyDal._authEventProvider);
});

class AmplifyDal {

  static final Provider<StreamSubscription<HubEvent>> _authEventProvider = Provider(
      (ref) =>
        Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
          ref.refresh(_amplifyUserProvider);
          ref.refresh(_amplifyUserSignedInProvider);
          ref.refresh(_amplifyAuthUserAttributesProvider);

          safePrint("Starter app auth event: ${hubEvent.eventName}");
        }
      )
  );

  static final FutureProvider<void> _amplifyInitFutureProvider = FutureProvider<void>(
      (ref) async {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
        await ref.watch(_amplifyUserSignedInProvider.future);
      }
  );

  static final FutureProvider<bool> _amplifyUserSignedInProvider = FutureProvider(
      (ref) async => (await Amplify.Auth.fetchAuthSession()).isSignedIn
  );

  static bool watchForUserSignedInStatus(WidgetRef ref) =>
      ref.watch(_amplifyUserSignedInProvider).value ?? false;

  static Future<SignOutResult> signOut() => Amplify.Auth.signOut();

  static final FutureProvider<Iterable<MapEntry<String, String>>?> _amplifyAuthUserAttributesProvider = FutureProvider(
      (ref) async {
        final bool isUserSignedIn = await ref.watch(_amplifyUserSignedInProvider.future);
        if(!isUserSignedIn) return null;
        final userAttributes = await Amplify.Auth.fetchUserAttributes();
        return userAttributes.map((userAttribute) =>
            MapEntry(userAttribute.userAttributeKey.key, userAttribute.value));
      }
  );

  static Iterable<MapEntry<String, String>>? watchForUserAttributes(WidgetRef ref) =>
      ref.watch(_amplifyAuthUserAttributesProvider).value;

  static final FutureProvider<AuthUser?> _amplifyUserProvider = FutureProvider(
      (ref) async {
        final bool isUserSignedIn = await ref.watch(_amplifyUserSignedInProvider.future);
        if(!isUserSignedIn) return null;
        return await Amplify.Auth.getCurrentUser();
      }
  );

  static AuthUser? watchForAuthenticatedUser(WidgetRef ref) =>
      ref.watch(_amplifyUserProvider).value;
}

extension IterableEx on Iterable {
  Map<K,V> toMap<K,V>(K Function(dynamic element)? keyGetter, V Function(dynamic element)? valueGetter) =>
      Map.fromIterable(this, key: keyGetter, value: valueGetter);
}