part of flutter_nav2_oop;

/// A base class for full-screen modal dialogs
abstract class FullScreenModalDialog extends NavScreen {

  const FullScreenModalDialog(super.tabIndex,
  {
    /// Screen title
    required super.screenTitle,
    /// Optional user-supplied key.
    /// If not supplied, route URI
    /// is used as the key
    super.key
  });

  @override
  Widget? buildNavTabBar(BuildContext context, WidgetRef ref) => null; // Hides bottom navbar

  @override
  Widget? buildDrawer(BuildContext context, WidgetRef ref) => null; // Hides Drawer

  @override
  Widget buildVerticalRailAndBody(BuildContext context, WidgetRef ref, Widget body) => body;

  /// Closes the dialog
  void close(BuildContext context) => Navigator.pop(context);

  /// Builds dialog-specific [AbbBar] with the
  /// Cancel icon instead of the back arrow.
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) =>
      AppBar(
        title: Text(screenTitle),
        leading: IconButton(icon: const Icon(Icons.cancel), onPressed: () => close(context)),
        actions: buildAppBarActions(context, ref)
      );
}