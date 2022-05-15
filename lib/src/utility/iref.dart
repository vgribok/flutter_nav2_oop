// part of flutter_nav2_oop;
//
// abstract class IRef {
//   /// Returns the value exposed by a provider and rebuild the widget when that
//   /// value changes.
//   ///
//   /// See also:
//   ///
//   /// - [ProviderBase.select], which allows a widget to filter rebuilds by
//   ///   observing only the properties.
//   /// - [listen], to react to changes on a provider, such as for showing modals.
//   T watch<T>(ProviderListenable<T> provider);
//
//   /// Listen to a provider and call `listener` whenever its value changes.
//   ///
//   /// This is useful for showing modals or other imperative logic.
//   void listen<T>(
//       ProviderListenable<T> provider,
//       void Function(T? previous, T next) listener, {
//         void Function(Object error, StackTrace stackTrace)? onError,
//       });
//
//   /// Reads a provider without listening to it.
//   ///
//   /// **AVOID** calling [read] inside build if the value is used only for events:
//   ///
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   ///   // counter is used only for the onPressed of RaisedButton
//   ///   final counter = ref.read(counterProvider);
//   ///
//   ///   return RaisedButton(
//   ///     onPressed: () => counter.increment(),
//   ///   );
//   /// }
//   /// ```
//   ///
//   /// While this code is not bugged in itself, this is an anti-pattern.
//   /// It could easily lead to bugs in the future after refactoring the widget
//   /// to use `counter` for other things, but forget to change [read] into [Consumer]/`ref.watch(`.
//   ///
//   /// **CONSIDER** calling [read] inside event handlers:
//   ///
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   ///   return RaisedButton(
//   ///     onPressed: () {
//   ///       // as performant as the previous solution, but resilient to refactoring
//   ///       ref.read(counterProvider).increment(),
//   ///     },
//   ///   );
//   /// }
//   /// ```
//   ///
//   /// This has the same efficiency as the previous anti-pattern, but does not
//   /// suffer from the drawback of being brittle.
//   ///
//   /// **AVOID** using [read] for creating widgets with a value that never changes
//   ///
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   ///   // using read because we only use a value that never changes.
//   ///   final model = ref.read(modelProvider);
//   ///
//   ///   return Text('${model.valueThatNeverChanges}');
//   /// }
//   /// ```
//   ///
//   /// While the idea of not rebuilding the widget if unnecessary is good,
//   /// this should not be done with [read].
//   /// Relying on [read] for optimisations is very brittle and dependent
//   /// on an implementation detail.
//   ///
//   /// **CONSIDER** using [Provider] or `select` for filtering unwanted rebuilds:
//   ///
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   ///   // Using select to listen only to the value that used
//   ///   final valueThatNeverChanges = ref.watch(modelProvider.select((model) {
//   ///     return model.valueThatNeverChanges;
//   ///   }));
//   ///
//   ///   return Text('$valueThatNeverChanges');
//   /// }
//   /// ```
//   ///
//   /// While more verbose than [read], using [Provider]/`select` is a lot safer.
//   /// It does not rely on implementation details on `Model`, and it makes
//   /// impossible to have a bug where our UI does not refresh.
//   T read<T>(ProviderBase<T> provider);
//
//   /// Forces a provider to re-evaluate its state immediately, and return the created value.
//   ///
//   /// This method is useful for features like "pull to refresh" or "retry on error",
//   /// to restart a specific provider.
//   ///
//   /// For example, a pull-to-refresh may be implemented by combining
//   /// [FutureProvider] and a [RefreshIndicator]:
//   ///
//   /// ```dart
//   /// final productsProvider = FutureProvider((ref) async {
//   ///   final response = await httpClient.get('https://host.com/products');
//   ///   return Products.fromJson(response.data);
//   /// });
//   ///
//   /// class Example extends ConsumerWidget {
//   ///   @override
//   ///   Widget build(BuildContext context, WidgetRef ref) {
//   ///     final Products products = ref.watch(productsProvider);
//   ///
//   ///     return RefreshIndicator(
//   ///       onRefresh: () => ref.refresh(productsProvider),
//   ///       child: ListView(
//   ///         children: [
//   ///           for (final product in products.items) ProductItem(product: product),
//   ///         ],
//   ///       ),
//   ///     );
//   ///   }
//   /// }
//   /// ```
//   State refresh<State>(ProviderBase<State> provider);
// }
//
// class ProviderIRef extends IRef {
//   final Ref ref;
//
//   ProviderIRef(this.ref);
//
//   @override
//   void listen<T>(ProviderListenable<T> provider,
//       void Function(T? previous, T next) listener,
//       {
//         void Function(Object error, StackTrace stackTrace)? onError
//       }
//   ) =>
//     ref.listen(provider as AlwaysAliveProviderListenable<T>, listener, onError: onError);
//
//   @override
//   T read<T>(ProviderBase<T> provider) => ref.read(provider);
//
//   @override
//   State refresh<State>(ProviderBase<State> provider) => ref.refresh(provider);
//
//   @override
//   T watch<T>(ProviderListenable<T> provider) =>
//       ref.watch(provider as AlwaysAliveProviderListenable<T>);
// }
//
// class WidgetIRef extends IRef {
//   final WidgetRef ref;
//
//   WidgetIRef(this.ref);
//
//   @override
//   void listen<T>(ProviderListenable<T> provider,
//     void Function(T? previous, T next) listener,
//     {
//       void Function(Object error, StackTrace stackTrace)? onError
//     }) =>
//       ref.listen(provider, listener, onError: onError);
//
//   @override
//   T read<T>(ProviderBase<T> provider) => ref.read(provider);
//
//   @override
//   State refresh<State>(ProviderBase<State> provider) => ref.refresh(provider);
//
//   @override
//   T watch<T>(ProviderListenable<T> provider) => ref.watch(provider);
// }
//
// extension RefEx on Ref {
//   ProviderIRef get iRef => ProviderIRef(this);
// }
//
// extension WidgetRefEx on WidgetRef {
//   WidgetIRef get iRef => WidgetIRef(this);
// }
//
