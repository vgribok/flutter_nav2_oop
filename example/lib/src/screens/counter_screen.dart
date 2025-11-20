import 'package:example/src/routing/counter_path.dart';
import 'package:example/src/dal/counter_data_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

class CounterScreen extends TabNavScreen {

  const CounterScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
      {super.key})
      : super(screenTitle: "Counter");

  @override
  RoutePath get routePath => CounterPath();


  Widget _buildFloatingActionButton(BuildContext context, WidgetRef ref) =>
      FloatingActionButton(
          onPressed: () => CounterDataAccess.increment(ref),
          tooltip: 'Increment',
          foregroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.primary,
          child: const Icon(Icons.add)
      );

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final count = CounterDataAccess.getValue(ref);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context, ref),
    );
  }
}