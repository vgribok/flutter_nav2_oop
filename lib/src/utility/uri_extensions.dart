part of flutter_nav2_oop;

extension UriExtensions on Uri {

  /// Returns all path segments that are not ''
  List<String> get nonEmptyPathSegments =>
    this.pathSegments.where((pathSegment) => pathSegment.isNotEmpty).toList();

  /// Returns `true` if URI path has only one (non-empty) segment
  bool isSingleSegmentPath(String pathSegment) {
    final segments = nonEmptyPathSegments;
    return segments.length == 1 && segments[0] == pathSegment;
  }
}