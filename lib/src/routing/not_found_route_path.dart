part of flutter_nav2_oop;

/// Route object representing invalid
/// user-typed browser web address URL
class NotFoundRoutePath extends RoutePath {

  static int notFoundTabIndex = 0;

  /// Invalid URL typed int by the user
  /// into the web browser address bar
  final Uri notFoundUri;

  const NotFoundRoutePath({BuildContext? context, required this.notFoundUri}) :
    super(context: context, tabIndex: 0, resource: '404-page-not-found');

  @override
  // ignore: must_call_super
  Future<void> configureStateFromUri() {
    Provider.of<NavAwareState>(context!, listen: false).notFoundUri = notFoundUri;
    return Future.value();
  }
}
