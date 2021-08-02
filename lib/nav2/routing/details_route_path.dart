import 'package:flutter/cupertino.dart';
import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';
import 'package:flutter_nav2_oop/nav2/utility/uri_extensions.dart';

/// Method signature for Id parser function
typedef IdParser = RoutePath? Function(String);

/// A convenience class for two-segment details routes,
/// like '/orders/order-id', consisting of the
/// resource name and an object id.
///
/// This class is not suitable for multi-segment paths
/// '/users/123/orders/456'
abstract class DetailsRoutePath<T> extends RoutePath {

  /// Object Id
  final T id;

  const DetailsRoutePath({
    required int navTabIndex,
    required this.id,
    required String resource
  }) : super(
      tabIndex: navTabIndex,
      resource: resource
  );

  /// Returns URL path in the form of
  /// '/resourcename/object-id'
  @override
  String get location => '${super.location}$id';

  /// A convenience method simplifying parsing of two-part
  /// paths, like '/orders/123456'.
  ///
  /// Should be called by [RoutePath] subclasses'
  /// URL parser factories instantiating routes
  /// from user-typed URLs.
  @protected
  static RoutePath? fromUri(String resource, Uri uri, IdParser idParser) {
    final List<String> pathSegments = uri.nonEmptyPathSegments;

    // Test two-part path for matching route's pattern
    if(pathSegments.length == 2 && pathSegments[0] == resource) {
      // Call route-specific Id test-parser
      RoutePath? route = idParser(pathSegments[1]);
      if(route != null) return route;
    }
    return null;
  }
}
