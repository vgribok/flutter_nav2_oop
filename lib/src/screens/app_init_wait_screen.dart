part of '../../all.dart';

class AppInitWaitScreen extends NavScreen {
  const AppInitWaitScreen({super.key, this.waitIndicatorColor})
      : super(screenTitle: "Initializing the app...");

  final Color? waitIndicatorColor;

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    WaitIndicator(waitText: "Initializing the app...",
      key: const ValueKey("app init screen wait indicator"),
      color: waitIndicatorColor,
    );

  @override
  RoutePath get routePath => const RoutePath(resource: "/");
}