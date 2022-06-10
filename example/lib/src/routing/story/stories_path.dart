import 'package:example/src/dal/stories_data_access.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoriesPath extends RoutePath {
  static const String resourceName = 'stories';

  StoriesPath() : super(resource: resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? StoriesPath() : null;

  @override
  bool configureStateFromUri(WidgetRef ref) {
    Stories.setCurrentStory(ref, null);
    return true;
  }
}
