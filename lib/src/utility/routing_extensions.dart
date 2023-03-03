part of flutter_nav2_oop;

extension RouteEx<T> on Route<T> {
  NavScreen get navScreen {
    MaterialPage page = settings as MaterialPage; // Cast settings to Page
    // Cast page.child to NavScreen
    NavScreen navScreen = page.child as NavScreen;
    return navScreen;
  }
}