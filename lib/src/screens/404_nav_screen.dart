part of flutter_nav2_oop;

/// Factory method signature for instantiating a screen for 404 situations
typedef NotFoundScreenFactory = UrlNotFoundScreen Function(Uri);

/// A screen shown when user-typed URL in the browser address bar
/// is invalid
class UrlNotFoundScreen extends NavScreen {

  /// User-replaceable factory instantiating the
  /// [UrlNotFoundScreen]
  static NotFoundScreenFactory notFoundScreenFactory =
      (notFoundUrl) => UrlNotFoundScreen(notFoundUrl);

  /// User-replaceable message to be shown on the screen
  static String defaultMessage = 'Following URI is incorrect: ';
  /// User-replaceable screen title
  static String defaultTitle = 'Resource not found';
  static String defaultCloseButtonText = 'Return';

  /// Invalid URL typed in the web browser
  /// address bar by the user
  final Uri notFoundUri;

  _NavModelBase navState(WidgetRef ref) => _NavAwareAppBase.navModelFactory(ref);

  /// Do not instantiate directly! Use [notFoundScreenFactory]
  /// instead.
  UrlNotFoundScreen(this.notFoundUri, {super.key}) :
    super(screenTitle: defaultTitle);

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(defaultMessage),
          Text(
              '"${navState(ref)._notFoundUri}"',
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
      navState(ref).notFoundUri = null;

  @override @protected
  RoutePath get routePath => NotFoundRoutePath(notFoundUri: notFoundUri);
}