import 'package:example/src/screens/user_profile_screen.dart';
import 'package:flutter_nav2_oop/all.dart';

class UserProfilePath extends RoutePath {

  static const String resourceName = 'profile';

  const UserProfilePath() : super(
      tabIndex: UserProfileScreen.navTabIndex,
      resource: resourceName
  );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? const UserProfilePath() : null;
}