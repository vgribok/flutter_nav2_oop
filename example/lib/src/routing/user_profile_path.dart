import 'package:flutter_nav2_oop/all.dart';

class UserProfilePath extends RoutePath {

  static const String resourceName = 'profile';

  UserProfilePath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? UserProfilePath() : null;
}