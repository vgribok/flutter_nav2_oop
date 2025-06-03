part of '../../../all.dart';

abstract class NestedRoutePath extends RoutePath {

  final Map<String, String> pathPairs;

  NestedRoutePath(this.pathPairs)
    : super(resource: _makeResource(pathPairs));

  static String _makeResource(Map<String, String> pathPairs) =>
      pathPairs.entries.map((kvp) => "${kvp.key}/${kvp.value}").join("/");

  @protected
  T? id<T>(String resourceName, T? Function(String) parser) {
    final String? val = pathPairs[resourceName];
    return val == null ? null : parser(val);
  }

  String? operator [](String resourceName) => pathPairs[resourceName];
}