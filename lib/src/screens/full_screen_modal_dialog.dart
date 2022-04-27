// ignore_for_file: unnecessary_this

part of flutter_nav2_oop;

/// A base class for full-screen modal dialogs
abstract class FullScreenModalDialog extends NavScreen {

  FullScreenModalDialog({
    /// Dialog's parent screen
    required NavScreen parent,
    /// Screen title
    required String screenTitle,
    required List<ChangeNotifierProvider> providers,
    /// Optional user-supplied key.
    /// If not supplied, route URI
    /// is used as the key
    LocalKey? key
  }) : super(
    screenTitle: screenTitle,
    tabIndex: parent.tabIndex,
    providers: providers,
    key: key
  );

  @override
  Widget? buildNavTabBar(BuildContext context, NavAwareState navState) => null; // Hides bottom navbar

  @override
  Widget? buildDrawer(BuildContext context, NavAwareState navState) => null; // Hides Drawer

  @override
  Widget buildVerticalRailAndBody(BuildContext context, Widget body, NavAwareState navState) => body;

  /// Closes the dialog
  void close(BuildContext context) => Navigator.pop(context);

  /// Builds dialog-specific [AbbBar] with the
  /// Cancel icon instead of the back arrow.
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) =>
      AppBar(
        title: Text(this.screenTitle),
        leading: IconButton(icon: const Icon(Icons.cancel), onPressed: () => close(context)),
        actions: buildAppBarActions(context)
      );
}