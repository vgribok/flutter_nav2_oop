part of flutter_nav2_oop;

extension UriExtensions on Uri {

  /// Returns all path segments that are not ''
  List<String> get nonEmptyPathSegments =>
    pathSegments.where((pathSegment) => pathSegment.isNotEmpty).toList();

  /// Turns "/blogs/123/post/456" path into { "blogs": "123", "post": "456" }
  Map<String,String>? get nestedPathResources {
    final segments = nonEmptyPathSegments;
    final bool isOdd = (segments.length & 1) == 1;
    if(isOdd) return null;

    String? key;
    final map = <String,String>{};

    for(var segment in segments) {
      if(key == null) {
        key = segment;
      } else {
        map[key] = segment;
        key = null;
      }
    }

    return map;
  }

  Map<String,String>? segmentsFromUri(List<String> segmentNames) {
    final Map<String, String>? map = nestedPathResources;
    if(map == null) return null;

    if(segmentNames.length != map.length) return null;

    if(segmentNames.any((segment) => !map.containsKey(segment))) {
      return null;
    }

    return map;
  }

  /// Returns `true` if URI path has only one (non-empty) segment
  bool isSingleSegmentPath(String pathSegment) {
    final segments = nonEmptyPathSegments;
    return segments.length == 1 && segments[0] == pathSegment;
  }

  /// Checks whether URI's path segments match exactly
  /// passed [path] segments.
  ///
  /// For example, if [Uri] was 'http://host/orders/fulfilled',
  /// this method will return true if [path] argument is
  /// '/orders/fulfilled', with leading and trailing slashes
  /// ignored.
  bool pathsMatch(String path) {
    final segments = nonEmptyPathSegments;
    final List<String> segmentsToMatch = path.split('/')
        .where((pathSegment) => pathSegment.isNotEmpty).toList();

    if(segments.length != segmentsToMatch.length) {
      return false;
    }

    for(int i = 0 ; i < segments.length ; i++) {
      if(segments[i] != segmentsToMatch[i]) return false;
    }

    return true;
  }
}