import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_info.dart';
import 'package:flutter_nav2_oop/nav2/screens/404_nav_screen.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

class TabNavState extends ChangeNotifier {

  final List<TabInfo> tabs = [];
  int _selectedTabIndex = 0;
  Uri? _notFoundUri;
  int? _prevSelectedTabIndex;

  static final TabNavState instance = TabNavState();

  TabInfo get selectedTab => tabs[selectedTabIndex];

  Iterable<TabbedNavScreen> buildNavigatorScreenStack() sync* {

    if(_prevSelectedTabIndex != null && _prevSelectedTabIndex != _selectedTabIndex)
      yield* tabs[_prevSelectedTabIndex!].screenStack(this);

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

    if(selectedTabIndex < 0 || selectedTabIndex >= tabs.length) {
      print('Selected tab index $selectedTabIndex is outside the [0..${tabs.length-1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    }else
      _selectedTabIndex = selectedTabIndex;

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

    final tabScreenStack = tabs[topScreen.tabIndex].screenStack(this);
    if(tabScreenStack.length == 1) {
      selectedTabIndex = _prevSelectedTabIndex!;
    }
  }
}
