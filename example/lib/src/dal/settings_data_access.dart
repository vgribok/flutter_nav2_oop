import 'package:example/src/providers/settings_provider.dart' as providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDataAccess {
  // Provider access helpers
  bool _watchShowDialog(WidgetRef ref) => 
      ref.watch(providers.restorableShowSettingsDialogProvider).value;
  
  void _setShowDialog(WidgetRef ref, bool value) => 
      ref.read(providers.restorableShowSettingsDialogProvider).value = value;
  
  // Public API
  bool shouldShowDialog(WidgetRef ref) => _watchShowDialog(ref);
  
  void showDialog(WidgetRef ref) => _setShowDialog(ref, true);
  
  void hideDialog(WidgetRef ref) => _setShowDialog(ref, false);
}

final settingsDal = SettingsDataAccess();
