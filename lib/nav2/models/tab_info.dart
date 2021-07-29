import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/nav2/models/tab_nav_state.dart';
import 'package:flutter_nav2_oop/nav2/screens/tabbed_nav_screen.dart';

typedef TabRootScreenFactory = TabbedNavScreen Function(TabNavState navState);

class TabInfo {
  final String id;
  final IconData icon;
  final String? title;
  final TabRootScreenFactory rootScreenFactory;
  final List<ChangeNotifier> _stateItems;

  const TabInfo ({
    required this.icon,
    this.title,
    required this.id,
    required this.rootScreenFactory,
    List<ChangeNotifier>? stateItems
  }) : _stateItems = stateItems ?? const [];

  List<ChangeNotifier> get stateItems => _stateItems;

  Iterable<TabbedNavScreen> screenStack(TabNavState navState) sync* {
    final TabbedNavScreen rootScreen = rootScreenFactory(navState);
    yield rootScreen;

    for(TabbedNavScreen? nextScreen = rootScreen.topScreen ; nextScreen != null ; nextScreen = nextScreen.topScreen)
      yield nextScreen;
  }

  T? stateByType<T extends ChangeNotifier>() {
    for (var stateItem in stateItems)
      if (stateItem is T)
        return stateItem;
    return null;
  }

  void addListener(VoidCallback listener) =>
   _stateItems.forEach((stateItem) {
     assert(!stateItem.hasListeners);
     stateItem.addListener(listener);
   });

  void removeListener(VoidCallback listener) =>
    _stateItems.forEach((stateItem) {
      assert(stateItem.hasListeners);
      stateItem.removeListener(listener);
      assert(!stateItem.hasListeners);
    });
}
