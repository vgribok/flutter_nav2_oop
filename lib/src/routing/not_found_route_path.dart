part of flutter_nav2_oop;

/// Route object representing invalid
/// user-typed browser web address URL
class NotFoundRoutePath extends RoutePath {

  /// Invalid URL typed int by the user
  /// into the web browser address bar
  final Uri notFoundUri;

  const NotFoundRoutePath({required this.notFoundUri, required super.tabIndex}) :
    super(resource: '404-page-not-found');

  @override
  void configureStateFromUri(WidgetRef ref) =>
    RoutePath.navState(ref).notFoundUri = notFoundUri;
}
