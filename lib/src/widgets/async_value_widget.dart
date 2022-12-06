part of flutter_nav2_oop;

class AsyncValueAwaiter<T> extends StatefulWidget {

  final AsyncValue<T> asyncData;
  final Widget Function(T) builder;
  final String? waitText;
  final bool waitCursorCentered;
  final VoidCallback onRetry;

  const AsyncValueAwaiter({
    required this.asyncData,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    required this.onRetry,
    super.key
  });

  @override
  State<AsyncValueAwaiter<T>> createState() =>
      _AsyncValueAwaiterState<T>();
}

class _AsyncValueAwaiterState<T> extends State<AsyncValueAwaiter<T>> {

  @override
  Widget build(BuildContext context) {
    if(widget.asyncData.isLoading) {
      return _buildWaitIndicator();
    }

    if(widget.asyncData.hasError) {
      return onError(widget.asyncData.error!, widget.asyncData.stackTrace!);
    }

    if(widget.asyncData.hasValue) {
      return widget.builder(widget.asyncData.value!);
    }

    return _buildWaitIndicator();
  }

  WaitIndicator _buildWaitIndicator() {
    return WaitIndicator(
        waitText: widget.waitText,
        centered: widget.waitCursorCentered,
        key: const ValueKey("async value awaiter wait indicator")
    );
  }
      // widget.asyncData.when(
      //     data: (data) => widget.builder(data),
      //     error: onError,
      //     loading: () => WaitIndicator(
      //         waitText: widget.waitText,
      //         centered: widget.waitCursorCentered,
      //         key: const ValueKey("async value awaiter wait indicator")
      //     )
      // );

  @protected
  Widget onError(Object error, StackTrace callStack) =>
      ErrorDisplay(error, callStack,
          errorContext: "Error while ${widget.waitText}",
          onRetry: () {
            // setState(() {});
            widget.onRetry();
            // setState(() {});
            // triggerRepaint();
          },
          key: const ValueKey("async value awaiter error pane")
      );
}