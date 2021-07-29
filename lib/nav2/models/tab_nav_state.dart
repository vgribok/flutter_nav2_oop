import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_info.dart';
import 'package:flutter_nav2_oop/nav2/screens/404_nav_screen.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

class TabNavState extends ChangeNotifier {

  final List<TabInfo> _tabs = [];
  int _selectedTabIndex = 0;
  Uri? _notFoundUri;
  int? _prevSelectedTabIndex;

  static final TabNavState instance = TabNavState();

  void addTabs(List<TabInfo> tabs) {
    _tabs.addAll(tabs);
    selectedTab.addListener(notifyListeners);
  }

  operator[](int index) => _tabs[index];

  TabInfo get selectedTab => _tabs[selectedTabIndex];

  Iterable<TabbedNavScreen> buildNavigatorScreenStack() sync* {

    if(_prevSelectedTabIndex != null && _prevSelectedTabIndex != _selectedTabIndex)
      yield* _tabs[_prevSelectedTabIndex!].screenStack(this);

    yield* selectedTab.screenStack(this);

    if(notFoundUri != null) {
      yield UrlNotFoundScreen.notFoundScreenFactory(this);
    }
  }

  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int selectedTabIndex) => setSelectedTabIndex(selectedTabIndex, byUser: false);

  void setSelectedTabIndex(int selectedTabIndex, { required bool byUser}) {

    final beforeSelectedTabIndex = _selectedTabIndex;
    final beforeNotFoundUri = _notFoundUri;
    final beforePrevSelectedTabIndex = _prevSelectedTabIndex;

    if(byUser) {
      _notFoundUri = null;
      _prevSelectedTabIndex = _selectedTabIndex == _prevSelectedTabIndex ? null : _selectedTabIndex;
    }else {
      _prevSelectedTabIndex = null;
    }

    if(selectedTabIndex < 0 || selectedTabIndex >= _tabs.length) {
      print('Selected tab index $selectedTabIndex is outside the [0..${_tabs.length-1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    }else
      _selectedTabIndex = selectedTabIndex;

    if(beforeSelectedTabIndex != _selectedTabIndex) {
      _tabs[beforeSelectedTabIndex].removeListener(notifyListeners);
      selectedTab.addListener(notifyListeners);

      notifyListeners();
      return;
    }

    if(beforeSelectedTabIndex != _selectedTabIndex ||
        beforeNotFoundUri != _notFoundUri ||
        beforePrevSelectedTabIndex != _prevSelectedTabIndex
    ) {
      notifyListeners();
    }
  }

  Uri? get notFoundUri => _notFoundUri;
  set notFoundUri(Uri? uri) {
    if(_notFoundUri == uri) return;

    _notFoundUri = uri;
    notifyListeners();
  }

  void adjustSelectedTabOnRoutePop(TabbedNavScreen topScreen) {
    if(_prevSelectedTabIndex == null) return;

    assert(topScreen.tabIndex == _selectedTabIndex);

    final tabScreenStack = _tabs[topScreen.tabIndex].screenStack(this);
    if(tabScreenStack.length == 1) {
      selectedTabIndex = _prevSelectedTabIndex!;
    }
  }


  Iterable<ChangeNotifier> allStateItems() sync* {
    for(var tab in _tabs)
      yield* tab.stateItems;
  }

  T stateByType<T extends ChangeNotifier>() {

    T? currentTabStateItem = selectedTab.stateByType();
    if(currentTabStateItem != null) {
      return currentTabStateItem;
    }

    for (var stateItem in allStateItems())
      if (stateItem is T)
        return stateItem;

    throw new Exception('State of type \"$T\" was not found');
  } // selectedTab.stateByType<T>();

  Iterable<T> mapTabs<T>(T f(E)) => _tabs.map(f);
}
