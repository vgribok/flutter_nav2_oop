part of flutter_nav2_oop;

extension ContextEx on BuildContext {
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
}