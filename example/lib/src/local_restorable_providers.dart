import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

// import 'restorable_provider.dart';

class LocalRestorableProviderScope extends ConsumerStatefulWidget {
  const LocalRestorableProviderScope({
    required this.restorationId,
    required this.restorableProviders,
    this.overrides = const [],
    this.observers,
    //this.cacheTime,
    //this.disposeDelay,
    this.parent,
    required this.child,
    Key? key,
  }) : super(key: key);

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String restorationId;
  final List<RestorableProvider> restorableProviders;
  final Widget child;

  final List<Override> overrides;
  final List<ProviderObserver>? observers;
  //final Duration? cacheTime;
  //final Duration? disposeDelay;
  final ProviderContainer? parent;

  @override
  _LocalRestorableProviderScopeState createState() =>
      _LocalRestorableProviderScopeState();
}

class _LocalRestorableProviderScopeState
    extends ConsumerState<LocalRestorableProviderScope> with RestorationMixin {

  @override
  Widget build(BuildContext context) {

    for (final provider in widget.restorableProviders) {
      ref.listen<RestorableProperty?>(provider, (previous, next) {
        if (identical(previous, next)) return;

        if (previous != null) unregisterFromRestoration(previous);
        if (next != null) registerForRestoration(next, provider.restorationId);
      });
    }

    return ProviderScope(
      overrides: [
        ...widget.overrides,
        for (final provider in widget.restorableProviders)
          provider.overrideWithValue(ref.read(provider)),
      ],
      observers: widget.observers,
      //cacheTime: widget.cacheTime,
      //disposeDelay: widget.disposeDelay,
      child: widget.child,
    );
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    for (final provider in widget.restorableProviders) {
      final value = ref.read(provider);
      if (value != null) registerForRestoration(value, provider.restorationId);
    }
  }
}
