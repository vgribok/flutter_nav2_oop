import 'package:flutter_nav2_oop/all.dart';

class CounterPath extends RoutePath {
  static const String resourceName = 'counter';

  /// Tab index for when the the route is typed by a user in the browser URL bar
  static const int defaultTaxIndex = 1;

  const CounterPath({required super.tabIndex}) :
    super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? const CounterPath(tabIndex: defaultTaxIndex) : null;
}