import 'package:flutter/widgets.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';

final restorableShowSettingsDialogProvider = restorableProvider<RestorableBool>(
  create: (ref) => RestorableBool(false),
  restorationId: 'show-settings-dialog',
);
