import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_info.dart';
import 'package:flutter_nav2_oop/nav2/screens/404_nav_screen.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

/// Implements tab navigation and tab screen stack builder,
/// adhering to declarative/functional UI concept.
///
/// Also serves as a holder for other
/// [ChangeNotifier]-derived application state
/// objects.
class TabNavState extends ChangeNotifier {
  /// State: collection of navigation tab
  /// definitions and tab state
  final List<TabInfo> _tabs = [];

  /// State: index of the currently selected navigation tab
  int _selectedTabIndex = 0;

  /// State: not-null if user entered invalid URL
  Uri? _notFoundUri;

  /// State: Index of a previously selected navigation tab.
  /// Only set when user explicitly tapped a nav tab.
  int? _prevSelectedTabIndex;

  /// Add tab definitions during application initialization
  void addTabs(List<TabInfo> tabs) {
    _tabs.addAll(tabs);
    //assertSingleStateItemOfEachType();
    selectedTab.addListener(notifyListeners);
  }

  /// Returns a navigation tab definition by its index
  TabInfo operator [](int index) => _tabs[index];

  /// Returns currently selected navigation tab, as defined
  /// by [selectedTabIndex] property.
  TabInfo get selectedTab => _tabs[selectedTabIndex];

  /// The *`UI = f(state)`* function.
  ///
  /// Builds entire application screen state, taking into
  /// account selected nav tab index, "child" screens of
  /// tab "root" screens, and a 404 screen.
  Iterable<TabbedNavScreen> buildNavigatorScreenStack() sync* {
    if (_prevSelectedTabIndex != null &&
        _prevSelectedTabIndex != _selectedTabIndex)
      // Enable back arrow navigation for a previously selected tab
      yield* _tabs[_prevSelectedTabIndex!].screenStack(this);

    // Return a screen stack for the currently selected tab
    yield* selectedTab.screenStack(this);

    if (notFoundUri != null) {
      // Put 404 screen on top of all others if user typed in
      // an invalid URL into the browser address bar.
      yield UrlNotFoundScreen.notFoundScreenFactory(this);
    }
  }

  /// Index of the currently selected tab
  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int selectedTabIndex) =>
      setSelectedTabIndex(selectedTabIndex, byUser: false);

  /// Internal (todo: refactor method visibility).
  /// Sets currently selected tab. Set [byUser] to `true` when this action
  /// is initiated be user tapping a tab, and to `else` otherwise.
  void setSelectedTabIndex(int selectedTabIndex, {required bool byUser}) {
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

    if (selectedTabIndex < 0 || selectedTabIndex >= _tabs.length) {
      // If `selectedTabIndex` is out of range, set it to 0
      print(
          'Selected tab index $selectedTabIndex is outside the [0..${_tabs.length - 1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    } else
      _selectedTabIndex = selectedTabIndex;

    if (beforeSelectedTabIndex != _selectedTabIndex) {
      // Ensure that state changes affecting screens in non-selected tabs
      // do not cause entire app UI rebuild
      _tabs[beforeSelectedTabIndex].removeListener(notifyListeners);
      // Bubble up notifications coming from state associated only with the current tab
      selectedTab.addListener(notifyListeners);

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
  void changeTabOnBackArrowTapIfNecessary(TabbedNavScreen topScreen) {

    /// Check whether there is info about previously selected tab.
    /// If not, no change to make.
    if (_prevSelectedTabIndex == null) return;

    assert(topScreen.tabIndex == _selectedTabIndex);

    if (_isThisScreenTheOnlyOneInItsTab(topScreen)) {
      // Tab screen stack has only one (current) screen,
      // meaning back arrow tap should change the tab.
      selectedTabIndex = _prevSelectedTabIndex!;
    }
  }

  /// Returns `true` if a given screen the only screen
  /// in its tab screen stack.
  bool _isThisScreenTheOnlyOneInItsTab(TabbedNavScreen screen) {
    // Screen stack withing the tab of the screen's tab
    final tabScreenStack = _tabs[screen.tabIndex].screenStack(this);
    return tabScreenStack.length == 1;
  }

  /// Returns all user-provided application state objects associated
  /// with all tabs.
  ///
  /// Current tab state could be excluded if necessary.
  Iterable<ChangeNotifier> allStateItems({bool excludeCurrentTab: false}) sync* {
    for (var tab in _tabs)
      if (excludeCurrentTab && tab == selectedTab)
        continue;
      else
        yield* tab.stateItems;
  }

  /// Finds a specific application state object by its type.
  ///
  /// If no parameters are specified, all tab state collections
  /// are searched. If [tabIndex] is specified, the search starts
  /// within that tab's state object collection, and if unsuccessful,
  /// continues to other tabs if [searchOtherTabs] is set to `true`.
  T stateByType<T extends ChangeNotifier>({
    /// If not specified or set to null,
    /// all tabs will be searched
    int? tabIndex,
    /// Ignored if [tabIndex] was null.
    /// If `false`, searches state objects
    /// only within the tab state object collection.
    /// Otherwise, searches all tabb state
    /// object collections
    bool searchOtherTabs = true
  }) {

    if(tabIndex != null) {
      // Start the search with specified tab's state
      // object collection.
      T? stateObject = _tabs[tabIndex].stateByType<T>();
      if(!searchOtherTabs) return stateObject!;
    }

    // Now, let's search the current tab, as the most likely place.
    T? currentTabStateItem = selectedTab.stateByType();
    if (currentTabStateItem != null) {
      return currentTabStateItem;
    }

    for (var stateItem in allStateItems(excludeCurrentTab: true))
      if (stateItem is T) return stateItem;

    throw new Exception('State of type \"$T\" was not found');
  } // selectedTab.stateByType<T>();

  /// A convenience method for iterating tabs
  Iterable<T> mapTabs<T>(T f(E)) => _tabs.map(f);

  /// Call from your app state constructor if
  /// you want to ensure that
  /// each type of state object is allowed
  /// only once in the entire collection of state
  /// items, regardless which tab this state type
  /// is associated with.
  void assertSingleStateItemOfEachType() {
    final List<String> stateTypes = [];
    final List<String> duplicateTypes = [];

    for (var stateItem in allStateItems(excludeCurrentTab: false)) {
      final stateItemType = stateItem.runtimeType.toString();

      if(stateTypes.any((typeName) => typeName == stateItemType)) {
        if(!duplicateTypes.any((typeName) => typeName == stateItemType)) {
          duplicateTypes.add(stateItemType);
        }
      }else {
        stateTypes.add(stateItemType);
      }
    }

    if(duplicateTypes.isNotEmpty) {
      throw Exception('Duplicate state types are prohibited: \"${duplicateTypes.join(', ')}\"');
    }
  }
}
