import 'package:example/src/routing/counter_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

final counterProvider = RestorableProvider<RestorableInt>(
    (ref) => RestorableInt(0),
    restorationId: "counter"
);

class CounterScreen extends NavScreen {
  static const int navTabIndex = 1;

  const CounterScreen(NavAwareState navState, {Key? key})
      : super(screenTitle: "Counter", tabIndex: navTabIndex, navState: navState, key: key);

  @override
  Widget buildBody(BuildContext context) =>
      RestorableProviderScope(
          restorationId: "counter-scope",
          restorableOverrides: [counterProvider.overrideWithRestorable(RestorableInt(0))],
          child: const CounterWidget()
      );

  @override
  RoutePath get routePath => const CounterPath();
}

class CounterWidget extends ConsumerWidget {

  const CounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final RestorableInt counter = ref.watch(counterProvider);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return
      Scaffold(
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${counter.value}',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4,
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
      );
  }
}