import 'package:example/src/providers/settings_provider.dart' as providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDataAccess {
  static bool shouldShowDialog(WidgetRef ref) => 
      ref.watch(providers.restorableShowSettingsDialogProvider).value;
  
  static void showDialog(WidgetRef ref) => 
      ref.read(providers.restorableShowSettingsDialogProvider).value = true;
  
  static void hideDialog(WidgetRef ref) => 
      ref.read(providers.restorableShowSettingsDialogProvider).value = false;

  static List<NotifierProvider> get ephemerals => [
    providers.restorableShowSettingsDialogProvider,
  ];
}

final settingsProvider = SettingsDataAccess();
