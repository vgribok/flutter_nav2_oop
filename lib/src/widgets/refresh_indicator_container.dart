part of '../../all.dart';

class RefreshIndicatorContainer extends StatelessWidget {

  final Future<void> Function() onRefresh;
  final Widget child;

  const RefreshIndicatorContainer({required this.onRefresh, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 20.0,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: child,
        ),
      ),
    );
  }
}

class RefreshIndicatorProviderContainer<T> extends ConsumerWidget {

  final FutureProvider<T> refreshProvider;
  final Widget child;

  const RefreshIndicatorProviderContainer({required this.refreshProvider, required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      RefreshIndicatorContainer(
        key: const ValueKey("refresh indicator container"),
        onRefresh: () { refreshProvider.refresh(ref); return Future.value(); },
        child: child,
      );
}