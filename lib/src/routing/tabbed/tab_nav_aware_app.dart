part of '../../../all.dart';

class TabNavAwareApp extends _NavAwareAppBase<TabNavModel> {

  /// A singleton of [TabNavModel] accessible via [Provider]
  static late NotifierProvider<Notifier<_TabNavStateRestorer>, _TabNavStateRestorer> _privateNavModelProvider;

  /// A singleton of the [NavControlType] accessible via [RestorableProvider]
  static late NotifierProvider<Notifier<RestorableIntN>, RestorableIntN> _navControlTypeProvider;
  
  static NavControlType? getNavControlType(WidgetRef ref) {
    final value = ref.watch(_navControlTypeProvider).value;
    return value == null ? null : NavControlType.values[value];
  }
  
  static void setNavControlType(WidgetRef ref, NavControlType? type) {
    ref.read(_navControlTypeProvider).value = type?.index;
  }

  TabNavAwareApp({
    /// Application navigation tab definitions
    required List<TabScreenSlot> tabs,
    /// Used for state restoration
    required super.applicationId,
    /// Application name
    required super.appTitle,
    /// Initial route to be shown on application start
    required RoutePath initialPath,
    /// Application color theme
    super.theme,
    /// Application dark color theme
    super.darkTheme,
    /// Navigation type. Auto if not specified.
    NavControlType? navType,
    /// Restorable state providers with global scope
    super.globalRestorableProviders,
    super.appGlobalStateInitProvider,
    super.key
  })
  {
    _privateNavModelProvider = restorableProvider<_TabNavStateRestorer>(
      create: (_) => _TabNavStateRestorer(TabNavModel(tabs, initialPath)),
      restorationId: "nav-state-restorer"
    );

    _navControlTypeProvider = restorableProvider<RestorableIntN>(
        create: (_) => RestorableIntN(navType?.index),
        restorationId: "nav-control-type"
    );
  }

  @override
  @protected
  NotifierProvider get navModelProvider => _privateNavModelProvider;

  @override
  @protected
  @mustCallSuper
  List<NotifierProvider> get restorableProviders =>
    [
      _navControlTypeProvider,
      ...super.restorableProviders
    ];

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

  @override
  @protected
  NavAwareRouteInfoParser getRouteParser(WidgetRef ref) =>
      TabNavAwareRouteInfoParser(ref);
}