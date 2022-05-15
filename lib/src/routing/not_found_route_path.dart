part of flutter_nav2_oop;

/// Route object representing invalid
/// user-typed browser web address URL
class NotFoundRoutePath extends RoutePath {

  /// Invalid URL typed int by the user
  /// into the web browser address bar
  final Uri notFoundUri;

  const NotFoundRoutePath({required this.notFoundUri}) :
    super(tabIndex: 0, resource: '404-page-not-found');

  @override
  // ignore: must_call_super
  Future<void> configureStateFromUri(WidgetRef ref) {
    ref.read(NavAwareApp.navModelProvider).notFoundUri = notFoundUri;
    return Future.value();
  }
}
