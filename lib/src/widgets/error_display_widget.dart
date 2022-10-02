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

  const ErrorDisplay(this.err, this.stack, {super.key, required this.errorContext});

  String get errorMessage => err.toString();

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("$errorContext. Reason: \"$errorMessage\"",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

                if(stack != null && kDebugMode)
                  ..._debugInfoWidgets
              ]
          ))
      );

  List<Widget> get _debugInfoWidgets => [
    const Divider(thickness: 1, indent: 50, endIndent: 50),
    Expanded(child: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Text(stack!.toString(), style: GoogleFonts.cutiveMono(fontSize: 20))
    ))
  ];
}