part of flutter_nav2_oop;

class AsyncValueAwaiter<T> extends StatelessWidget {

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
  Widget build(BuildContext context) {
    if(asyncData.isLoading) {
      return _buildWaitIndicator();
    }

    if(asyncData.hasError) {
      return onError(asyncData.error!, asyncData.stackTrace!);
    }

    final T? val = asyncData.value;
    if(val != null) {
      return builder(val);
    }

    return _buildWaitIndicator();
  }

  WaitIndicator _buildWaitIndicator() =>
      WaitIndicator(
          waitText: waitText,
          centered: waitCursorCentered,
          key: const ValueKey("async value awaiter wait indicator")
      );

  @protected
  Widget onError(Object error, StackTrace callStack) =>
      ErrorDisplay(error, callStack,
          errorContext: "Error while $waitText",
          onRetry: onRetry,
          key: const ValueKey("async value awaiter error pane")
      )
  ;
}