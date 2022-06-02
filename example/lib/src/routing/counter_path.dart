import 'package:flutter_nav2_oop/all.dart';

class CounterPath extends RoutePath {
  static const String resourceName = 'counter';

  CounterPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? CounterPath() : null;
}