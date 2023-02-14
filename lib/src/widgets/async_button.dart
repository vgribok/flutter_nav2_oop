part of flutter_nav2_oop;

class ElevatedAsyncButton extends AsyncButton {
  ElevatedAsyncButton(
      StateProvider<bool>  asyncActionProgressProvider,
      {
        required super.child,
        required super.onPressed, required super.onDisplayError, required super.onLogError,
        super.timeout = const Duration(seconds: 5),
        super.color,
        super.key
      }) : super(asyncActionProgressProvider,
              (context, ref, innerChild, internalKey, internalOnPress, color) =>
                ElevatedButton(onPressed: internalOnPress, key: internalKey, child: innerChild)
           );
}

class OutlinedAsyncButton extends AsyncButton {
  OutlinedAsyncButton(
      StateProvider<bool>  asyncActionProgressProvider,
      {
        required super.child,
        required super.onPressed, required super.onDisplayError, required super.onLogError,
        super.timeout = const Duration(seconds: 5),
        super.color,
        super.key
      }) : super(asyncActionProgressProvider,
            (context, ref, innerChild, internalKey, internalOnPress, color) =>
                OutlinedButton(onPressed: internalOnPress, key: internalKey, child: innerChild)
          );
}

class TextAsyncButton extends AsyncButton {
  TextAsyncButton(
      StateProvider<bool>  asyncActionProgressProvider,
      {
        required super.child,
        required super.onPressed, required super.onDisplayError, required super.onLogError,
        super.timeout = const Duration(seconds: 5),
        super.color,
        super.key
      }) : super(asyncActionProgressProvider,
              (context, ref, innerChild, internalKey, internalOnPress, color) =>
                TextButton(onPressed: internalOnPress, key: internalKey, child: innerChild)
          );
}

class FloatingActionAsyncButton extends AsyncButton {

  FloatingActionAsyncButton(
      StateProvider<bool>  asyncActionProgressProvider,
      {
        required String tooltip,
        required super.child,
        required super.onPressed, required super.onDisplayError, required super.onLogError,
        super.timeout = const Duration(seconds: 5),
        super.color,
        Color? backgroundColor,
        super.key
      }) : super(
              asyncActionProgressProvider,
              (context, ref, innerChild, internalKey, internalOnPress, color) =>
                  FloatingActionButton(
                    key: internalKey,
                    onPressed: internalOnPress,
                    tooltip: tooltip,
                    foregroundColor: color ?? context.colorScheme.onPrimary,
                    backgroundColor: backgroundColor ?? context.colorScheme.primary,
                    child: innerChild,
                  )
          );
}

class IconAsyncButton extends AsyncButton {

  IconAsyncButton(
      StateProvider<bool>  asyncActionProgressProvider,
      {
        required String tooltip,
        required Widget icon,
        required super.onPressed, required super.onDisplayError, required super.onLogError,
        super.timeout = const Duration(seconds: 5),
        Color? color,
        super.key
      }) : super(
              asyncActionProgressProvider,
              child: icon,
              (context, ref, innerChild, internalKey, internalOnPress, color) =>
                  IconButton(
                    key: internalKey,
                    onPressed: internalOnPress,
                    tooltip: tooltip,
                    icon: innerChild,
                    color: color
                  ),
          );
}

abstract class AsyncButton extends ConsumerWidget {

  final Widget Function(BuildContext context, WidgetRef ref, Widget child, Key key, Future Function() onPressed, Color? color) _mainControlBuilder;
  final StateProvider<bool> _asyncActionProgressProvider;
  final Future Function() _onPressed;
  final String Function() _onDisplayError;
  final String Function(Object error) _onLogError;
  final Widget _child;
  final Duration _timeout;
  final Color? color;

  const AsyncButton(
      this._asyncActionProgressProvider,
      this._mainControlBuilder,
      {
        required Widget child,
        /// A long-running, async I/O operation, like a web/network API call, file access, etc.
        required Future Function() onPressed,
        /// Returns a brief, UI-friendly error message to shown in the snackbar.
        required String Function() onDisplayError,
        /// Returns a detailed error message to be logged for debugging
        required String Function(Object error) onLogError,
        required Duration timeout,
        this.color,
        super.key
      }) :
        _onPressed = onPressed,
        _onDisplayError = onDisplayError,
        _onLogError = onLogError,
        _child = child,
        _timeout = timeout
      ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool asyncActionInProgress = ref.watch(_asyncActionProgressProvider);
    return _mainControlBuilder(
      context, ref,
      asyncActionInProgress ? CircularProgressIndicator(strokeWidth: 2, color: color) : _child,
      ValueKey("${super.key}-button"),
      () => _internalOnPress(context, ref),
      color
    );
  }

  Future<void> _internalOnPress(BuildContext context, WidgetRef ref) async {

    final bool asyncActionInProgress = ref.read(_asyncActionProgressProvider);
    if(asyncActionInProgress) {
      context.showSnackBar("Another operation is in progress, please wait");
      return;
    }

    final progressStateProvider = _asyncActionProgressProvider.writable(ref);

    try {
      progressStateProvider.state = true;
      await _onPressed().timeout(_timeout);
    } catch(e) {
      _onLogError(e).debugPrint();
      context.showSnackBar(_onDisplayError());
    }
    finally
    {
      progressStateProvider.state = false;
      assert(progressStateProvider.state == false);
    }
  }
}