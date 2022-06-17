import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/amplifyconfiguration.dart';
import 'package:flutter_nav2_oop/all.dart';

final userSignedInStatusProvider = AmplifyUserSignedInStatusProvider();
final _amplifyInitFutureProvider = AmplifyInitFutureProvider(userSignedInStatusProvider);
final appInitFutureProvider = AppInitFutureProvider(_amplifyInitFutureProvider);
final userProvider = AmplifyUserProvider(userSignedInStatusProvider);
final userAttributesProvider = AmplifyUserAttributesProvider(userProvider);

class AppInitFutureProvider extends FutureProviderFacade<void> {
  AppInitFutureProvider(AmplifyInitFutureProvider amplifyInitFutureProvider) :
    super((ref) async {
      await amplifyInitFutureProvider.getUnwatchedFuture2(ref);
      // Other initialization calls could be added here
    });
}

class AmplifyUserSignedInStatusProvider extends FutureProviderFacade<bool> {

  late final Provider<StreamSubscription<HubEvent>> _authEventProvider =
    Provider((ref) =>
      Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
        "Starter app auth event: ${hubEvent.eventName}".debugPrint();
        refresh2(ref);
      })
    );

  AmplifyUserSignedInStatusProvider() :
    super((ref) async => (await Amplify.Auth.fetchAuthSession()).isSignedIn);

  bool watchForSignedInStatus(WidgetRef ref) =>
      watch(ref).value ?? false;

  void attachAuthEventSink(Ref ref) =>
      ref.watch(_authEventProvider);
}

class AmplifyInitFutureProvider extends FutureProviderFacade<void> {
  AmplifyInitFutureProvider(AmplifyUserSignedInStatusProvider userSignInProvider) :
    super (
      (ref) async {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
        userSignInProvider.attachAuthEventSink(ref);
        await userSignInProvider.watchFuture2(ref);
      }
    );
}

class AmplifyUserProvider extends FutureProviderFacade<AuthUser?> {

  AmplifyUserProvider(AmplifyUserSignedInStatusProvider userSignInProvider) :
    super (
      (ref) async {
        final bool isUserSignedIn = await userSignInProvider.watchFuture2(ref);
        if(!isUserSignedIn) return null;
        return await Amplify.Auth.getCurrentUser();
      }
    );

  Future<SignOutResult> signOut() => Amplify.Auth.signOut();
}

class AmplifyUserAttributesProvider extends FutureProviderFacade<List<MapEntry<String, String>>?> {

  AmplifyUserAttributesProvider(AmplifyUserProvider amplifyUserProvider)
    : super(
        (ref) async {
          final AuthUser? user = await amplifyUserProvider.watchFuture2(ref);
          if(user == null) return null;

          final List<AuthUserAttribute> userAttributes = await Amplify.Auth.fetchUserAttributes();
          final List<MapEntry<String, String>> attributes =
              userAttributes.map((AuthUserAttribute e) => MapEntry(e.userAttributeKey.key, e.value)).toList();

          attributes.insertAll(0,
            [
              MapEntry("username", user.username),
              MapEntry("user_id", user.userId),
            ]
          );

          return attributes;
        }
  );
}