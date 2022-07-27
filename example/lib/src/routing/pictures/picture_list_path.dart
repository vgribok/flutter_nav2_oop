import 'package:example/src/dal/books_data_access.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PictureListPath extends RoutePath {
  static const String resourceName = 'pictures';

  PictureListPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? PictureListPath() : null;

  @override
  bool configureStateFromUri(WidgetRef ref) {
    booksProvider.setSelectedBook(ref, null);
    return true;
  }
}
