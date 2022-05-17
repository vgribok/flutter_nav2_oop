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
  // TODO: consider splitting non-tabbed and tab-based navigation models

  /// State: collection of navigation tab
  /// definitions and tab state
  final List<TabInfo> tabs = [];

  /// State: index of the currently selected navigation tab
  int _selectedTabIndex = 0;

  /// State: not-null if user entered invalid URL
  Uri? _notFoundUri;

  /// State: Index of a previously selected navigation tab.
  /// Only set when user explicitly tapped a nav tab.
  /// Enables back arrow navigation for switching between nav tabs.
  int? _prevSelectedTabIndex;

  TabNavModel({required Iterable<TabInfo> tabs})
  {
    addTabs(tabs);
  }

  /// Add tab definitions during application initialization
  void addTabs(Iterable<TabInfo> tabs) {
    this.tabs.clear();
    this.tabs.addAll(tabs);
  }

  /// Returns a navigation tab definition by its index
  TabInfo operator [](int index) => tabs[index];

  /// Returns currently selected navigation tab, as defined
  /// by [selectedTabIndex] property.
  TabInfo get selectedTab => tabs[selectedTabIndex];

  /// The *`UI = f(state)`* function.
  ///
  /// Builds entire application screen state, taking into
  /// account selected nav tab index, "child" screens of
  /// tab "root" screens, and a 404 screen.
  Iterable<NavScreen> _buildNavigatorScreenStack(WidgetRef ref) sync* {

    if (_prevSelectedTabIndex != null &&
        _prevSelectedTabIndex != _selectedTabIndex) {
      // Enable back arrow navigation for a previously selected tab
      yield* tabs[_prevSelectedTabIndex!]._screenStack(ref);
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

    if (selectedTabIndex < 0 || selectedTabIndex >= tabs.length) {
      // If `selectedTabIndex` is out of range, set it to 0
      debugPrint(
          'Selected tab index $selectedTabIndex is outside the [0..${tabs.length - 1}] range. Setting index to 0.');
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
