import 'dart:io';
import 'package:example/src/dal/file_system_dal.dart';
import 'package:example/src/dal/geolocation_dal.dart';
import 'package:example/src/utility/file_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PhotoProvider {
  
  late final Directory appFolder;

  final ImagePicker _picker = ImagePicker();
  bool _usingCamera = false;

  final StateProvider<XFile?> _cameraPictureProvider = StateProvider<XFile?>((ref) => null);

  late final FutureProvider<File?> _newPhotoProvider = FutureProvider<File?>(_getTakenPhoto);

  late final FutureProvider<List<File>> _pictureListProvider = FutureProvider<List<File>>(
      (ref) async {
        final List<File> pictures = await _picturesToShow();
        ref.watch(_newPhotoProvider);
        return pictures;
      }
  );

  late final FutureProvider<XFile?> _preEvictionPictureProvider = FutureProvider<XFile?>(_watchForPreEvictionImage);

  PhotoProvider({required String appDirectory}) :
      appFolder = fileSystemShortcuts.documentsDirectory.subDir(appDirectory);

  Future<void> takePhoto(WidgetRef ref,
    {
      required ImageSource source,
      double? maxWidth,
      double? maxHeight,
      int? imageQuality,
      CameraDevice preferredCameraDevice = CameraDevice.rear
    }) async {
      XFile? imageXFile;
      try {
        _usingCamera = true;
        imageXFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            preferredCameraDevice: preferredCameraDevice
        );
      } on PlatformException catch(e) {
        "Failed to take a photo due to $e".debugPrint();
      }
      finally {
        _usingCamera = false;
      }

      if(imageXFile == null) {
        "Photo taking was CANCELLED".debugPrint();
      }else if(kDebugMode)
      {
        "Photo \"${imageXFile.name}\" of size ${await imageXFile.length()} saved to \"${imageXFile.path}\"".debugPrint();
      }
      _setCachedPhoto(ref, imageXFile);
  }

  AsyncValue<List<File>> watchForPictures(WidgetRef ref) =>
      ref.watch(_pictureListProvider);

  Future<void> deletePhoto(File file, WidgetRef ref) async {
    if(await file.exists()) {
      await file.delete();
      ref.refresh(_pictureListProvider);
    }
  }

  Future<XFile?> _getPictureFromCamera(Ref ref) async {
    final XFile? pictureFromCamera = await ref.watch(_cameraPictureProvider);
    if(pictureFromCamera == null) return null;

    if(Platform.isIOS) {
      try {
        await addGeoLocationExifToIosImageFile(pictureFromCamera.path);
      }
      catch(ex) {
        "Failed to add geolocation to the EXIF metadata of the \"${pictureFromCamera.path}\" due to $ex".debugPrint();
      }
    }

    return pictureFromCamera;
  }

  Future<File?> _getTakenPhoto(Ref ref) async {
    final XFile? cachedPictureFile = await _getPictureFromCamera(ref)
        ?? await ref.watch(_preEvictionPictureProvider.future);

    if(cachedPictureFile == null) return null;

    return await _movePictureFromCacheToAppFolder(cachedPictureFile.path);
  }

  Future<File> _movePictureFromCacheToAppFolder(String xFilePath) async {
    if(! await appFolder.exists()) {
      await appFolder.create();
      "Created image preview directory \"${appFolder.absolute.path}\"".debugPrint();
    }
    assert(await appFolder.exists());

    final File srcFile = File(xFilePath);
    // Generate preview file name
    final String destFileName = "${DateTime.now().toIso8601String()}${srcFile.extension}";
    final String destPath = appFolder.file(destFileName).path;
    File destFile = await srcFile.move(destPath); //  Move from cache folder to ap folder
    assert(await destFile.exists());
    "Moved captured image from \"${srcFile.absolute.path}\" to \"$destPath\"".debugPrint();

    return destFile;
  }

  Stream<File> _picturesToShowStream() => appFolder.allFiles();

  Future<List<File>> _picturesToShow() async {
    if(!await appFolder.exists()) {
      return [];
    }
    final List<File> fileList = await _picturesToShowStream().toList();
    // Sort by modified data in the descendant order
    fileList.sort((file1, file2) => -file1.statSync().modified.compareTo(file2.statSync().modified));
    return fileList;
  }

  /// On Android, camera activity often leads to evicting the
  /// application from memory. After image is taken (or back
  /// button is pressed) the app gets resurrected and it
  /// needs to restore its ephemeral state and pick up
  /// the taken image. Effectively finding the taken image
  /// can be the first thing the app has to do if it found
  /// itself restoring its state from the ephemeral.
  Future<XFile?> _watchForPreEvictionImage(Ref ref) async  {
    try {
      if(!Platform.isAndroid || _usingCamera) return null;
      final LostDataResponse response = await _picker.retrieveLostData();
      return response.file;
    }on Error catch(e) {
      "Error encountered while trying to get an after-eviction image due to \"$e\"".debugPrint();
      // TODO: Research why Restorable Riverpod provider is not done initializing here when the app is resurrected after eviction.
      if(e.runtimeType.toString() == "_CastError") {
        return null;
      }
      rethrow;
    }
  }

  void _setCachedPhoto(WidgetRef ref, XFile? image) {
    if(image != null) {
      ref.refresh(_pictureListProvider);
    }
    ref.refresh(_preEvictionPictureProvider);
    ref.read(_cameraPictureProvider.notifier).state = image;
  }
}
