import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInitErrorScreen extends NavScreen {

  final Object err;
  final StackTrace? stack;

  const AppInitErrorScreen(this.err, this.stack, {super.key})
    : super(screenTitle: "Initializing the app");

  String get errorMessage => err.toString();

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
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

  @override
  RoutePath get routePath => const RoutePath(resource: "/");
}