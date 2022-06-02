part of flutter_nav2_oop;

class TabNavAwareApp extends _NavAwareAppBase<TabNavModel> {

  /// A singleton of [TabNavModel] accessible via [Provider]
  static late RestorableProvider<_TabNavStateRestorer> _privateNavModelProvider;

  TabNavAwareApp({
    /// Application navigation tab definitions
    required List<TabScreenSlot> tabs,
    /// Used for state restoration
    required super.applicationId,
    /// Application name
    required super.appTitle,
    /// Collection of factory methods test-converting
    /// user-typed (Web) URLs into [RoutePath] subclass instances
    required super.routeParsers,
    /// Initial route to be shown on application start
    required TabRoutePathAdapter initialPath,
    /// Application color theme
    super.theme,
    /// Navigation type. Auto if not specified.
    super.navType,
    /// Restorable state providers with global scope
    super.globalRestorableProviders,
    super.key
  })
      : super(initialPath: initialPath)
  {
    _privateNavModelProvider = RestorableProvider(
      (_) => _TabNavStateRestorer(TabNavModel(tabs, initialPath.tabIndex)),
      restorationId: "nav-state-restorer"
    );
  }

  @override
  @protected
  RestorableProvider get navModelProvider => _privateNavModelProvider;

  static TabNavModel navModelFactory(WidgetRef ref) =>
      ref.read(_privateNavModelProvider).value;

  static TabNavModel watchNavModelFactory(WidgetRef ref) =>
      ref.watch(_privateNavModelProvider).value;

  @override
  @protected
  TabNavModel navModel(WidgetRef ref) => navModelFactory(ref);

  @override
  @protected
  TabNavModel watchNavModel(WidgetRef ref) => watchNavModelFactory(ref);

  @override
  @protected
  TabNavAwareRouterDelegate createRouterDelegate(WidgetRef ref) =>
      TabNavAwareRouterDelegate(ref);
}