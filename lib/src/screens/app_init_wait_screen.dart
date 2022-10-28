part of flutter_nav2_oop;

class AppInitWaitScreen extends NavScreen {
  const AppInitWaitScreen({super.key})
      : super(screenTitle: "Initializing the app...");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    const WaitIndicator(waitText: "Initializing the app...", key: ValueKey("app init screen wait indicator"));

  @override
  RoutePath get routePath => const RoutePath(resource: "/");
}