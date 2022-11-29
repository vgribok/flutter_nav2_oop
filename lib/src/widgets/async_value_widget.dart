part of flutter_nav2_oop;

class AsyncValueAwaiter<V> extends StatelessWidget {

  final AsyncValue<V> asyncData;
  final Widget Function(V) builder;
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
  Widget build(BuildContext context) =>
      asyncData.when(
          data: (data) => builder(data),
          error: onError,
          loading: () => WaitIndicator(waitText: waitText, centered: waitCursorCentered, key: const ValueKey("async value awaiter wait indicator"))
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