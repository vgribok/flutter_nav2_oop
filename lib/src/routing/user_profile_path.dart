import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/utility/uri_extensions.dart';
import 'package:flutter_nav2_oop/src/screens/user_profile_screen.dart';

class UserProfilePath extends RoutePath {

  static const String resourceName = 'profile';

  const UserProfilePath() : super(
      navTabIndex: UserProfileScreen.navTabIndex,
      resource: resourceName
  );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? UserProfilePath() : null;
}