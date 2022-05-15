part of flutter_nav2_oop;

/// Factory method signature for instantiating a screen for 404 situations
typedef NotFoundScreenFactory = UrlNotFoundScreen Function(TabNavModel navState);

/// A screen shown when user-typed URL in the browser address bar
/// is invalid
class UrlNotFoundScreen extends NavScreen {

  /// User-replaceable factory instantiating the
  /// [UrlNotFoundScreen]
  static NotFoundScreenFactory notFoundScreenFactory =
      (navState) => UrlNotFoundScreen(navState: navState);

  /// User-replaceable message to be shown on the screen
  static String defaultMessage = 'Following URI is incorrect: ';
  /// User-replaceable screen title
  static String defaultTitle = 'Resource not found';
  static String defaultCloseButtonText = 'Return';

  /// Invalid URL typed in the web browser
  /// address bar by the user
  final Uri _notFoundUri;

  /// Do not instantiate directly! Use [notFoundScreenFactory]
  /// instead.
  UrlNotFoundScreen({required TabNavModel navState, super.key}) :
    _notFoundUri = navState.notFoundUri!,
    super(
      screenTitle: defaultTitle,
      tabIndex: navState.selectedTabIndex,
      navState: navState
    );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(defaultMessage),
          Text(
              '"$_notFoundUri"',
              style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          const Divider(thickness: 1, indent: 50, endIndent: 50),
          ElevatedButton(
              child: Text(defaultCloseButtonText),
              onPressed: () => updateStateOnScreenRemovalFromNavStackTop(ref)
          )
        ])
    );

  @override
  List<Widget>? buildAppBarActions(BuildContext context, WidgetRef ref) =>
      [
        IconButton(
            icon: const Icon(Icons.cancel),
            tooltip: defaultCloseButtonText,
            onPressed: () => updateStateOnScreenRemovalFromNavStackTop(ref)
        )
      ];

  @override @protected
  // ignore: must_call_super
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) =>
      navState.notFoundUri = null;

  @override @protected
  RoutePath get routePath => NotFoundRoutePath(notFoundUri: _notFoundUri);
}