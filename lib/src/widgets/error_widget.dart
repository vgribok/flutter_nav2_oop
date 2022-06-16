part of flutter_nav2_oop;

class ErrorDisplay extends StatelessWidget {

  final Object err;
  final StackTrace? stack;

  const ErrorDisplay(this.err, this.stack, {super.key});

  String get errorMessage => err.toString();

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Failed to initialize the app due to \"$errorMessage\"",
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