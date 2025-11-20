import 'package:flutter/widgets.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';

final restorableCounterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);
