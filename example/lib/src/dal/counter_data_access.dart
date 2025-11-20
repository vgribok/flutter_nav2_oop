import 'package:example/src/providers/counter_provider.dart' as providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterDataAccess {
  static int getValue(WidgetRef ref) => 
      ref.watch(providers.restorableCounterProvider).value;
  
  static void increment(WidgetRef ref) => 
      ref.read(providers.restorableCounterProvider).value++;
  
  static void decrement(WidgetRef ref) => 
      ref.read(providers.restorableCounterProvider).value--;

  static List<NotifierProvider> get ephemerals => [
    providers.restorableCounterProvider,
  ];
}

final counterProvider = CounterDataAccess();
