part of flutter_nav2_oop;

/// Factory method signature for instantiating a screen for 404 situations
typedef NotFoundScreenFactory = UrlNotFoundScreen Function(NavAwareState navState, List<ChangeNotifierProvider> providers);

/// A screen shown when user-typed URL in the browser address bar
/// is invalid
class UrlNotFoundScreen extends NavScreen {

  /// User-replaceable factory instantiating the
  /// [UrlNotFoundScreen]
  static NotFoundScreenFactory notFoundScreenFactory =
      (navState, stateProviders) => UrlNotFoundScreen(navState: navState, providers: stateProviders);

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
  UrlNotFoundScreen({required NavAwareState navState, required List<ChangeNotifierProvider> providers}) :
    _notFoundUri = navState.notFoundUri!,
    super(key: const ValueKey("f2n_404Screen"),
      screenTitle: defaultTitle,
      tabIndex: navState.selectedTabIndex,
      providers: providers
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
              '"$_notFoundUri"',
              style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          const Divider(thickness: 1, indent: 50, endIndent: 50),
          ElevatedButton(
              child: Text(defaultCloseButtonText),
              onPressed: () => updateStateOnScreenRemovalFromNavStackTop(
                                  Provider.of<NavAwareState>(context, listen: false),
                                  context
                              )
          )
        ])
    );

  @override
  List<Widget>? buildAppBarActions(BuildContext context) =>
      [
        IconButton(
            icon: const Icon(Icons.cancel),
            tooltip: defaultCloseButtonText,
            onPressed: () =>
                updateStateOnScreenRemovalFromNavStackTop(
                    Provider.of<NavAwareState>(context, listen: false), context
                )
        )
      ];

  @override @protected
  void updateStateOnScreenRemovalFromNavStackTop(NavAwareState navState, BuildContext context) =>
      navState.notFoundUri = null;

  @override @protected
  RoutePath get routePath => NotFoundRoutePath(notFoundUri: _notFoundUri);
}