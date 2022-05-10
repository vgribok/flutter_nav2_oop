import 'package:example/src/screens/counter.dart';
import 'package:flutter_nav2_oop/all.dart';

class CounterPath extends RoutePath {
  static const String resourceName = 'counter';

  const CounterPath() :
    super(tabIndex: CounterScreen.navTabIndex, resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? const CounterPath() : null;
}