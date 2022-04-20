part of flutter_nav2_oop;

/// A signature of a programmer-replaceable method building
/// navigation Widget - either a bottom tab bar, or
/// a [Drawer]
typedef NavigationWidgetBarBuilder = Widget Function(
    NavScreen screen, BuildContext context, List<TabInfo>, int currentSelection, void Function(int index) tapHandler
);

/// A signature of a programmer-replaceable method building
/// navigation drawer header widget
typedef DrawerHeaderBuilder = Widget? Function (NavScreen, BuildContext context);

/// A signature of a programmer-replaceable method building
/// vertical rail navigation widget
typedef VerticalNavRailBuilder = Widget Function(Widget body, NavScreen screen,
    List<TabInfo> tabs, int currentSelection, ValueChanged<int> tapHandler);

/// A signature of a programmer-replaceable method building
/// application screens' [AppBar]
typedef AppBarBuilder = AppBar Function(NavScreen, BuildContext);

/// A base class for all application screens.
///
/// Screens inheriting this class will have an [AppBar],
/// and a [BottomNavigationBar] with tabs defined when
/// [NavAwareApp] class is constructed by application's
/// `main.dart`.
abstract class NavScreen extends StatelessWidget {

  /// Screen title
  @protected
  final String screenTitle;

  /// Index of navigation tab associated with this screen
  final int tabIndex;
  /// Application state holder

  // @protected
  // final NavAwareState navState;

  /// True if key is supplied to the constructor explicitly
  final bool _keySpecified;

  const NavScreen(
      {
        /// Screen title
        required this.screenTitle,
        /// Index of the navigation tab associated
        /// with the screen
        required this.tabIndex,
        // /// Reference to an existing [TabNavState] instance
        // required this.navState,
        /// Optional user-supplied key.
        /// If not supplied, route URI
        /// is used as the key
        LocalKey? key,
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

  NavAwareState getNavState(BuildContext context, {final bool listen = false})
      => Provider.of<NavAwareState>(context, listen: listen);

  /// Returns tab reference associated with this screen
  TabInfo tab(NavAwareState navState) => navState[tabIndex];

  /// Returns tab reference associated with this screen
  TabInfo getTab(BuildContext context) => tab(Provider.of<NavAwareState>(context, listen: false));

  /// Uses [Scaffold] to build navigation-aware screen UI
  @override
  Widget build(BuildContext context) =>
    Consumer<NavAwareState>(
        builder: (context, navState, child) =>
      Scaffold(
          appBar: buildAppBar(context),
          body: _buildBodyInternal(context, navState),
          bottomNavigationBar: _buildNavTabBarInternal(context, navState),
          drawer: _buildDrawerInternal(context, navState),
      )
    );

  /// Invoked by the framework when navigation item,
  /// like tab or drawer list item, is tapped
  @protected
  void onNavItemTap(BuildContext context, int newTabIndex, NavAwareState navState) {

    if(navState.effectiveNavType == NavType.Drawer) {
      // Hide the Drawer
      Navigator.pop(context);
    }

    bool tappedSameTabWithMultipleScreensInStack =
        newTabIndex == tabIndex && tab(navState).hasMultipleScreensInStack(navState, context);

    if(tappedSameTabWithMultipleScreensInStack) {
      // Remove top screen from the stack
      Navigator.pop(context);
    }else {
      navState._setSelectedTabIndex(newTabIndex, byUser: true);
    }
  }

  Widget _buildBodyInternal(BuildContext context, NavAwareState navState) {
    final Widget body = buildBody(context);

    return navState.effectiveNavType == NavType.VerticalRail ?
            buildVerticalRailAndBody(context, body, navState) : body;
  }

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
  NavScreen? topScreen(BuildContext context) => null;

  /// Non-root screens should override this method
  /// and call this one via super, to update the
  /// state so that the top child screen could be
  /// removed from the top of the nav stack
  @protected
  void updateStateOnScreenRemovalFromNavStackTop(NavAwareState navState, BuildContext context) =>
      navState.changeTabOnBackArrowTapIfNecessary(this, navState, context);

  // /// Convenience method surfacing [TabNavState] ability
  // /// to find state object by its type
  // @protected
  // T? stateByType<T extends ChangeNotifier>({
  //   /// Set to true to search all tab state
  //   /// object collections, as opposed to
  //   /// just screen's tab state object collection
  //   bool stateObjectIsInAnotherTab = false
  // }) =>
  //     navState.stateByType<T>(tabIndex: tabIndex, searchOtherTabs: stateObjectIsInAnotherTab);

  //#region App-wide screen customization factories

  /// A user-replaceable factory building
  /// bottom navigation bar.
  ///
  /// Default implementation is the static [buildDefaultBottomTabBar] method.
  static NavigationWidgetBarBuilder tabBarBuilder = buildDefaultBottomTabBar;

  /// A user-replaceable factory building
  /// navigation Drawer widget.
  ///
  /// Default implementation is the static [buildDefaultDrawer] method.
  static NavigationWidgetBarBuilder drawerBuilder = buildDefaultDrawer;

  /// A user-replaceable factory building
  /// navigation Drawer Header widget.
  ///
  /// Default implementation is the static [buildDefaultDrawerHeader] method.
  static DrawerHeaderBuilder drawerHeaderBuilder = buildDefaultDrawerHeader;

  /// A user-replaceable factory building
  /// Vertical Rail navigation widget.
  ///
  /// Default implementation is the static [buildDefaultVerticalNavRail] method.
  static VerticalNavRailBuilder verticalNavRailBuilder = buildDefaultVerticalNavRail;

  /// A user-replaceable factory building
  /// [AppBar] for each application screen.
  ///
  /// Default implementation is the static [buildDefaultAppBar] method.
  static AppBarBuilder appBarBuilder = buildDefaultAppBar;

  /// Default implementation of the [appBarBuilder] factory
  static AppBar buildDefaultAppBar(NavScreen screen, BuildContext context) =>
      AppBar(
          title: Text(screen.screenTitle),
          actions: screen.buildAppBarActions(context)
      );

  /// Default implementation of the [tabBarBuilder] factory
  static Widget buildDefaultBottomTabBar(NavScreen screen,
      BuildContext context, Iterable<TabInfo> tabs, int currentSelection, ValueChanged<int> tapHandler) =>
      BottomNavigationBar(
          items: tabs.map(
             (tabInfo) => BottomNavigationBarItem(icon: Icon(tabInfo.icon), label: tabInfo.title)
          ).toList(),
          currentIndex: currentSelection,
          onTap: tapHandler
      );

  /// Default implementation of the [drawerBuilder] factory
  static Widget buildDefaultDrawer(NavScreen screen,
      BuildContext context, List<TabInfo> tabs, int currentSelection, ValueChanged<int> tapHandler) {

    Widget? drawerHeader = screen.buildDrawerHeader(context);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          if(drawerHeader != null)
            drawerHeader
          ,
          ...[
            for(int i = 0; i < tabs.length; i++)
              ListTile(
                title: Text(tabs[i].title!),
                leading: Icon(tabs[i].icon),
                selected: i == currentSelection,
                onTap: () => tapHandler(i),
              )
          ]
        ],
      ),
    );
  }

  /// Default implementation of the [drawerHeaderBuilder] factory
  static Widget buildDefaultDrawerHeader(NavScreen screen, BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return DrawerHeader(
      decoration: BoxDecoration(
        color: theme.primaryColor
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top of the Drawer Header
        children: [
          Row(children: [ // Align icon and text at text baseline
            Icon(screen.getTab(context).icon, color: theme.colorScheme.secondary),
            const Text(' '),
            Text(screen.screenTitle,
              style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: theme.textTheme.headline6?.fontSize
              ),
            )
          ]
        )]
      )
    );
  }

  /// Default implementation of the [verticalNavRailBuilder] factory
  static Widget buildDefaultVerticalNavRail(Widget body, NavScreen screen,
    List<TabInfo> tabs, int currentSelection, ValueChanged<int> tapHandler) =>
      Row(children: [
        NavigationRail(
            selectedIndex: currentSelection,
            onDestinationSelected: (index) => tapHandler(index),
            labelType: NavigationRailLabelType.all,
            destinations: tabs.map((tab) =>NavigationRailDestination(
                icon: Icon(tab.icon),
                label: Text(tab.title ?? '')
            )).toList()
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: body)
      ]);

  //#endregion

  //#region Screen-specific customization methods
  /// Method to override in subclasses to build screen-specific
  /// app bar.
  ///
  /// Default implementation calls application-wide [appBarBuilder]
  /// factory method building same app bar for every screen.
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) =>
      appBarBuilder(this, context);

  Widget? _buildNavTabBarInternal(BuildContext context, NavAwareState navState) {
    if (navState.effectiveNavType != NavType.BottomTabBar) return null;
    return buildNavTabBar(context, navState);
  }

  /// Method to override in subclasses to build screen-specific
  /// bottom navigation bar. May return `null` to not render nav bar.
  ///
  /// Default implementation calls application-wide [tabBarBuilder]
  /// factory method building same bottom navigation bar for every
  /// screen.
  @protected
  Widget? buildNavTabBar(BuildContext context, NavAwareState navState) =>
      tabBarBuilder(this, context, navState.tabs, navState.selectedTabIndex,
              (newTabIndex) => onNavItemTap(context, newTabIndex, navState)
      );

  Widget? _buildDrawerInternal(BuildContext context, NavAwareState navState) {
    if (navState.effectiveNavType != NavType.Drawer) return null;
    return buildDrawer(context, navState);
  }

  /// Method to override in subclasses to build screen-specific
  /// navigation drawer. May return `null` to not render drawer.
  ///
  /// Default implementation calls application-wide [drawerBuilder]
  /// factory method building same drawer for every
  /// screen.
  @protected
  Widget? buildDrawer(BuildContext context, NavAwareState navState) =>
      drawerBuilder(this,
          context,
          navState.tabs,
          navState.selectedTabIndex,
          (newTabIndex) => onNavItemTap(context, newTabIndex, navState)
      );

  /// Method to override in subclasses to build screen-specific
  /// navigation drawer header. May return `null` to not render drawer header.
  ///
  /// Default implementation calls application-wide [drawerHeaderBuilder]
  /// factory method building same drawer header for every
  /// screen.
  Widget? buildDrawerHeader(BuildContext context) =>
      drawerHeaderBuilder(this, context);

  /// Provides ability to set screen-specific actions
  /// on the right side of the [AppBar].
  ///
  /// Default implementation returns null resulting
  /// in no action Widgets added
  @protected
  List<Widget>? buildAppBarActions(BuildContext context) => null;

  /// Method to override in subclasses to build screen-specific
  /// vertical rial navigation widget. May return `[body]` to
  /// not render widget.
  ///
  /// Default implementation calls application-wide [verticalNavRailBuilder]
  /// factory method building same vertical nav rail for every
  /// screen.
  @protected
  Widget buildVerticalRailAndBody(BuildContext context, Widget body, NavAwareState navState) =>
      verticalNavRailBuilder(body, this, navState.tabs, navState.selectedTabIndex,
              (newTabIndex) => onNavItemTap(context, newTabIndex, navState)
      );

  //#endregion
}