// ignore_for_file: constant_identifier_names

part of flutter_nav2_oop;

enum NavControlType {
  BottomTabBar,
  Drawer,
  VerticalRail
}

/// Implements tab navigation and tab screen stack builder,
/// adhering to declarative/functional UI concept.
///
/// Also serves as a holder for other
/// [ChangeNotifier]-derived application state
/// objects. Does not need state persistence or restorability because
/// [Navigator] class has its own built-in state restoration that is enabled
/// by supplying restorationId.
class TabNavModel extends ChangeNotifier {
  /// State: collection of navigation tab
  /// definitions and tab state
  final List<TabScreenSlot> _tabs = [];

  /// State: index of the currently selected navigation tab
  int _selectedTabIndex = 0;

  /// State: not-null if user entered invalid URL
  Uri? _notFoundUri;

  /// State: Index of a previously selected navigation tab.
  /// Only set when user explicitly tapped a nav tab.
  /// Enables back arrow navigation for switching between nav tabs.
  int? _prevSelectedTabIndex;

  TabNavModel(Iterable<TabScreenSlot> tabs, int initialTabIndex)
    : _selectedTabIndex = initialTabIndex
  {
    addTabs(tabs);
  }

  /// Add tab definitions during application initialization
  void addTabs(Iterable<TabScreenSlot> tabs) {
    _tabs.clear();

    int i = 0;
    for(final tab in tabs) {
      _tabs.add(tab);
      tab._tabIndex = i++;
    }
  }

  /// Returns a navigation tab definition by its index
  TabScreenSlot operator [](int index) => _tabs[index];

  /// Returns currently selected navigation tab, as defined
  /// by [selectedTabIndex] property.
  TabScreenSlot get selectedTab => _tabs[selectedTabIndex];

  /// The *`UI = f(state)`* function.
  ///
  /// Builds entire application screen state, taking into
  /// account selected nav tab index, "child" screens of
  /// tab "root" screens, and a 404 screen.
  Iterable<NavScreen> _buildNavigatorScreenStack(WidgetRef ref) sync* {

    if (_prevSelectedTabIndex != null &&
        _prevSelectedTabIndex != _selectedTabIndex) {
      // Enable back arrow navigation for a previously selected tab
      yield* _tabs[_prevSelectedTabIndex!]._screenStack(ref);
    }

    // Return a screen stack for the currently selected tab
    yield* selectedTab._screenStack(ref);

    if (notFoundUri != null) {
      // Put 404 screen on top of all others if user typed in
      // an invalid URL into the browser address bar.
      yield UrlNotFoundScreen.notFoundScreenFactory(selectedTabIndex, notFoundUri!);
    }
  }

  /// Index of the currently selected tab
  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int selectedTabIndex) =>
      _setSelectedTabIndex(selectedTabIndex, byUser: false);

  /// Sets currently selected tab. Set [byUser] to `true` when this action
  /// is initiated be user tapping a tab, and to `else` otherwise.
  void _setSelectedTabIndex(int selectedTabIndex, {required bool byUser}) {
    final beforeSelectedTabIndex = _selectedTabIndex;
    final beforeNotFoundUri = _notFoundUri;
    final beforePrevSelectedTabIndex = _prevSelectedTabIndex;

    if (byUser) {
      // Enable back button navigation for the previously selected tab
      // if selected tab change was initiated by user tapping a tab
      _notFoundUri = null;
      _prevSelectedTabIndex =
          selectedTabIndex == _selectedTabIndex ? null : _selectedTabIndex;
    } else {
      // Disable back button navigation on tab switch if initiated
      // by the system
      _prevSelectedTabIndex = null;
    }

    if (selectedTabIndex < 0 || selectedTabIndex >= _tabs.length) {
      // If `selectedTabIndex` is out of range, set it to 0
      debugPrint(
          'Selected tab index $selectedTabIndex is outside the [0..${_tabs.length - 1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    } else {
      _selectedTabIndex = selectedTabIndex;
    }
    
    if (beforeSelectedTabIndex != _selectedTabIndex) {
      // Notify the UI to rebuild due to selected tab change
      notifyListeners();
      return;
    }

    if (beforeNotFoundUri != _notFoundUri ||
        beforePrevSelectedTabIndex != _prevSelectedTabIndex) {
      // Notify the UI to rebuild due to other
      // navigation-related state change
      notifyListeners();
    }
  }

  /// Invalid URL typed by a user into browser's address bar
  Uri? get notFoundUri => _notFoundUri;
  set notFoundUri(Uri? uri) {
    if (_notFoundUri == uri) return;

    _notFoundUri = uri;
    notifyListeners();
  }

  /// Internal. Tests whether selected tab needs to be changed
  /// on route pop, when user hits navigation back button.
  void changeTabOnBackArrowTapIfNecessary(NavScreen topScreen, WidgetRef ref) {

    /// Check whether there is info about previously selected tab.
    /// If not, no change to make.
    if (_prevSelectedTabIndex == null) return;

    assert(topScreen.tabIndex == _selectedTabIndex);

    if (topScreen.tab(ref).hasOnlyOneScreenInStack(ref)) {
      // Tab screen stack has only one (current) screen,
      // meaning back arrow tap should change the tab.
      selectedTabIndex = _prevSelectedTabIndex!;
    }
  }
}

/// Saves and restores a [ChangeNotifier] ViewModel like [TabNavModel]
/// to/from the ephemeral state.
class _NavStateRestorer extends RestorableListenable<TabNavModel> {

  final TabNavModel _tabNavModel;

  _NavStateRestorer(this._tabNavModel) {
    _tabNavModel.addListener(notifyListeners);
  }

  @override
  TabNavModel createDefaultValue() => _tabNavModel;

  @override
  TabNavModel fromPrimitives(Object? data) {
    final savedData = Map<String, dynamic>.from(data as Map);

    final int? prevSelectedTabIndex = savedData["nav_prev_selected_index"] as int?;
    final Uri? notFoundUri = savedData["nav_not_found_uri"] as Uri?;
    final int selectedTabIndex = savedData["nav_tab_index"] as int;

    final navState = createDefaultValue();

    navState._selectedTabIndex = selectedTabIndex;
    navState._prevSelectedTabIndex = prevSelectedTabIndex;
    navState._notFoundUri = notFoundUri;

    return navState;
  }

  @override
  Object? toPrimitives() => <String, dynamic>{
    "nav_tab_index": value.selectedTabIndex,
    "nav_prev_selected_index": value._prevSelectedTabIndex,
    "nav_not_found_uri": value.notFoundUri
  };
}