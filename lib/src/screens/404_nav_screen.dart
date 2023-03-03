part of flutter_nav2_oop;

/// Factory method signature for instantiating a screen for 404 situations
typedef NotFoundScreenFactory = UrlNotFoundScreen Function(Uri);

/// A screen shown when user-typed URL in the browser address bar
/// is invalid
class UrlNotFoundScreen extends NavScreen {

  /// User-replaceable factory instantiating the
  /// [UrlNotFoundScreen]
  static NotFoundScreenFactory notFoundScreenFactory =
      (notFoundUrl) => UrlNotFoundScreen(notFoundUrl, key: const ValueKey("default 404 screen"));

  /// User-replaceable message to be shown on the screen
  static String defaultMessage = 'Following URI is incorrect: ';
  /// User-replaceable screen title
  static String defaultTitle = 'Resource not found';
  static String defaultCloseButtonText = 'Return';

  /// Invalid URL typed in the web browser
  /// address bar by the user
  final Uri notFoundUri;

  NavModelBase navModel(WidgetRef ref) => _NavAwareAppBase.navModelFactory(ref);

  /// Do not instantiate directly! Use [notFoundScreenFactory]
  /// instead.
  UrlNotFoundScreen(this.notFoundUri, {super.key}) :
    super(screenTitle: defaultTitle);

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    CenteredColumn(
        children: [
          Text(defaultMessage, key: const ValueKey("404 message text")),
          Text(
              '"${navModel(ref)._notFoundUri}"',
              style: const TextStyle(fontWeight: FontWeight.bold),
              key: const ValueKey("404 url")
          ),
          const Divider(thickness: 1, indent: 50, endIndent: 50),
          ElevatedButton(
              onPressed: () => updateStateOnScreenRemovalFromNavStackTop(ref),
              key: const ValueKey("404 screen close button"),
              child: Text(defaultCloseButtonText, key: const ValueKey("404 screen close button text"))
          )
        ]
    );

  @override
  List<Widget>? buildAppBarActions(BuildContext context, WidgetRef ref) =>
      [
        IconButton(
            icon: const Icon(Icons.cancel, key: ValueKey("app bar cancel icon")),
            tooltip: defaultCloseButtonText,
            onPressed: () => updateStateOnScreenRemovalFromNavStackTop(ref),
            key: const ValueKey("app bar cancel button")
        )
      ];

  @override @protected
  // ignore: must_call_super
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) =>
      navModel(ref).notFoundUri = null;

  @override @protected
  RoutePath get routePath => NotFoundRoutePath(notFoundUri: notFoundUri);
}