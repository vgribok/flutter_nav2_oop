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
class TabNavModel extends _NavModelBase {
  /// State: collection of navigation tab
  /// definitions and tab state
  final List<TabScreenSlot> _tabs = [];

  /// State: index of the currently selected navigation tab
  int _selectedTabIndex = 0;

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
  @override
  RootScreenSlot get rootScreenSlot => _tabs[selectedTabIndex];

  /// The *`UI = f(state)`* function.
  ///
  /// Builds entire application screen state, taking into
  /// account selected nav tab index, "child" screens of
  /// tab "root" screens, and a 404 screen.
  @override
  Iterable<NavScreen> buildNavigatorScreenStack(WidgetRef ref) sync* {

    if (_prevSelectedTabIndex != null &&
        _prevSelectedTabIndex != _selectedTabIndex) {
      // Enable back arrow navigation for a previously selected tab
      yield* _tabs[_prevSelectedTabIndex!]._screenStack(ref);
    }

    yield* super.buildNavigatorScreenStack(ref);
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
      // Notify the RoutingDelegate to repaint the UI due to selected tab change
      notifyListeners();
      return;
    }

    if (beforeNotFoundUri != _notFoundUri ||
        beforePrevSelectedTabIndex != _prevSelectedTabIndex) {
      // Notify the RoutingDelegate to repaint the UI due to other
      // navigation-related state change
      notifyListeners();
    }
  }

  /// Internal. Tests whether selected tab needs to be changed
  /// on route pop, when user hits navigation back button.
  void changeTabOnBackArrowTapIfNecessary(TabNavScreen topScreen, WidgetRef ref) {

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
class _TabNavStateRestorer extends _NavStateRestorerBase<TabNavModel> {

  _TabNavStateRestorer(TabNavModel tabNavModel) : super(tabNavModel);

  @override
  void deserialize(TabNavModel navModel, Map<String, dynamic> savedData) {
    super.deserialize(navModel, savedData);

    navModel._selectedTabIndex = savedData["nav_tab_index"] as int;
    navModel._prevSelectedTabIndex = savedData["nav_prev_selected_index"] as int?;
  }

  @override
  Map<String, dynamic> serialize(TabNavModel navModel) {
    Map<String, dynamic> map = super.serialize(navModel);

    map.addAll({
      "nav_tab_index": navModel.selectedTabIndex,
      "nav_prev_selected_index": navModel._prevSelectedTabIndex,
    });

    return map;
  }
}