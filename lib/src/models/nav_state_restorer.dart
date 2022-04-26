part of flutter_nav2_oop;

class NavStateRestorer extends RestorableChangeNotifier<NavAwareState> {

  final NavType? navType;
  final List<TabInfo> tabs;

  NavStateRestorer({this.navType, required this.tabs}) : super();

  @override
  NavAwareState createDefaultValue() {
    final navState = NavAwareState(navType: navType);
    navState.addTabs(tabs);
    navState.assertSingleStateItemOfEachType();
    navState.addListener(notifyListeners);
    return navState;
  }

  @override
  NavAwareState fromPrimitives(Object? data) {
    final savedData = Map<String, dynamic>.from(data as Map);

    final NavType? navType = savedData["nav_type"] as NavType?;
    final int selectedTabIndex = savedData["nav_tab_index"] as int;
    final int? prevSelectedTabIndex = savedData["nav_prev_selected_index"] as int?;
    final Uri? notFoundUri = savedData["nav_not_found_uri"] as Uri?;

    final navState = createDefaultValue();

    navState._navigationType = navType;
    navState._notFoundUri = notFoundUri;
    navState._prevSelectedTabIndex = prevSelectedTabIndex;
    navState._selectedTabIndex = selectedTabIndex;

    return navState;
  }

  @override
  Object? toPrimitives() {
    return <String, dynamic>{
      "nav_type": value._navigationType,
      "nav_tab_index": value.selectedTabIndex,
      "nav_prev_selected_index": value._prevSelectedTabIndex,
      "nav_not_found_uri": value.notFoundUri
    };
  }
}