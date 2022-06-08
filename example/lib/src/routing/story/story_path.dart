import 'package:example/src/dal/stories_data.access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:example/src/routing/story/stories_path.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Can be "/stories/123" or "/stories/123/page/456"
class StoryPath extends NestedRoutePath {

  static const String resourceName = "page";

  final int storyId;
  final int? pageId;

  StoryPath({required this.storyId, this.pageId}) : super(_argsToMap(storyId, pageId));

  static Map<String, String> _argsToMap(int storyId, int? pageId)
  {
    final map = <String,String>{ StoriesPath.resourceName: storyId.toString() };
    if(pageId != null) {
      map[resourceName] = pageId.toString();
    }
    return map;
  }

  static RoutePath? fromUri(Uri uri) {
    Map<String, String>? map = uri.segmentsFromUri([ StoriesPath.resourceName, resourceName ]);
    int? pageId;
    if(map == null) {
      map = uri.segmentsFromUri([ StoriesPath.resourceName]);
      if(map == null) return null;
    }else {
      pageId = int.tryParse(map[resourceName] ?? "");
      if(pageId == null) return null;
    }
    int? storyId = int.tryParse(map[StoriesPath.resourceName] ?? "");
    return storyId == null ? null : StoryPath(storyId: storyId, pageId: pageId);
  }

  @override
  Future<bool> configureStateFromUriFuture(WidgetRef ref) async {

    final Stories stories = await Stories.getUnwatchedFuture(ref);
    final Story? story = stories.getById(storyId);
    if(story == null) return false;

    StoryPage? page = story.getPageById(pageId);
    if(page == null) {
      if(pageId != null) return false; // pageId was invalid for the specified story
      if(story.pages.isNotEmpty) {
        page = story[0];
      }
    }

    Stories.setCurrentStory(ref, story);
    StoryEx.setCurrentPage(ref, page);

    return true;
  }
}