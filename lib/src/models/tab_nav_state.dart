part of flutter_nav2_oop;

enum NavType {
  BottomTabBar,
  Drawer,
  VerticalRail
}

/// Implements tab navigation and tab screen stack builder,
/// adhering to declarative/functional UI concept.
///
/// Also serves as a holder for other
/// [ChangeNotifier]-derived application state
/// objects.
class NavAwareState extends ChangeNotifier {

  NavType? _navigationType;

  /// State: collection of navigation tab
  /// definitions and tab state
  final List<TabInfo> tabs = [];

  /// State: index of the currently selected navigation tab
  int _selectedTabIndex = 0;

  /// State: not-null if user entered invalid URL
  Uri? _notFoundUri;

  /// State: Index of a previously selected navigation tab.
  /// Only set when user explicitly tapped a nav tab.
  int? _prevSelectedTabIndex;

  NavAwareState({NavType? navType}) : _navigationType = navType;

  /// Add tab definitions during application initialization
  void addTabs(List<TabInfo> tabs) {
    this.tabs.addAll(tabs);
    //assertSingleStateItemOfEachType();
    // selectedTab._addListener(this.notifyListeners);
  }

  /// Returns a navigation tab definition by its index
  TabInfo operator [](int index) => tabs[index];

  /// Returns currently selected navigation tab, as defined
  /// by [selectedTabIndex] property.
  TabInfo get selectedTab => tabs[selectedTabIndex];

  /// Defines application navigation mode, like bottom tabs,
  /// drawer, etc.
  ///
  /// If not specified, in portrait orientation bottom tabs are used,
  /// and in landscape orientation, vertical nav rail is used.
  NavType? get navigationType => _navigationType;
  set navigationType(NavType? navType) {
    if(_navigationType == navType) return;

    _navigationType = navType;
    notifyListeners();
  }

  /// Returns concrete navigation mode.
  ///
  /// When non-null navigation mode is set via [navigationType],
  /// then that is the returned value. If [navigationType] is null,
  /// device orientation determines navigation mode: in portrait
  /// orientation bottom tab bar is used, and in landscape mode the
  /// vertical rail is used.
  NavType get effectiveNavType =>
      _navigationType ??
          (isPortrait ? NavType.BottomTabBar : NavType.VerticalRail);

  /// The *`UI = f(state)`* function.
  ///
  /// Builds entire application screen state, taking into
  /// account selected nav tab index, "child" screens of
  /// tab "root" screens, and a 404 screen.
  Iterable<NavScreen> _buildNavigatorScreenStack() sync* {
    if (_prevSelectedTabIndex != null &&
        _prevSelectedTabIndex != _selectedTabIndex) {
      // Enable back arrow navigation for a previously selected tab
      yield* tabs[_prevSelectedTabIndex!]._screenStack(this);
    }
    // Return a screen stack for the currently selected tab
    yield* selectedTab._screenStack(this);

    if (notFoundUri != null) {
      // Put 404 screen on top of all others if user typed in
      // an invalid URL into the browser address bar.
      yield UrlNotFoundScreen.notFoundScreenFactory(this);
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
      // if selected tab change was initiated by user tapping a a tab
      _notFoundUri = null;
      _prevSelectedTabIndex =
          _selectedTabIndex == _prevSelectedTabIndex ? null : _selectedTabIndex;
    } else {
      // Disable back button navigation on tab switch if initiated
      // by the system
      _prevSelectedTabIndex = null;
    }

    if (selectedTabIndex < 0 || selectedTabIndex >= tabs.length) {
      // If `selectedTabIndex` is out of range, set it to 0
      print(
          'Selected tab index $selectedTabIndex is outside the [0..${tabs.length - 1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    } else
      _selectedTabIndex = selectedTabIndex;

    if (beforeSelectedTabIndex != _selectedTabIndex) {
      // // Ensure that state changes affecting screens in non-selected tabs
      // // do not cause entire app UI rebuild
      // tabs[beforeSelectedTabIndex]._removeListener(this.notifyListeners);
      // Bubble up notifications coming from state associated only with the current tab
      // selectedTab._addListener(this.notifyListeners);

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

  bool _isPortrait = true;

  /// Returns current device orientation
  bool get isPortrait => _isPortrait;
  set isPortrait(bool newVal) {
    if(_isPortrait == newVal) return;

    _isPortrait = newVal;
    notifyListeners();
  }

  /// Internal. Tests whether selected tab needs to be changed
  /// on route pop, when user hits navigation back button.
  void changeTabOnBackArrowTapIfNecessary(NavScreen topScreen) {

    /// Check whether there is info about previously selected tab.
    /// If not, no change to make.
    if (_prevSelectedTabIndex == null) return;

    assert(topScreen.tabIndex == _selectedTabIndex);

    if (topScreen.tab.hasOnlyOneScreenInStack(this)) {
      // Tab screen stack has only one (current) screen,
      // meaning back arrow tap should change the tab.
      selectedTabIndex = _prevSelectedTabIndex!;
    }
  }

  // /// Returns all user-provided application state objects associated
  // /// with all tabs.
  // ///
  // /// Current tab state could be excluded if necessary.
  // Iterable<ChangeNotifier> _allStateItems({bool excludeCurrentTab: false}) sync* {
  //   for (var tab in tabs)
  //     if (excludeCurrentTab && tab == selectedTab)
  //       continue;
  //     else
  //       yield* tab.stateItems;
  // }

  // /// Finds a specific application state object by its type.
  // ///
  // /// If no parameters are specified, all tab state collections
  // /// are searched. If [tabIndex] is specified, the search starts
  // /// within that tab's state object collection, and if unsuccessful,
  // /// continues to other tabs if [searchOtherTabs] is set to `true`.
  // T stateByType<T extends ChangeNotifier>({
  //   /// If not specified or set to null,
  //   /// all tabs will be searched
  //   int? tabIndex,
  //   /// Ignored if [tabIndex] was null.
  //   /// If `false`, searches state objects
  //   /// only within the tab state object collection.
  //   /// Otherwise, searches all tabb state
  //   /// object collections
  //   bool searchOtherTabs = true
  // }) {
  //
  //   if(tabIndex != null) {
  //     // Start the search with specified tab's state
  //     // object collection.
  //     T? stateObject = tabs[tabIndex].stateByType<T>();
  //     if(!searchOtherTabs) return stateObject!;
  //   }
  //
  //   // Now, let's search the current tab, as the most likely place.
  //   T? currentTabStateItem = selectedTab.stateByType();
  //   if (currentTabStateItem != null) {
  //     return currentTabStateItem;
  //   }
  //
  //   T stateItem = _allStateItems(excludeCurrentTab: true)
  //     .firstWhere((item) => item is T,
  //       orElse: () => throw new Exception('State of type \"$T\" was not found')
  //     ) as T;
  //
  //   return stateItem;
  // } // selectedTab.stateByType<T>();

  /// A convenience method for iterating tabs
  Iterable<T> mapTabs<T>(T f(E)) => tabs.map(f);

  // /// Call from your app state constructor if
  // /// you want to ensure that
  // /// each type of state object is allowed
  // /// only once in the entire collection of state
  // /// items, regardless which tab this state type
  // /// is associated with.
  // void assertSingleStateItemOfEachType() {
  //   final List<String> stateTypes = [];
  //   final List<String> duplicateTypes = [];
  //
  //   for (var stateItem in _allStateItems(excludeCurrentTab: false)) {
  //     final stateItemType = stateItem.runtimeType.toString();
  //
  //     if(stateTypes.any((typeName) => typeName == stateItemType)) {
  //       if(!duplicateTypes.any((typeName) => typeName == stateItemType)) {
  //         duplicateTypes.add(stateItemType);
  //       }
  //     }else {
  //       stateTypes.add(stateItemType);
  //     }
  //   }
  //
  //   if(duplicateTypes.isNotEmpty) {
  //     throw Exception('Duplicate state types are prohibited: \"${duplicateTypes.join(', ')}\"');
  //   }
  // }
}
