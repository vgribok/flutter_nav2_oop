part of flutter_nav2_oop;

extension StateProviderEx<T> on StateProvider<T> {

  /// Adds more expressive way to access Riverpod's
  /// StateProvider writable state notifier
  StateController<T> writable<T>(WidgetRef ref) =>
    ref.read(notifier) as StateController<T>;
}

extension RestorableProviderEx on RestorableProvider {

  /// Adds more expressive way to access Restorable
  /// Riverpod Provider writable state notifier
  RestorableValue<T> writable<T>(WidgetRef ref) =>
      ref.read(this) as RestorableValue<T>;
}