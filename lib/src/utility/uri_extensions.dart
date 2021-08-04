part of flutter_nav2_oop;

extension UriExtensions on Uri {
  List<String> get nonEmptyPathSegments =>
    this.pathSegments.where((pathSegment) => pathSegment.isNotEmpty).toList();

  bool isSingleSegmentPath(String pathSegment) {
    final segments = nonEmptyPathSegments;
    return segments.length == 1 && segments[0] == pathSegment;
  }
}