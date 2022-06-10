part of flutter_nav2_oop;

extension StateProviderEx<T> on StateProvider<T> {

  /// Adds more expressive way to access Riverpod's
  /// StateProvider writable state notifier
  StateController writable(WidgetRef ref) => ref.read(notifier);
}

extension FutureProviderEx<T> on FutureProvider<T> {

  Future<T> getUnwatchedFuture(WidgetRef ref) =>
      ref.read(future);

  AsyncValue<T> watch(WidgetRef ref) =>
      ref.watch(this);

  AsyncValue<T> getUnwatched(WidgetRef ref) =>
      ref.read(this);
}