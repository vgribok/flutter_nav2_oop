import 'package:flutter/material.dart';

class SettingsShowModalState extends ValueNotifier<bool> {

  SettingsShowModalState({bool showModal = false}) : super(showModal);

  bool get showSettingsModal => value;
  set showSettingsModal(bool val) => value = val;
}
