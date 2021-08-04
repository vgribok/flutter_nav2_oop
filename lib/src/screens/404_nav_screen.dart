part of flutter_nav2_oop;

/// Factory method signature for instantiating a screen for 404 situations
typedef NotFoundScreenFactory = UrlNotFoundScreen Function(TabNavState navState);

/// A screen shown when user-typed URL in the browser address bar
/// is invalid
class UrlNotFoundScreen extends TabbedNavScreen {

  /// User-replaceable factory instantiating the
  /// [UrlNotFoundScreen]
  static NotFoundScreenFactory notFoundScreenFactory =
      (navState) => UrlNotFoundScreen(navState: navState);

  /// User-replaceable message to be shown on the screen
  static String defaultMessage = 'Following URI is incorrect: ';
  /// User-replaceable screen title
  static String defaultTitle = 'Resource not found';

  /// Invalid URL typed in the web browser
  /// address bar by the user
  final Uri notFoundUri;

  /// Do not instantiate directly! Use [notFoundScreenFactory]
  /// instead.
  UrlNotFoundScreen({required TabNavState navState}) :
    notFoundUri = navState.notFoundUri!,
    super(
      screenTitle: defaultTitle,
      tabIndex: navState.selectedTabIndex,
      navState: navState
    );

  @override
  Widget buildBody(BuildContext context) =>
    Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(defaultMessage),
          Text(
              '\"${navState.notFoundUri}\"',
              style: TextStyle(fontWeight: FontWeight.bold)
          )
        ])
    );

  @override
  void updateStateOnScreenRemovalFromNavStackTop() =>
      navState.notFoundUri = null;

  @override
  RoutePath get routePath => NotFoundRoutePath(notFoundUri: notFoundUri);
}