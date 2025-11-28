import 'package:example/src/providers/counter_provider.dart' as providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterDataAccess {
  // Provider access helpers
  int _watchValue(WidgetRef ref) => 
      ref.watch(providers.restorableCounterProvider).value;
  
  void _modifyValue(WidgetRef ref, int Function(int) modifier) => 
      ref.read(providers.restorableCounterProvider).value = 
          modifier(ref.read(providers.restorableCounterProvider).value);
  
  // Public API
  int getValue(WidgetRef ref) => _watchValue(ref);
  
  void increment(WidgetRef ref) => _modifyValue(ref, (v) => v + 1);
  
  void decrement(WidgetRef ref) => _modifyValue(ref, (v) => v - 1);
}

final counterDal = CounterDataAccess();
