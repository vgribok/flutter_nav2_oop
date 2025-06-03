import 'package:example/src/routing/counter_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

class CounterScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  static final _counterProvider = RestorableIntProviderFacade(0, restorationId:  "counter");

  static final List<RestorableProvider> ephemerals = [_counterProvider.restorableProvider];

  const CounterScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key})
      : super(screenTitle: "Counter");

  @override
  RoutePath get routePath => CounterPath();


  Widget _buildFloatingActionButton(BuildContext context, WidgetRef ref) =>
      FloatingActionButton(
          onPressed: () => _counterProvider.mutate(ref, (n) => n+1),
          tooltip: 'Increment',
          foregroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.primary,
          child: const Icon(Icons.add)
      );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    Scaffold(
      body: Consumer(
        builder: (context, ref, child) =>
           Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 const Text('You have pushed the button this many times:'),
                 Text(
                   '${_counterProvider.watchValue(ref)}',
                   style: Theme.of(context).textTheme.headlineLarge,
                 ),
               ],
             ),
           )
      ),
      floatingActionButton: _buildFloatingActionButton(context, ref) ,
    );
}