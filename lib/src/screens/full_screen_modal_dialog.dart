part of flutter_nav2_oop;

/// A base class for full-screen modal dialogs
abstract class FullScreenModalDialog extends NavScreen {

  const FullScreenModalDialog({
    /// Screen title
    required super.screenTitle,
    /// Optional user-supplied key.
    /// If not supplied, route URI
    /// is used as the key
    super.key
  });

  @protected
  @override
  bool get isModal => true;

  /// Closes the dialog
  void close(BuildContext context) => Navigator.pop(context);

  /// Builds dialog-specific [AbbBar] with the
  /// Cancel icon instead of the back arrow.
  @override
  AppBar? buildAppBar(BuildContext context, WidgetRef ref) =>
      AppBar(
        title: Text(getScreenTitle(ref), key: const ValueKey("app bar title")),
        leading: IconButton(icon: const Icon(Icons.cancel, key: ValueKey("app bar cancel icon")), onPressed: () => close(context), key: const ValueKey("app bar cancel button")),
        actions: buildAppBarActions(context, ref),
        key: const ValueKey("app bar")
      );
}