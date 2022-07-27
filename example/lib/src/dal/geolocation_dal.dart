import 'package:example/src/utility/exif_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:native_exif/native_exif.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position?> getGeolocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    'Location services are disabled.'.debugPrint();
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI timestamp.
      "Location permissions are denied".debugPrint();
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    'Location permissions are permanently denied, we cannot request permissions.'.debugPrint();
    return null;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<void> addGeoLocationExifToIosImageFile(String filePath) async {

  final Future<Exif> exifFuture = Exif.fromPath(filePath);

  final Position? geoLocation = await getGeolocation();
  if(geoLocation == null) return;

  Exif? exif;
  try {
    exif = await exifFuture;
    final Map<String, Object> imageExifData = (await exif.getAttributes()) ?? {};

    if (!imageExifData.containsAllKeys(["GPSLatitude", "GPSLongitude"])) {
      // image has no GPS metadata, let's add it.
      // Refactor to use OOP polymorphism to convert data to platform-specific EXIF matadata
      final Map<String, Object> gpsMetadata = geoLocation.toIosExif();
      imageExifData.addAll(gpsMetadata);
      await exif.writeAttributes(imageExifData);

      if(kDebugMode) {
        final Map<String, Object>? newImageExifData = await exif.getAttributes();
        printExifData("in from-camera picture after adding GPS metadata",newImageExifData);
      }
    }
  }
  finally {
    exif?.close();
  }
}
