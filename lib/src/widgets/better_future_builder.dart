part of flutter_nav2_oop;

class BetterFutureBuilder<V> extends StatelessWidget {

  final Future<V> future;
  final Widget Function(V?, BuildContext) builder;
  final String? waitText;
  final bool waitCursorCentered;
  final VoidCallback onRetry;

  const BetterFutureBuilder({
    required this.future,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    required this.onRetry,
    super.key
  });

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<V>(
        future: future,
        builder: (ctx, snapshot) {
          if(snapshot.hasError) {
            return buildErrorMessageWidget(snapshot);
          }

          return snapshot.connectionState == ConnectionState.done ?
                      builder(snapshot.data, ctx) :
                      WaitIndicator(waitText: waitText, centered: waitCursorCentered, key: const ValueKey("better future builder wait indicator"));
        }
      );

  @protected
  ErrorDisplay buildErrorMessageWidget(AsyncSnapshot<dynamic> snapshot) {
    return ErrorDisplay(snapshot.error!, null,
        errorContext: "Error while $waitText",
        onRetry: onRetry,
        key: const ValueKey("better future builder error pane")
    );
  }
}