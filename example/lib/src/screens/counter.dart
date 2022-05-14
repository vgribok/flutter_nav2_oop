import 'package:example/src/routing/counter_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

final counterProvider = RestorableProvider<RestorableInt>(
    (ref) => throw UnimplementedError("Initial value is supplied by the override"),
    restorationId: "counter"
);

class CounterScreen extends NavScreen {
  static const int navTabIndex = 1;

  const CounterScreen(TabNavModel navState, {Key? key})
      : super(screenTitle: "Counter", tabIndex: navTabIndex, navState: navState, key: key);

  @override
  RoutePath get routePath => const CounterPath();

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    RestorableProviderScope(
      restorationId: "counter-scope",
      restorableOverrides: [counterProvider.overrideWithRestorable(RestorableInt(10))],
      child: Consumer(
        builder: (context, ref, child) =>
         Scaffold(
           body: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 const Text('You have pushed the button this many times:'),
                 Text(
                   '${ref.watch(counterProvider).value}',
                   style: Theme.of(context).textTheme.headline4,
                 ),
               ],
             ),
           ),
           floatingActionButton: FloatingActionButton(
             onPressed: () => ref.read(counterProvider).value++,
             tooltip: 'Increment',
             backgroundColor: Theme.of(context).primaryColor,
             child: const Icon(Icons.add),
           )
         )
      )
    );
}