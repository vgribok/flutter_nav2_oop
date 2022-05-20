import 'package:flutter_nav2_oop/all.dart';

class CounterPath extends RoutePath {
  static const String resourceName = 'counter';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTabIndex = 1;

  CounterPath({required super.tabIndex}) :
    super(resource: resourceName)
  {
    assert(tabIndex == defaultTabIndex);
  }

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? CounterPath(tabIndex: defaultTabIndex) : null;
}