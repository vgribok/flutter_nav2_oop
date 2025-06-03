part of '../../all.dart';

/// Prints only in debug mode and not in release mode. Prevents leaking of
/// sensitive information.
String? safePrint(Object? arg) {
  final String? output = arg?.toString();
  if (kDebugMode && arg != null) {
    debugPrint(output);
  }
  return output;
}

extension ObjectEx on Object {
  String? debugPrint() => safePrint(this);
}