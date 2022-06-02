part of flutter_nav2_oop;

/// A signature of a programmer-replaceable method building
/// navigation Widget - either a bottom tab bar, or
/// a [Drawer]
typedef NavigationWidgetBarBuilder = Widget Function(
    TabNavScreen, BuildContext, WidgetRef, void Function(int index) tapHandler
);

/// A signature of a programmer-replaceable method building
/// vertical rail navigation widget
typedef VerticalNavRailBuilder = Widget Function(Widget body, TabNavScreen,
    WidgetRef, ValueChanged<int> tapHandler);

typedef NavDrawerHeaderBuilder = Widget? Function (TabNavScreen, BuildContext, WidgetRef);

/// A base class for all application screens.
///
/// Screens inheriting this class will have an [AppBar],
/// and a [BottomNavigationBar] with tabs defined when
/// [NavAwareApp] class is constructed by application's
/// `main.dart`.
abstract class TabNavScreen extends NavScreen {

  /// Index of navigation tab associated with this screen
  final int tabIndex;

  @protected
  static TabNavModel navState(WidgetRef ref, {bool watch=false}) =>
      watch ? TabNavAwareApp.watchNavModelFactory(ref) :
              TabNavAwareApp.navModelFactory(ref);

  const TabNavScreen(this.tabIndex,
      {
        /// Screen title
        required super.screenTitle,
        /// Optional user-supplied key.
        /// If not supplied, route URI
        /// is used as the key
        super.key,
      });

  TabRoutePathAdapter get tabRoutePath => routePath.tabbed(tabIndex: tabIndex);

  /// Returns tab reference associated with this screen
  TabScreenSlot tab(WidgetRef ref) => navState(ref)[tabIndex];

  @protected
  @override
  Scaffold buildScaffold(BuildContext context, WidgetRef ref, NavControlType navControlType,
  {
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? actionButton
  }) {

    var biggerBody = _buildBodyInternal(context, navControlType, ref, body);
    var navBar = _buildNavTabBarInternal(context, navControlType, ref);
    var drawer = _buildDrawerInternal(context, navControlType, ref);

    return Scaffold(
      appBar: appBar,
      body: biggerBody,
      bottomNavigationBar: navBar,
      drawer: drawer,
      floatingActionButton: actionButton,
    );
  }

  Widget _buildBodyInternal(
      BuildContext context, NavControlType? navControlType, WidgetRef ref, Widget body
  ) =>
      navControlType == NavControlType.VerticalRail ?
              buildVerticalRailAndBody(context, ref, body) : body;

  @override
  @protected
  @mustCallSuper
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
    navState(ref).changeTabOnBackArrowTapIfNecessary(this, ref);
  }

  /// Invoked by the framework when navigation item,
  /// like tab or drawer list item, is tapped
  @protected
  void onTabTap(BuildContext context, WidgetRef ref, int newTabIndex) {
    if(NavScreen.effectiveNavType(context, ref, null) == NavControlType.Drawer) {
      // Hide the Drawer
      Navigator.pop(context);
    }

    bool tappedSameTabWithMultipleScreensInStack =
        newTabIndex == tabIndex && tab(ref).hasMultipleScreensInStack(ref);

    if(tappedSameTabWithMultipleScreensInStack) {
      // Remove top screen from the stack
      Navigator.pop(context);
    }else {
      navState(ref)._setSelectedTabIndex(newTabIndex, byUser: true);
    }
  }

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
  static NavDrawerHeaderBuilder drawerHeaderBuilder = buildDefaultDrawerHeader;

  /// A user-replaceable factory building
  /// Vertical Rail navigation widget.
  ///
  /// Default implementation is the static [buildDefaultVerticalNavRail] method.
  static VerticalNavRailBuilder verticalNavRailBuilder = buildDefaultVerticalNavRail;

  /// Default implementation of the [tabBarBuilder] factory
  static Widget buildDefaultBottomTabBar(NavScreen screen,
      BuildContext context, WidgetRef ref, ValueChanged<int> tapHandler) {
    final TabNavModel navModel = navState(ref, watch: true);

    return BottomNavigationBar(
      items: navModel._tabs.map(
              (tabInfo) =>
              BottomNavigationBarItem(
                  icon: Icon(tabInfo.icon), label: tabInfo.title)
      ).toList(),
      currentIndex: navModel.selectedTabIndex,
      onTap: tapHandler,
      type: BottomNavigationBarType.fixed,
    );
  }

  /// Default implementation of the [drawerBuilder] factory
  static Widget buildDefaultDrawer(TabNavScreen screen,
      BuildContext context, WidgetRef ref, ValueChanged<int> tapHandler) {

    final TabNavModel navModel = navState(ref, watch: true);
    final Widget? drawerHeader = screen.buildDrawerHeader(context, ref);

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
            for(int i = 0; i < navModel._tabs.length; i++)
              ListTile(
                title: Text(navModel._tabs[i].title!),
                leading: Icon(navModel._tabs[i].icon),
                selected: i == navModel.selectedTabIndex,
                onTap: () => tapHandler(i),
              )
          ]
        ],
      ),
    );
  }

  /// Default implementation of the [drawerHeaderBuilder] factory
  static Widget buildDefaultDrawerHeader(TabNavScreen screen, BuildContext context, WidgetRef ref) {

    final ThemeData theme = Theme.of(context);

    return DrawerHeader(
      decoration: BoxDecoration(
        color: theme.primaryColor
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top of the Drawer Header
        children: [
          Row(children: [ // Align icon and text at text baseline
            Icon(screen.tab(ref).icon, color: theme.colorScheme.secondary),
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
    WidgetRef ref, ValueChanged<int> tapHandler) {

    final TabNavModel navModel = navState(ref, watch: true);

    return Row(children: [
      NavigationRail(
          selectedIndex: navModel.selectedTabIndex,
          onDestinationSelected: (index) => tapHandler(index),
          labelType: NavigationRailLabelType.all,
          destinations: navModel._tabs.map((tab) =>
              NavigationRailDestination(
                  icon: Icon(tab.icon),
                  label: Text(tab.title ?? '')
              )).toList()
      ),
      const VerticalDivider(thickness: 1, width: 1),
      Expanded(child: body)
    ]);
  }

  //#endregion

  Widget? _buildNavTabBarInternal(BuildContext context, NavControlType navControlType, WidgetRef ref) {
    if (navControlType != NavControlType.BottomTabBar) return null;
    return buildNavTabBar(context, ref);
  }

  /// Method to override in subclasses to build screen-specific
  /// bottom navigation bar. May return `null` to not render nav bar.
  ///
  /// Default implementation calls application-wide [tabBarBuilder]
  /// factory method building same bottom navigation bar for every
  /// screen.
  @protected
  Widget? buildNavTabBar(BuildContext context, WidgetRef ref) =>
      tabBarBuilder(this, context, ref,
              (newTabIndex) => onTabTap(context, ref, newTabIndex)
      );

  Widget? _buildDrawerInternal(BuildContext context, NavControlType navControlType, WidgetRef ref) {
    if (navControlType != NavControlType.Drawer) return null;
    return buildDrawer(context, ref);
  }

  /// Method to override in subclasses to build screen-specific
  /// navigation drawer. May return `null` to not render drawer.
  ///
  /// Default implementation calls application-wide [drawerBuilder]
  /// factory method building same drawer for every
  /// screen.
  @protected
  Widget? buildDrawer(BuildContext context, WidgetRef ref) =>
      drawerBuilder(this,
          context,
          ref,
          (newTabIndex) => onTabTap(context, ref, newTabIndex)
      );

  /// Method to override in subclasses to build screen-specific
  /// navigation drawer header. May return `null` to not render drawer header.
  ///
  /// Default implementation calls application-wide [drawerHeaderBuilder]
  /// factory method building same drawer header for every
  /// screen.
  Widget? buildDrawerHeader(BuildContext context, WidgetRef ref) =>
      drawerHeaderBuilder(this, context, ref);

  /// Method to override in subclasses to build screen-specific
  /// vertical rial navigation widget. May return `[body]` to
  /// not render widget.
  ///
  /// Default implementation calls application-wide [verticalNavRailBuilder]
  /// factory method building same vertical nav rail for every
  /// screen.
  @protected
  Widget buildVerticalRailAndBody(BuildContext context, WidgetRef ref, Widget body) =>
      verticalNavRailBuilder(body, this, ref,
              (newTabIndex) => onTabTap(context, ref, newTabIndex)
      );

  //#endregion
}