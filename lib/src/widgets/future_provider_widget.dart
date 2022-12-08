part of flutter_nav2_oop;

class FutureProviderBuilder<T> extends ConsumerWidget {

  final FutureProvider<T> provider;
  final Widget Function(T) builder;
  final String? waitText;
  final bool waitCursorCentered;
  final FutureProvider? retryProvider;

  const FutureProviderBuilder({
    required this.provider,
    required this.builder,
    this.waitText = "Processing...",
    this.waitCursorCentered = true,
    this.retryProvider,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncValueAwaiter<T>(
          asyncData: provider.watchAsyncValue(ref),
          builder: builder,
          onRetry: () => (retryProvider ?? provider).invalidate(ref)
      );
}