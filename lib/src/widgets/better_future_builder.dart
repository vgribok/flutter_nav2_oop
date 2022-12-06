part of flutter_nav2_oop;

class BetterFutureBuilder<T> extends StatefulWidget {

  final Future<T> future;
  final Widget Function(T?, BuildContext) builder;
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
  State<BetterFutureBuilder<T>> createState() =>
      _BetterFutureState<T>();
}

class _BetterFutureState<T> extends State<BetterFutureBuilder<T>> {

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<T>(
          future: widget.future,
          builder: (ctx, snapshot) {
            if(snapshot.hasError) {
              return buildErrorMessageWidget(snapshot);
            }

            return snapshot.connectionState == ConnectionState.done ?
              widget.builder(snapshot.data, ctx) :
              WaitIndicator(
                  waitText: widget.waitText,
                  centered: widget.waitCursorCentered,
                  key: const ValueKey("better future builder wait indicator")
              );
          }
      );

  @protected
  ErrorDisplay buildErrorMessageWidget(AsyncSnapshot<dynamic> snapshot) {
    return ErrorDisplay(snapshot.error!, null,
        errorContext: "Error while ${widget.waitText}",
        onRetry: () {
          triggerRepaint();
          widget.onRetry();
        },
        key: const ValueKey("better future builder error pane")
    );
  }
}