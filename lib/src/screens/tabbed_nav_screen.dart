part of flutter_nav2_oop;

/// A signature of a programmer-replaceable method building
/// navigation Widget - either a bottom tab bar, or
/// a [Drawer]
typedef NavigationWidgetBarBuilder = Widget Function(
    NavScreen, BuildContext, WidgetRef, void Function(int index) tapHandler
);

/// A signature of a programmer-replaceable method building
/// navigation drawer header widget
typedef OptionalWidgetBuilder = Widget? Function (NavScreen, BuildContext, WidgetRef);

/// A signature of a programmer-replaceable method building
/// vertical rail navigation widget
typedef VerticalNavRailBuilder = Widget Function(Widget body, NavScreen,
    WidgetRef, ValueChanged<int> tapHandler);

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
  final String screenTitle;

  /// Index of navigation tab associated with this screen
  final int tabIndex;

  @protected
  static TabNavModel navState(WidgetRef ref, {bool watch=false}) =>
      watch ? ref.watch(NavAwareApp.navModelProvider).value :
              ref.read(NavAwareApp.navModelProvider).value;

  const NavScreen(this.tabIndex,
      {
        /// Screen title
        required this.screenTitle,
        /// Optional user-supplied key.
        /// If not supplied, route URI
        /// is used as the key
        super.key,
      });

  /// Returns a Page instance used by the [Navigator] Widget
  Page get _page => MaterialPage(
      key: ValueKey(routePath.location),
      child: this,
      restorationId: routePath.location
  );

  /// Overridden by subclasses, returns
  /// [RoutePath] instance corresponding to
  /// this screen
  @protected
  RoutePath get routePath;

  /// Returns tab reference associated with this screen
  TabScreenSlot tab(WidgetRef ref) => navState(ref)[tabIndex];

  /// Uses [Scaffold] to build navigation-aware screen UI
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
    OrientationBuilder(builder: (context, orientation)
    {
      final NavControlType navControlType = effectiveNavType(context, ref,
          ref.watch(NavAwareApp.navControlTypeProvider).enumValue
      );

      var navBar = _buildNavTabBarInternal(context, navControlType, ref);
      var appBar = buildAppBar(context, ref);
      var body = _buildBodyInternal(context, navControlType, ref);
      var drawer = _buildDrawerInternal(context, navControlType, ref);
      var actionButton = buildFloatingActionButton(context, ref);

      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: navBar,
        drawer: drawer,
        floatingActionButton: actionButton,
      );
    });

  /// Returns concrete navigation mode.
  ///
  /// When non-null navigation mode is set via [navControlType],
  /// then that is the returned value. If [navControlType] is null,
  /// device orientation determines navigation mode: in portrait
  /// orientation bottom tab bar is used, and in landscape mode the
  /// vertical rail is used.
  static NavControlType effectiveNavType(BuildContext context, WidgetRef ref, NavControlType? navControlType) =>
      navControlType
          ?? ref.read(NavAwareApp.navControlTypeProvider).enumValue
          ?? (context.isPortrait ? NavControlType.BottomTabBar : NavControlType.VerticalRail);

  /// Invoked by the framework when navigation item,
  /// like tab or drawer list item, is tapped
  @protected
  void onTabTap(BuildContext context, WidgetRef ref, int newTabIndex) {
    if(effectiveNavType(context, ref, null) == NavControlType.Drawer) {
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

  Widget _buildBodyInternal(BuildContext context, NavControlType? navControlType, WidgetRef ref) {
    final Widget body = buildBody(context, ref);

    return navControlType == NavControlType.VerticalRail ?
            buildVerticalRailAndBody(context, ref, body) : body;
  }

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

  /// Non-root screens should override this method
  /// and call this one via super, to update the
  /// state so that the top child screen could be
  /// removed from the top of the nav stack
  @protected
  @mustCallSuper
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) =>
      navState(ref).changeTabOnBackArrowTapIfNecessary(this, ref);

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
  static OptionalWidgetBuilder drawerHeaderBuilder = buildDefaultDrawerHeader;

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
  static AppBar buildDefaultAppBar(NavScreen screen, BuildContext context, WidgetRef ref) =>
      AppBar(
          title: Text(screen.screenTitle),
          actions: screen.buildAppBarActions(context, ref)
      );

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
  static Widget buildDefaultDrawer(NavScreen screen,
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
  static Widget buildDefaultDrawerHeader(NavScreen screen, BuildContext context, WidgetRef ref) {

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

  //#region Screen-specific customization methods
  /// Method to override in subclasses to build screen-specific
  /// app bar.
  ///
  /// Default implementation calls application-wide [appBarBuilder]
  /// factory method building same app bar for every screen.
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) =>
      appBarBuilder(this, context, ref);

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

  /// Provides ability to set screen-specific actions
  /// on the right side of the [AppBar].
  ///
  /// Default implementation returns null resulting
  /// in no action Widgets added
  @protected
  List<Widget>? buildAppBarActions(BuildContext context, WidgetRef ref) => null;

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

  @protected
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) => null;
  //#endregion
}