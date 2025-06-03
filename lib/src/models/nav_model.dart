// ignore_for_file: constant_identifier_names

part of '../../all.dart';

class NavModel extends NavModelBase {

  final RootScreenSlot _rootScreenSlot;

  NavModel(
      RootScreenFactory rootScreenFactory,
      List<RoutePathFactory> routeParsers,
      super.homeRoute
  )
      : _rootScreenSlot = RootScreenSlot(
          rootScreenFactory: rootScreenFactory,
          routeParsers: routeParsers
      );

  @override
  RootScreenSlot get rootScreenSlot => _rootScreenSlot;
}

/// Implements tab navigation and tab screen stack builder,
/// adhering to declarative/functional UI concept.
///
/// Also serves as a holder for other
/// [ChangeNotifier]-derived application state
/// objects. Does not need state persistence or restorability because
/// [Navigator] class has its own built-in state restoration that is enabled
/// by supplying restorationId.
abstract class NavModelBase extends ChangeNotifier {

  /// State: not-null if user entered invalid URL
  Uri? _notFoundUri;

  /// Must be implemented in subclasses
  RootScreenSlot get rootScreenSlot;

  @protected
  final RoutePath homeRoute;

  NavModelBase(this.homeRoute);

  /// The *`UI = f(state)`* function.
  ///
  /// Builds entire application screen state, taking into
  /// account selected nav tab index, "child" screens of
  /// tab "root" screens, and a 404 screen.
  @protected
  @mustCallSuper
  Iterable<NavScreen> buildNavigatorScreenStack(WidgetRef ref) sync* {

    // Return a screen stack for the currently selected tab
    yield* rootScreenSlot._screenStack(ref);

    if (notFoundUri != null) {
      // Put 404 screen on top of all others if user typed in
      // an invalid URL into the browser address bar.
      yield UrlNotFoundScreen.notFoundScreenFactory(notFoundUri!);
    }
  }

  /// Invalid URL typed by a user into browser's address bar
  Uri? get notFoundUri => _notFoundUri;
  set notFoundUri(Uri? uri) {
    if (_notFoundUri == uri) return;

    _notFoundUri = uri;
    notifyListeners();
  }

  @protected
  List<RoutePathFactory> get routeParsers => [
    ...rootScreenSlot.routeParsers,
    homeRouteParser
  ];

  @protected
  RoutePath? homeRouteParser(Uri uri) =>
      uri.path == '/' ? homeRoute : null;
}

/// Saves and restores a [ChangeNotifier] ViewModel like [NavModel]
/// to/from the ephemeral state.
class _NavStateRestorerBase<T extends NavModelBase> extends RestorableListenable<T> {

  final T _navModel;

  _NavStateRestorerBase(this._navModel) {
    _navModel.addListener(notifyListeners);
  }

  @override
  T createDefaultValue() => _navModel;

  @override
  T fromPrimitives(Object? data) {
    final savedData = Map<String, dynamic>.from(data as Map);
    final T navModel = createDefaultValue();

    deserialize(navModel, savedData);

    return navModel;
  }

  @protected
  @mustCallSuper
  void deserialize(T navModel, Map<String, dynamic> savedData) =>
    navModel._notFoundUri = savedData["nav_not_found_uri"] as Uri?;

  @override
  Object? toPrimitives() => serialize(value);

  @protected
  @mustCallSuper
  Map<String, dynamic> serialize(T navModel) => <String, dynamic>{
    "nav_not_found_uri": navModel.notFoundUri
  };
}

class _NavStateRestorer extends _NavStateRestorerBase<NavModel> {

  _NavStateRestorer(super.navModel);

}