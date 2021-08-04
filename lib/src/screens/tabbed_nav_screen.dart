part of flutter_nav2_oop;

/// A signature of a programmer-replaceable method building each tab's
/// [BottomNavigationBarItem] instance.
///
typedef TabItemBuilder = BottomNavigationBarItem Function(TabbedNavScreen, BuildContext, TabInfo);

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
  final String _screenTitle;
  /// Index of navigation tab associated with this screen
  final int tabIndex;
  /// Application state holder
  final TabNavState navState;

  /// A user-replaceable factory building
  /// [BottomNavigationBarItem] instance for each tab.
  ///
  /// Default implementation is the static [buildTabItem] method.
  static TabItemBuilder tabItemBuilder = buildTabItem;

  /// A user-replaceable factory building
  /// [AppBar] for each application screen.
  ///
  /// Default implementation is the static [buildAppBar] method.
  static AppBarBuilder appBarBuilder = buildAppBar;

  /// True if key is supplied to the constructor explicitly
  final bool _keySpecified;

  const TabbedNavScreen(
      {
        required String screenTitle,
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
        _screenTitle = screenTitle,
        _keySpecified = key != null,
        super(key: key);

  /// Overridable getter returning screen title
  String get screenTitle => _screenTitle;

  @override
  LocalKey get key => _keySpecified ? super.key! as LocalKey : ValueKey(routePath.location);

  /// Returns a Page instance used by the [Navigator] Widget
  Page get page => MaterialPage(key: key, child: this);

  /// Overridden by subclasses, returns
  /// [RoutePath] instance corresponding to
  /// this screen
  RoutePath get routePath;

  /// Uses [Scaffold] to build navigation-aware screen UI
  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: appBarBuilder(this, context, screenTitle),
          body: buildBody(context),
          bottomNavigationBar: BottomNavigationBar(
            items:
              navState.mapTabs((tabInfo) =>
                  tabItemBuilder(this, context, tabInfo)).toList(),
            currentIndex: navState.selectedTabIndex,
            onTap: (newTabIndex) => navState._setSelectedTabIndex(newTabIndex, byUser: true)
          )
      );

  /// Override in subclasses to supply screen body
  Widget buildBody(BuildContext context);

  /// Override to supply "child" screen based
  /// on the current state. Return null to keep
  /// this screen shown when its tab is selected.
  ///
  /// Be sure to make this method very fast as
  /// it's called frequently to test-build
  /// screen stack.
  TabbedNavScreen? get topScreen => null;

  /// Non-root screens should override this method
  /// and call this one via super, to update the
  /// state so that the top child screen could be
  /// removed from the top of the nav stack
  @protected
  void updateStateOnScreenRemovalFromNavStackTop() =>
      navState.changeTabOnBackArrowTapIfNecessary(this);

  /// Default implementation of the [tabItemBuilder] factory
  static BottomNavigationBarItem buildTabItem(TabbedNavScreen screen, BuildContext context, TabInfo tabInfo) =>
      BottomNavigationBarItem(icon: Icon(tabInfo.icon), label: tabInfo.title);

  /// Default implementation of the [appBarBuilder] factory
  static AppBar buildAppBar(TabbedNavScreen screen, BuildContext context, String pageTitle) =>
      AppBar(title: Text(pageTitle));

  /// Convenience method surfacing [TabNavState] ability
  /// to find state object by its type
  T? stateByType<T extends ChangeNotifier>({
    /// Set to true to search all tab state
    /// object collections, as opposed to
    /// just screen's tab state object collection
    bool stateObjectIsInAnotherTab = false
  }) =>
      navState.stateByType<T>(tabIndex: tabIndex, searchOtherTabs: stateObjectIsInAnotherTab);
}