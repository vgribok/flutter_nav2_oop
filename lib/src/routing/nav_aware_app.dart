part of '../../all.dart';

class NavAwareApp extends _NavAwareAppBase<NavModel> {
  /// A singleton of [TabNavModel] accessible via [Provider]
  static late RestorableProvider<_NavStateRestorer> _privateNavModelProvider;

  NavAwareApp({
    /// Used for state restoration
    required super.applicationId,
    /// Application name
    required super.appTitle,
    /// Collection of factory methods test-converting
    /// user-typed (Web) URLs into [RoutePath] subclass instances
    required List<RoutePathFactory> routeParsers,
    /// Initial route to be shown on application start
    required RoutePath initialPath,
    /// Application color theme
    super.theme,
    /// Application dark color theme
    super.darkTheme,
    /// Restorable state providers with global scope
    super.globalRestorableProviders,
    required RootScreenFactory rootScreenFactory,
    super.appGlobalStateInitProvider,
    super.key
  }) {
    _privateNavModelProvider = RestorableProvider(
        (_) => _NavStateRestorer(NavModel(rootScreenFactory, routeParsers, initialPath)),
        restorationId: "nav-state-restorer"
      );
  }

  @override
  @protected
  RestorableProvider get navModelProvider => _privateNavModelProvider;

  static NavModel navModelFactory(WidgetRef ref) =>
      ref.read(_privateNavModelProvider).value;

  static NavModel watchNavModelFactory(WidgetRef ref) =>
      ref.watch(_privateNavModelProvider).value;

  @override
  @protected
  NavModel navModel(WidgetRef ref) => navModelFactory(ref);

  @override
  @protected
  NavModel watchNavModel(WidgetRef ref) => watchNavModelFactory(ref);

  @override
  @protected
  NavAwareRouterDelegate createRouterDelegate(WidgetRef ref) =>
      NavAwareRouterDelegate(ref);
}

abstract class _NavAwareAppBase<T extends NavModelBase> extends ConsumerWidget {

  /// Application name
  final String _appTitle;
  final String applicationId;
  final ThemeData? _theme;
  final ThemeData? _darkTheme;

  final List<RestorableProvider<RestorableProperty?>>? globalRestorableProviders;
  static late FutureProvider<bool> appInitProvider;

  static late NavModelBase Function(WidgetRef) navModelFactory;

  @protected
  RestorableProvider get navModelProvider;

  @protected
  Iterable<Locale>? get supportedLocales => null;

  @protected
  Locale? get currentLocale => null;

  @protected
  Iterable<LocalizationsDelegate<dynamic>>? get localizationDelegates => null;

  @protected
  T navModel(WidgetRef ref);

  @protected
  T watchNavModel(WidgetRef ref);

  _NavAwareAppBase({
    /// Used for state restoration
    required this.applicationId,
    /// Application name
    required String appTitle,
    /// Application color theme
    ThemeData? theme,
    /// Application dark color theme
    ThemeData? darkTheme,
    /// Restorable state providers with global scope
    this.globalRestorableProviders,
    /// FutureProvider combining all global application state
    /// async initializers
    FutureProvider<void>? appGlobalStateInitProvider,
    super.key
  }) :
    _appTitle = appTitle,
    _theme = theme,
    _darkTheme = darkTheme
  {
    appInitProvider = FutureProvider<bool>((Ref ref) async {
      if(appGlobalStateInitProvider != null) await ref.watch(appGlobalStateInitProvider.future);
      return true;
    });
    navModelFactory = (ref) => navModel(ref);
  }

  /// Returns [MaterialApp] instance returned by
  /// the [MaterialApp.router] method
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      MaterialApp.router(
        title: appTitle,
        theme: _theme,
        darkTheme: _darkTheme,
        routerDelegate: createRouterDelegate(ref),
        routeInformationParser: getRouteParser(ref),
        restorationScopeId: "app-router-restoration-scope",
        debugShowCheckedModeBanner: false, // Hide 'Debug' ribbon on the AppBar,
        supportedLocales: supportedLocales ?? const <Locale>[Locale('en', 'US')],
        locale: currentLocale,
        localizationsDelegates: localizationDelegates,

        // An observation critical to successfully implementing restorable state
        // with the [MaterialApp.router] is that the builder can be used to
        // supply restoration scope (restorationId). The key bit here is that
        // you don't have to supply your own child to the builder - the child
        // comes from the [MaterialApp], but that is not obvious unless one
        // analyzed the framework source code. The real child supplier is still the
        // RouterDelegate's Build() method. You're welcome :-).
        builder: (context, router) =>
            RestorableProviderRegister(
                restorationId: 'application-ephemeral-state',
                providers: restorableProviders,
                child: router!
            )
    );

  @protected
  @mustCallSuper
  List<RestorableProvider<RestorableProperty?>> get restorableProviders =>
    [
      navModelProvider,
      ... globalRestorableProviders ?? []
    ];

  /// Returns the name of the application
  String get appTitle => _appTitle;

  /// Returns [ProviderScope] - a required wrapper for an app
  /// using Riverpod state management.
  ProviderScope get riverpodApp => ProviderScope(child: this);

  @protected
  _NavAwareRouterDelegateBase createRouterDelegate(WidgetRef ref);

  @protected
  NavAwareRouteInfoParser getRouteParser(WidgetRef ref) =>
      NavAwareRouteInfoParser(ref);
}