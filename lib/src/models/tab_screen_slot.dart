part of flutter_nav2_oop;

/// Signature of a method instantiating a root screen for a tab
typedef TabRootScreenFactory = NavScreen Function(int tabIndex, WidgetRef ref);

/// Defines both mutable and immutable parts of navigation tab's state.
///
/// Its' supplied by the app to define tab names, icons, root widgets and
/// parts of application state handled by the stack of screens.
class TabScreenSlot extends RootScreenSlot {
  /// Tab icon
  final IconData icon;

  /// Optional tab title
  final String? title;

  /// Function instantiating the root screen of the tab.
  ///
  /// The framework implements navigation flow that puts
  /// the root screen at the top of the navigation stack
  /// when the tab gets selected.
  final TabRootScreenFactory _tabRootScreenFactory;

  /// Index of the navigation tab in the tab navigation bar
  int? _tabIndex;

  TabScreenSlot(
    /// Tab icon
    this.icon,
    {
      /// Optional tab title
      this.title,
      /// Function instantiating the root screen of the tab.
      required TabRootScreenFactory rootScreenFactory,
    }
  ) : _tabRootScreenFactory = rootScreenFactory,
        super(rootScreenFactory: (ref) => rootScreenFactory(0, ref)); // Stubbing out with fake screen factory

  @override
  NavScreen getRootScreen(WidgetRef ref) =>
    _tabRootScreenFactory(_tabIndex!, ref);
}
