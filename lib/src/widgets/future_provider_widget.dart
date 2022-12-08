part of flutter_nav2_oop;

class FutureProviderBuilder<T> extends ConsumerWidget {

  final FutureProvider<T> provider;
  final Widget Function(T) builder;
  final String? waitText;
  final bool waitCursorCentered;
  final FutureProvider? refreshProvider;

  const FutureProviderBuilder({
    required this.provider,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    this.refreshProvider,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncValueAwaiter<T>(
          asyncData: provider.watchAsyncValue(ref),
          onRetry: () => _refreshData(ref),
          builder: builder,
      );

  void _refreshData(WidgetRef ref) => (refreshProvider ?? provider).invalidate(ref);
}