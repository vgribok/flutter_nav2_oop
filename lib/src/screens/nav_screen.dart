part of flutter_nav2_oop;

/// A signature of a programmer-replaceable method building
/// navigation drawer header widget
typedef OptionalWidgetBuilder = Widget? Function (NavScreen, BuildContext, WidgetRef);

/// A signature of a programmer-replaceable method building
/// application screens' [AppBar]
typedef AppBarBuilder = AppBar Function(NavScreen, BuildContext, WidgetRef);

/// A base class for all application screens.
///
/// Screens inheriting this class will have an [AppBar],
/// and a [BottomNavigationBar] with tabs defined when
/// [NavAwareApp] class is constructed by application's
/// `main.dart`.
abstract class NavScreen extends ConsumerWidget {

  /// Screen title
  @protected
  final String _screenTitle;

  const NavScreen(
      {
        /// Screen title
        required String screenTitle,
        /// Optional user-supplied key.
        /// If not supplied, route URI
        /// is used as the key
        super.key,
      }) :
        _screenTitle = screenTitle;

  /// Returns a Page instance used by the [Navigator] Widget
  Page get _page => MaterialPage(
      key: ValueKey(routePath.location),
      child: this,
      restorationId: routePath.location
  );

  Route getRoute(BuildContext context) => _page.createRoute(context);

  bool isCurrentScreen(BuildContext context) =>
      this == context.currentScreen;

  /// Overridden by subclasses, returns
  /// [RoutePath] instance corresponding to
  /// this screen
  @protected
  RoutePath get routePath;

  /// Uses [Scaffold] to build navigation-aware screen UI
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
    OrientationBuilder(builder: (context, orientation)
    {
      PreferredSizeWidget? appBar = buildAppBar(context, ref);
      Widget body = buildBody(context, ref);

      return buildScaffold(context, ref,
          appBar: appBar, body: body
      );
    });

  @protected
  Scaffold buildScaffold(BuildContext context, WidgetRef ref,
  {
    PreferredSizeWidget? appBar,
    required Widget body,
  }) =>
      Scaffold(
        appBar: appBar,
        body: body,
        key: const ValueKey("screen scaffold")
      );

  /// Override in subclasses to supply screen body
  @protected
  Widget buildBody(BuildContext context, WidgetRef ref);

  /// Override to supply "child" screen based
  /// on the current state. Return null to keep
  /// this screen shown when its tab is selected.
  /// This method is called from a build() method
  /// of another class, so using ref.watch(provider)
  /// to trigger navigation to the overlaid screen is
  /// both appropriate and the best practice.
  ///
  /// Be sure to make this method very fast as
  /// it's called frequently to test-build
  /// screen stack.
  @protected
  NavScreen? topScreen(WidgetRef ref) => null;

  @protected
  bool get isModal => false;

  /// Non-root screens should override this method
  /// and call this one via super, to update the
  /// state so that the top child screen could be
  /// removed from the top of the nav stack
  @protected
  @mustCallSuper
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {}

  @protected
  String getScreenTitle(WidgetRef ref) => _screenTitle;

  //#region App-wide screen customization factories

  /// A user-replaceable factory building
  /// [AppBar] for each application screen.
  ///
  /// Default implementation is the static [buildDefaultAppBar] method.
  static AppBarBuilder appBarBuilder = buildDefaultAppBar;

  /// Default implementation of the [appBarBuilder] factory
  static AppBar buildDefaultAppBar(NavScreen screen, BuildContext context, WidgetRef ref) =>
      AppBar(
          title: Text(screen.getScreenTitle(ref), textAlign: TextAlign.center, key: const ValueKey("app bar title")),
          actions: screen.buildAppBarActions(context, ref)
      );

  //#endregion

  //#region Screen-specific customization methods
  /// Method to override in subclasses to build screen-specific
  /// app bar.
  ///
  /// Default implementation calls application-wide [appBarBuilder]
  /// factory method building same app bar for every screen.
  @protected
  AppBar? buildAppBar(BuildContext context, WidgetRef ref) =>
      appBarBuilder(this, context, ref);

  /// Provides ability to set screen-specific actions
  /// on the right side of the [AppBar].
  ///
  /// Default implementation returns null resulting
  /// in no action Widgets added
  @protected
  List<Widget>? buildAppBarActions(BuildContext context, WidgetRef ref) => null;
  //#endregion
}