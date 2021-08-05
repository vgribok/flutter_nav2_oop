part of flutter_nav2_oop;

/// A signature of a programmer-replaceable method building
/// bottom navigation tab Widget.
///
typedef TabBarBuilder = Widget Function(BuildContext context, Iterable<TabInfo> tabs, int initialSelection, void Function(int index) tapHandler);

/// A signature of a programmer-replaceable method building
/// application screens' [AppBar]
typedef AppBarBuilder = AppBar Function(TabbedNavScreen, BuildContext, String);

/// A base class for all application screens.
///
/// Screens inheriting this class will have an [AppBar],
/// and a [BottomNavigationBar] with tabs defined when
/// [NavAwareAppState] class is constructed by application's
/// `main.dart`.
abstract class TabbedNavScreen extends StatelessWidget {

  /// Screen title
  @protected
  final String screenTitle;

  /// Index of navigation tab associated with this screen
  final int tabIndex;
  /// Application state holder

  @protected
  final TabNavState navState;

  /// A user-replaceable factory building
  /// bottom navigation bar.
  ///
  /// Default implementation is the static [buildDefaultBottomTabBar] method.
  static TabBarBuilder tabBarBuilder = buildDefaultBottomTabBar;

  /// A user-replaceable factory building
  /// [AppBar] for each application screen.
  ///
  /// Default implementation is the static [buildDefaultAppBar] method.
  static AppBarBuilder appBarBuilder = buildDefaultAppBar;

  /// True if key is supplied to the constructor explicitly
  final bool _keySpecified;

  const TabbedNavScreen(
      {
        required this.screenTitle,
        /// Index of the navigation tab associated
        /// with the screen
        required this.tabIndex,
        /// Reference to an existing [TabNavState] instance
        required this.navState,
        /// Optional user-supplied key.
        /// If not supplied, route URI
        /// is used as the key
        LocalKey? key
      }):
        _keySpecified = key != null,
        super(key: key);

  @override
  LocalKey get key => _keySpecified ? super.key! as LocalKey : ValueKey(routePath.location);

  /// Returns a Page instance used by the [Navigator] Widget
  Page get _page => MaterialPage(key: key, child: this);

  /// Overridden by subclasses, returns
  /// [RoutePath] instance corresponding to
  /// this screen
  @protected
  RoutePath get routePath;

  /// Uses [Scaffold] to build navigation-aware screen UI
  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: buildAppBar(context),
          body: buildBody(context),
          bottomNavigationBar: tabBarBuilder(context, navState._tabs, navState.selectedTabIndex,
              (newTabIndex) => navState._setSelectedTabIndex(newTabIndex, byUser: true)
          )
      );

  /// Method to override in subclasses to build screen-specific
  /// app bar.
  ///
  /// Default implementation calls application-wide [appBarBuilder]
  /// factory method building same app bar for every screen.
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) =>
      appBarBuilder(this, context, screenTitle);

  /// Override in subclasses to supply screen body
  @protected
  Widget buildBody(BuildContext context);

  /// Override to supply "child" screen based
  /// on the current state. Return null to keep
  /// this screen shown when its tab is selected.
  ///
  /// Be sure to make this method very fast as
  /// it's called frequently to test-build
  /// screen stack.
  @protected
  TabbedNavScreen? get topScreen => null;

  /// Non-root screens should override this method
  /// and call this one via super, to update the
  /// state so that the top child screen could be
  /// removed from the top of the nav stack
  @protected
  void updateStateOnScreenRemovalFromNavStackTop() =>
      navState.changeTabOnBackArrowTapIfNecessary(this);

  /// Default implementation of the [appBarBuilder] factory
  static AppBar buildDefaultAppBar(TabbedNavScreen screen, BuildContext context, String pageTitle) =>
      AppBar(title: Text(pageTitle));

  /// Default implementation of the [tabBarBuilder] factory
  static Widget buildDefaultBottomTabBar(
      BuildContext context, Iterable<TabInfo> tabs, int initialSelection, ValueChanged<int>? tapHandler) =>
      BottomNavigationBar(
          items:
          tabs.map((tabInfo) => BottomNavigationBarItem(icon: Icon(tabInfo.icon), label: tabInfo.title)).toList(),
          currentIndex: initialSelection,
          onTap: tapHandler
      );

  /// Convenience method surfacing [TabNavState] ability
  /// to find state object by its type
  @protected
  T? stateByType<T extends ChangeNotifier>({
    /// Set to true to search all tab state
    /// object collections, as opposed to
    /// just screen's tab state object collection
    bool stateObjectIsInAnotherTab = false
  }) =>
      navState.stateByType<T>(tabIndex: tabIndex, searchOtherTabs: stateObjectIsInAnotherTab);
}