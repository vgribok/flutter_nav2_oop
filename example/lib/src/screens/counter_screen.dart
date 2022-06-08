import 'package:example/src/routing/counter_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

class CounterScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  static final _counterProvider = RestorableProvider<RestorableInt>(
      (ref) => RestorableInt(0),
      restorationId: "counter"
  );

  static final List<RestorableProvider> epehmerals = [_counterProvider];

  const CounterScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key})
      : super(screenTitle: "Counter");

  @override
  RoutePath get routePath => CounterPath();

  @override
  @protected
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) =>
      FloatingActionButton(
          onPressed: () => _counterProvider.writable(ref).value++,
          tooltip: 'Increment',
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add)
      );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    Consumer(
        builder: (context, ref, child) =>
           Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 const Text('You have pushed the button this many times:'),
                 Text(
                   '${ref.watch(_counterProvider).value}',
                   style: Theme.of(context).textTheme.headline4,
                 ),
               ],
             ),
           )
    );
}