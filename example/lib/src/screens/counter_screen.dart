import 'package:example/src/routing/counter_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

class CounterScreen extends NavScreen {
  static const int navTabIndex = 1;

  static final counterProvider = RestorableProvider<RestorableInt>(
          (ref) => RestorableInt(0),
      restorationId: "counter"
  );


  const CounterScreen({super.key})
      : super(
          screenTitle: "Counter",
          tabIndex: navTabIndex,
        );

  @override
  RoutePath get routePath => const CounterPath();

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    Consumer(
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
    );
}