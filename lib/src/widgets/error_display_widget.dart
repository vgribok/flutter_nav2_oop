part of flutter_nav2_oop;

/// Displays error information widget. When debugging, shows the
/// call stack is it's supplied.
class ErrorDisplay extends StatelessWidget {

  /// Error object of any kind, including but not limited to
  /// [Error] and [Exception]
  final Object err;
  /// Optional call stack
  final StackTrace? stack;
  /// Error message telling what the app was trying to accomplish
  /// when it failed
  final String errorContext;

  final void Function() onRetry;

  const ErrorDisplay(this.err, this.stack,
      {
        super.key, required this.errorContext, required this.onRetry
      })
  ;

  String get errorMessage => err.toString();

  @override
  Widget build(BuildContext context) =>
    Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Padding(padding: const EdgeInsets.all(5),
          child: CenteredColumn(
              children: [
                Text("$errorContext. Reason: \"$errorMessage\"",
                    key: const ValueKey("error text"),
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.bodyText1?.copyWith(color: context.colorScheme.onErrorContainer)
                ),
                ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
                if(stack != null && kDebugMode)
                  ..._getDebugInfoWidgets(context)
              ]
          )
        )
      )
    );

  List<Widget> _getDebugInfoWidgets(BuildContext context) => [
    const Divider(thickness: 1, indent: 50, endIndent: 50),
    Expanded(child: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Text(
            stack!.toString(),
            style: GoogleFonts.cutiveMono(fontSize: 20).copyWith(color: context.colorScheme.onErrorContainer),
            key: const ValueKey("debug info text")
        )
    ))
  ];
}

class ExpandedErrorDisplay extends ErrorDisplay {

  const ExpandedErrorDisplay(super.err, super.stack, {
    super.key, required super.errorContext, required super.onRetry
  });

  @override
  Widget build(BuildContext context) =>
      RefreshIndicatorContainer(
        onRefresh: () { onRetry(); return Future.value(); },
        child: super.build(context)
      );
}