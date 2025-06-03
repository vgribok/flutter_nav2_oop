// ignore_for_file: subtype_of_sealed_class

part of '../../all.dart';

abstract class IProviderListenableEx<T> {

  ProviderListenable<T> get provider;

  T watchValue(WidgetRef ref) => provider.watchValue(ref);
  T readValue(WidgetRef ref) => provider.readValue(ref);
  T watchValue2(Ref ref) => provider.watchValue2(ref);
  T readValue2(Ref ref) => provider.readValue2(ref);
}

class BetterStateProvider<T> extends StateProvider<T> with IProviderListenableEx<T> {
  BetterStateProvider(super.createFn);

  @override
  ProviderListenable<T> get provider => this;
}

extension StateProviderEx<T> on StateProvider<T> {
  StateController<T> writable(WidgetRef ref) => ref.read(notifier);
  StateController<T> writable2(Ref ref) => ref.read(notifier);

  void setValue(WidgetRef ref, T newValue) => writable(ref).state = newValue;
  void setValue2(Ref ref, T newValue) => writable2(ref).state = newValue;
}

extension ProviderListenableEx<T> on ProviderListenable<T> {
  T watchValue(WidgetRef ref) => ref.watch(this);
  T readValue(WidgetRef ref) => ref.read(this);
  T readValue2(Ref ref) => ref.read(this);
  T watchValue2(Ref ref) => ref.watch(this);
}

extension FutureProviderEx<T> on FutureProvider<T> {

  Future<T> watchFuture(WidgetRef ref) => future.watchValue(ref);
  Future<T> readFuture(WidgetRef ref) => future.readValue(ref);
  Future<T> watchFuture2(Ref ref) => future.watchValue2(ref);
  Future<T> readFuture2(Ref ref) => future.readValue2(ref);

  AsyncValue<T> watchAsyncValue(WidgetRef ref) => ref.watch(this);
  AsyncValue<T> readAsyncValue(WidgetRef ref) => ref.read(this);
  AsyncValue<T> watchAsyncValue2(Ref ref) => ref.watch(this);
  AsyncValue<T> readAsyncValue2(Ref ref) => ref.read(this);

  T? watchValue(WidgetRef ref) => watchAsyncValue(ref).valueOrNull;
  T? readValue(WidgetRef ref) => readAsyncValue(ref).valueOrNull;
  T? watchValue2(Ref ref) => watchAsyncValue2(ref).valueOrNull;
  T? readValue2(Ref ref) => readAsyncValue2(ref).valueOrNull;
}

extension ProviderOrFamilyEx on ProviderOrFamily {
  void invalidate(WidgetRef ref) => ref.invalidate(this);
  void invalidate2(Ref ref) => ref.invalidate(this);
}

extension RefreshableEx<T> on Refreshable<T> {
  T refresh(WidgetRef ref) => ref.refresh(this);
  T refresh2(Ref ref) => ref.refresh(this);
}

class RestorableEnumProviderFacadeN<T> {
  final RestorableProvider<RestorableEnumN<T>> restorableProvider;

  RestorableEnumProviderFacadeN(Iterable<T> enumValues, {T? initialValue, required String restorationId}) :
        restorableProvider = RestorableProvider<RestorableEnumN<T>>(
            (ref) => RestorableEnumN<T>(enumValues, initialValue),
            restorationId: restorationId
        );

  T? watchValue(WidgetRef ref) => ref.watch(restorableProvider).enumValue;
  T? readValue(WidgetRef ref) => ref.read(restorableProvider).enumValue;
  void setValue(WidgetRef ref, T? val) => ref.read(restorableProvider).enumValue = val;
  T? watchValue2(Ref ref) => ref.watch(restorableProvider).enumValue;
  T? readValue2(Ref ref) => ref.read(restorableProvider).enumValue;
  void setValue2(Ref ref, T? val) => ref.read(restorableProvider).enumValue = val;
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