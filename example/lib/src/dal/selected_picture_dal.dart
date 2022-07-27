import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedPictureDal {

  static final RestorableProvider<RestorableStringN> _selectedFileProvider =
    RestorableProvider<RestorableStringN>(
      (ref) => RestorableStringN(null),
      restorationId: "selected-photo"
    );
  static List<RestorableProvider> get ephemerals => [_selectedFileProvider];

  static String? watchForSelectedPhoto(WidgetRef ref) =>
      ref.watch(_selectedFileProvider).value;

  static File? watchForSelectedPhotoFile(WidgetRef ref) {
    final String? selectedPath = watchForSelectedPhoto(ref);
    if(selectedPath == null) {
      return null;
    }
    final File file = File(selectedPath);
    return file.existsSync() ? file: null;
  }

  static void setSelectedPhoto(WidgetRef ref, String? filePath) =>
      ref.read(_selectedFileProvider).value = filePath;
}