part of flutter_nav2_oop;

class AppInitErrorScreen extends NavScreen {

  final Object err;
  final StackTrace? stack;

  const AppInitErrorScreen(this.err, this.stack, {super.key})
    : super(screenTitle: "Initializing the app");

  String get errorMessage => err.toString();

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
      ErrorDisplay(err, stack);

  @override
  RoutePath get routePath => const RoutePath(resource: "/");
}