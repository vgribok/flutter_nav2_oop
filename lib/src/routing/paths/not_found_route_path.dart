part of '../../../all.dart';

/// Route object representing invalid
/// user-typed browser web address URL
class NotFoundRoutePath extends RoutePath {

  /// Invalid URL typed int by the user
  /// into the web browser address bar
  final Uri notFoundUri;

  const NotFoundRoutePath({required this.notFoundUri}) :
    super(resource: '404-page-not-found');

  @override
  bool configureStateFromUri(WidgetRef ref) {
    navModel(ref).notFoundUri = notFoundUri;
    return true;
  }
}
