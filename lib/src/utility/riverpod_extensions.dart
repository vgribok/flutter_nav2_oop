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

  AsyncValue<T> refresh(WidgetRef ref) => ref.refresh(this);
  AsyncValue<T> refresh2(Ref ref) => ref.refresh(this);

  T? watchForValue2(Ref ref) =>
      watchAsyncValue2(ref).value;

  T? getUnwatchedValue2(Ref ref) =>
      getUnwatchedAsyncValue2(ref).value;

  void invalidate(WidgetRef ref) => ref.invalidate(this);
  void invalidate2(Ref ref) => ref.invalidate(this);
}

class RestorableEnumProviderFacadeN<T> {
  final RestorableProvider<RestorableEnumN<T>> restorableProvider;

  RestorableEnumProviderFacadeN(Iterable<T> enumValues, {T? initialValue, required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableEnumN<T>>(
            (ref) => RestorableEnumN<T>(enumValues, initialValue),
            restorationId: restorationId
        );

  T? watchValue(WidgetRef ref) =>
      ref.watch(restorableProvider).enumValue;
  T? readValue(WidgetRef ref) =>
      ref.read(restorableProvider).enumValue;
  void setValue(WidgetRef ref, T? val) =>
      ref.read(restorableProvider).enumValue = val;

  T? watchValue2(Ref ref) =>
      ref.watch(restorableProvider).enumValue;
  T? readValue2(Ref ref) =>
      ref.read(restorableProvider).enumValue;
  void setValue2(Ref ref, T? val) =>
      ref.read(restorableProvider).enumValue = val;
}

class RestorableEnumProviderFacade<T> {
  final RestorableProvider<RestorableEnum<T>> restorableProvider;

  RestorableEnumProviderFacade(Iterable<T> enumValues, {required T initialValue, required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableEnum<T>>(
            (ref) => RestorableEnum<T>(enumValues, initialValue),
            restorationId: restorationId
        );

  T? watchValue(WidgetRef ref) =>
      ref.watch(restorableProvider).enumValue;
  T? readValue(WidgetRef ref) =>
      ref.read(restorableProvider).enumValue;
  void setValue(WidgetRef ref, T val) =>
      ref.read(restorableProvider).enumValue = val;

  T? watchValue2(Ref ref) =>
      ref.watch(restorableProvider).enumValue;
  T? readValue2(Ref ref) =>
      ref.read(restorableProvider).enumValue;
  void setValue2(Ref ref, T val) =>
      ref.read(restorableProvider).enumValue = val;
}

class RestorableStringProviderFacadeN {
  final RestorableProvider<RestorableStringN> restorableProvider;

  RestorableStringProviderFacadeN({String? initialValue, required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableStringN>(
            (ref) => RestorableStringN(initialValue),
            restorationId: restorationId
        );

  String? watchValue(WidgetRef ref) =>
      ref.watch(restorableProvider).value;
  String? readValue(WidgetRef ref) =>
      ref.read(restorableProvider).value;
  void setValue(WidgetRef ref, String? val) =>
      ref.read(restorableProvider).value = val;
  void mutate(WidgetRef ref, String? Function(String?) updater) =>
      setValue(ref, updater(readValue(ref)));

  String? watchValue2(Ref ref) =>
      ref.watch(restorableProvider).value;
  String? readValue2(Ref ref) =>
      ref.read(restorableProvider).value;
  void setValue2(Ref ref, String? val) =>
      ref.read(restorableProvider).value = val;
  void mutate2(Ref ref, String? Function(String?) updater) =>
      setValue2(ref, updater(readValue2(ref)));
}

class RestorableStringProviderFacade {
  final RestorableProvider<RestorableString> restorableProvider;

  RestorableStringProviderFacade(String initialValue, {required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableString>(
            (ref) => RestorableString(initialValue),
            restorationId: restorationId
        );

  String watchValue(WidgetRef ref) =>
      ref.watch(restorableProvider).value;
  String readValue(WidgetRef ref) =>
      ref.read(restorableProvider).value;
  void setValue(WidgetRef ref, String val) =>
      ref.read(restorableProvider).value = val;
  void mutate(WidgetRef ref, String Function(String) updater) =>
      setValue(ref, updater(readValue(ref)));

  String watchValue2(Ref ref) =>
      ref.watch(restorableProvider).value;
  String readValue2(Ref ref) =>
      ref.read(restorableProvider).value;
  void setValue2(Ref ref, String val) =>
      ref.read(restorableProvider).value = val;
  void mutate2(Ref ref, String Function(String) updater) =>
      setValue2(ref, updater(readValue2(ref)));
}
class RestorableIntProviderFacadeN {
  final RestorableProvider<RestorableIntN> restorableProvider;

  RestorableIntProviderFacadeN({int? initialValue, required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableIntN>(
            (ref) => RestorableIntN(initialValue),
            restorationId: restorationId
        );

  int? watchValue(WidgetRef ref) =>
      ref.watch(restorableProvider).value;
  int? readValue(WidgetRef ref) =>
      ref.read(restorableProvider).value;
  void setValue(WidgetRef ref, int? val) =>
      ref.read(restorableProvider).value = val;
  void mutate(WidgetRef ref, int? Function(int?) updater) =>
      setValue(ref, updater(readValue(ref)));

  int? watchValue2(Ref ref) =>
      ref.watch(restorableProvider).value;
  int? readValue2(Ref ref) =>
      ref.read(restorableProvider).value;
  void setValue2(Ref ref, int? val) =>
      ref.read(restorableProvider).value = val;
  void mutate2(Ref ref, int? Function(int?) updater) =>
      setValue2(ref, updater(readValue2(ref)));
}

class RestorableIntProviderFacade {
  final RestorableProvider<RestorableInt> restorableProvider;

  RestorableIntProviderFacade(int initialValue, {required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableInt>(
            (ref) => RestorableInt(initialValue),
            restorationId: restorationId
        );

  int watchValue(WidgetRef ref) =>
      ref.watch(restorableProvider).value;
  int readValue(WidgetRef ref) =>
      ref.read(restorableProvider).value;
  void setValue(WidgetRef ref, int val) =>
      ref.read(restorableProvider).value = val;
  void mutate(WidgetRef ref, int Function(int) updater) =>
      setValue(ref, updater(readValue(ref)));

  int watchValue2(Ref ref) =>
      ref.watch(restorableProvider).value;
  int readValue2(Ref ref) =>
      ref.read(restorableProvider).value;
  void setValue2(Ref ref, int val) =>
      ref.read(restorableProvider).value = val;
  void mutate2(Ref ref, int Function(int) updater) =>
      setValue2(ref, updater(readValue2(ref)));
}