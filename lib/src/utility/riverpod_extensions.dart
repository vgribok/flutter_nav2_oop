part of flutter_nav2_oop;

extension StateProviderEx<T> on StateProvider<T> {

  /// More expressive way to access Riverpod's
  /// StateProvider writable state notifier
  StateController<T> writabe<T>(WidgetRef ref) =>
    ref.read(notifier) as StateController<T>;
}