part of flutter_nav2_oop;

class AsyncValueAwaiter<V> extends StatelessWidget {

  final AsyncValue<V> asyncData;
  final Widget Function(V) builder;
  final String? waitText;
  final bool waitCursorCentered;

  const AsyncValueAwaiter({
    required this.asyncData,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    super.key
  });

  @override
  Widget build(BuildContext context) =>
      asyncData.when(
          data: (data) => builder(data),
          error: (err, stack) => ErrorDisplay(err, stack, errorContext: "Error while $waitText", key: const ValueKey("async value awaiter error pane")),
          loading: () => WaitIndicator(waitText: waitText, centered: waitCursorCentered, key: const ValueKey("async value awaiter wait indicator"))
      );
}