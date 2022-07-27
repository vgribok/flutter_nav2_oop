part of flutter_nav2_oop;

class BetterFutureBuilder<V> extends StatelessWidget {

  final Future<V> future;
  final Widget Function(V?, BuildContext) builder;
  final String? waitText;
  final bool waitCursorCentered;

  const BetterFutureBuilder({
    required this.future,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    super.key
  });

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<V>(
        future: future,
        builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.done ?
            builder(snapshot.data, ctx)
            : WaitIndicator(waitText: waitText, centered: waitCursorCentered)
      );
}