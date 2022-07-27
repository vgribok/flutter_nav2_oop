import 'package:flutter_nav2_oop/all.dart';
import 'package:geolocator/geolocator.dart';
import 'package:native_exif/native_exif.dart';

extension ExifEx on Exif {
  Disposable dispose() => DisposableThing(close);
}

List<MapEntry<String, Object>> printExifData(String message, Map<String, Object>? rawExifData) {
  if (rawExifData == null) {
    "No EXIF information found".debugPrint();
    return [];
  }

  "---- EXIF data $message ----".debugPrint();

  final List<MapEntry<String, Object>> exifData =
  rawExifData.sortByKey((k0, k1) => k0.compareTo(k1));

  for (final entry in exifData) {
    "${entry.key}: ${entry.value} (${entry.value.runtimeType})".debugPrint();
  }
  "---- End of EXIF data $message ----".debugPrint();

  return exifData;
}

extension PositionEx on Position {
  Map<String, Object> toIosExif() {

    // final DateTime? local = timestamp?.toLocal();

    return {
      // "UserComment": "This file is user generated at $local",
      "GPSLatitude": latitude, //dec2DMS(latitude),
      "GPSLongitude": longitude, //dec2DMS(longitude),
      "GPSAltitude": altitude,
      "GPSImgDirection": heading,
      "GPSSpeed": speed,
      // if(local != null)
      //   "GPSDateStamp": "${local.year}:${local.month.toString().padLeft(2,'0')}:${local.day.toString().padLeft(2,'0')}",
      // if(local != null)
      //   "GPSTimeStamp": "${local.hour.toString().padLeft(2,'0')}:${local.minute.toString().padLeft(2,'0')}:${local.second.toString().padLeft(2,'0')}",
    };
  }

  // /// returns ref for latitude which is S or N.
  // /// @param latitude
  // /// @return S or N
  // static String latitudeRef(double latitude) {
  //   return latitude < 0.0 ? "S":"N";
  // }
  //
  // /// returns ref for latitude which is S or N.
  // /// @param latitude
  // /// @return S or N
  // static String longitudeRef(double longitude) {
  //   return longitude < 0.0 ? "W":"E";
  // }
  //
  // /// convert latitude into DMS (degree minute second) format. For instance<br/>
  // /// -79.948862 becomes<br/>
  // ///  79/1,56/1,55903/1000<br/>
  // /// It works for latitude and longitude<br/>
  // /// @param latitude could be longitude.
  // /// @return
  // static String dec2DMS(double coordinate) {
  //   coordinate = coordinate > 0 ? coordinate : -coordinate;
  //   String sOut = "${coordinate.toInt()}/1,";
  //   coordinate = (coordinate % 1) * 60;
  //   sOut = "$sOut${coordinate.toInt()}/1,";
  //   coordinate = (coordinate % 1) * 60000;
  //   sOut = "$sOut${coordinate.toInt()}/1000";
  //   return sOut;
  // }
}