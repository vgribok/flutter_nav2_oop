part of flutter_nav2_oop;

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
    required this.id,
    required super.resource
  });

  /// Returns URL path in the form of
  /// '/resourcename/object-id'
  @override
  String get location => '${super.location}$id';

  /// A convenience method simplifying parsing of two-part
  /// paths, like '/orders/123456' or '/user/orders/123'.
  ///
  /// Should be called by [RoutePath] subclasses'
  /// URL parser factories instantiating routes
  /// from user-typed URLs.
  @protected
  static RoutePath? fromUri(String resource, Uri uri, IdParser idParser) {
    final List<String> pathSegments = uri.nonEmptyPathSegments;

    // Test two-part path for matching route's pattern
    if(pathSegments.length > 1 && pathSegments.allButLast().join('/') == resource) {
      // Call route-specific Id test-parser
      RoutePath? route = idParser(pathSegments.last);
      if(route != null) return route;
    }
    return null;
  }
}
