
import 'package:flutter_nav2_oop/all.dart';

class PhotoPreviewPath extends RoutePath {

  static const String resourceName = "photo-preview";

  PhotoPreviewPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? PhotoPreviewPath() : null;
}