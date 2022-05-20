import 'package:flutter_nav2_oop/all.dart';

class UserProfilePath extends RoutePath {

  static const String resourceName = 'profile';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTabIndex = 3;

  UserProfilePath({required super.tabIndex})
      : super(resource: resourceName)
  {
    assert(tabIndex == defaultTabIndex);
  }

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? UserProfilePath(tabIndex: defaultTabIndex) : null;
}