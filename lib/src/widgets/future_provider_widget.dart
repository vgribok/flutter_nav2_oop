part of '../../all.dart';

class FutureProviderBuilder<T> extends ConsumerWidget {

  final FutureProvider<T> provider;
  final Widget Function(T) builder;
  final String? waitText;
  final bool waitCursorCentered;
  final FutureProvider? refreshProvider;
  final Color? waitIndicatorColor;

  const FutureProviderBuilder({
    required this.provider,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    this.refreshProvider,
    this.waitIndicatorColor,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncValueAwaiter<T>(
          asyncData: ref.watch(provider),
          onRetry: () => _refreshData(ref),
          builder: builder,
          waitIndicatorColor: waitIndicatorColor,
      );

  void _refreshData(WidgetRef ref) => ref.invalidate(refreshProvider ?? provider);
}