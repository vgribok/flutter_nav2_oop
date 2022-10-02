part of flutter_nav2_oop;

extension StateProviderEx<T> on StateProvider<T> {

  /// Adds more expressive way to access Riverpod's
  /// StateProvider writable state notifier
  StateController writable(WidgetRef ref) => ref.read(notifier);

  T watch(WidgetRef ref) => ref.watch(this);
}

abstract class FutureProviderFacade<T> {

  final FutureProvider<T> provider;

  FutureProviderFacade(FutureOr<T> Function(FutureProviderRef<T> ref) create, {
    String? name,
    List<Provider>? dependencies,
    Family? from,
    Object? argument,
  }) :
    provider = FutureProvider(create, name: name, dependencies: dependencies, from: from, argument: argument);

  Future<T> getUnwatchedFuture(WidgetRef ref) =>
      ref.read(provider.future);

  Future<T> watchFuture(WidgetRef ref) =>
      ref.watch(provider.future);

  AsyncValue<T> watchAsyncValue(WidgetRef ref) =>
      ref.watch(provider);

  AsyncValue<T> getUnwatchedAsyncValue(WidgetRef ref) =>
      ref.read(provider);

  AsyncValue<T> refresh(WidgetRef ref) =>
      ref.refresh(provider);

  T? watchForValue(WidgetRef ref) =>
      watchAsyncValue(ref).value;

  T? getUnwatchedValue(WidgetRef ref) =>
      getUnwatchedAsyncValue(ref).value;


  Future<T> getUnwatchedFuture2(Ref ref) =>
      ref.read(provider.future);

  Future<T> watchFuture2(Ref ref) =>
      ref.watch(provider.future);

  AsyncValue<T> watchAsyncValue2(Ref ref) =>
      ref.watch(provider);

  AsyncValue<T> getUnwatchedAsyncValue2(Ref ref) =>
      ref.read(provider);

  AsyncValue<T> refresh2(Ref ref) =>
      ref.refresh(provider);

  T? watchForValue2(Ref ref) =>
      watchAsyncValue2(ref).value;

  T? getUnwatchedValue2(Ref ref) =>
      getUnwatchedAsyncValue2(ref).value;
}

extension FutureProviderEx<T> on FutureProvider<T> {

  Future<T> getUnwatchedFuture(WidgetRef ref) =>
      ref.read(future);

  Future<T> watchFuture(WidgetRef ref) =>
      ref.watch(future);

  AsyncValue<T> watchAsyncValue(WidgetRef ref) =>
      ref.watch(this);

  AsyncValue<T> getUnwatchedAsyncValue(WidgetRef ref) =>
      ref.read(this);

  AsyncValue<T> refresh(WidgetRef ref) =>
      ref.refresh(this);

  T? watchForValue(WidgetRef ref) =>
      watchAsyncValue(ref).value;

  T? getUnwatchedValue(WidgetRef ref) =>
      getUnwatchedAsyncValue(ref).value;


  Future<T> getUnwatchedFuture2(Ref ref) =>
      ref.read(future);

  Future<T> watchFuture2(Ref ref) =>
      ref.watch(future);

  AsyncValue<T> watchAsyncValue2(Ref ref) =>
      ref.watch(this);

  AsyncValue<T> getUnwatchedAsyncValue2(Ref ref) =>
      ref.read(this);

  AsyncValue<T> refresh2(Ref ref) =>
      ref.refresh(this);

  T? watchForValue2(Ref ref) =>
      watchAsyncValue2(ref).value;

  T? getUnwatchedValue2(Ref ref) =>
      getUnwatchedAsyncValue2(ref).value;
}