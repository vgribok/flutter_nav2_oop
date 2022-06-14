import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInitWaitScreen extends NavScreen {
  const AppInitWaitScreen({super.key})
      : super(screenTitle: "Initializing the app...");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        CircularProgressIndicator(),
        Divider(thickness: 1, indent: 50, endIndent: 50),
        Text("Initializing the app...")
      ]
    ));

  @override
  RoutePath get routePath => const RoutePath(resource: "/");
}