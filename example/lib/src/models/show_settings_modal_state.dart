import 'package:flutter/material.dart';

class ShowSettingsModalState extends ValueNotifier<bool> {

  ShowSettingsModalState({bool showModal = false}) : super(showModal);

  bool get showSettingsModal => value;
  set showSettingsModal(bool val) => value = val;
}
