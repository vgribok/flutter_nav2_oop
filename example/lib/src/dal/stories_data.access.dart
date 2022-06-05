import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryDal
{
  /// Pseudo-data-access call emulating remote API invocation
  static Future<List<Story>> _getStories() async {
    // Simulate long-ish API call
    await Future.delayed(const Duration(milliseconds: 750));

    // throw StateError("Failed to fetch stories from the API");

    return [
      const Story(id: 1,
          defaultDuration: 3.0,
          bubble: Bubble(
            imageURL: "https://pbs.twimg.com/profile_images/2699103767/1e9cec7a8399310f4902cfff9d32f14c_400x400.jpeg",
            text: "That's my life",
          ),
          pages:
          [
            StoryPage(id: 111,
                imageURL: "https://avatars.githubusercontent.com/u/757185?v=4",
                duration: 5.0
            ),
            StoryPage(
                imageURL: "https://i.pinimg.com/280x280_RS/ef/8c/bf/ef8cbf4d97e552e8e49a5b3972faabed.jpg",
                id: 222
            ),
            StoryPage(
                imageURL: "https://media-exp1.licdn.com/dms/image/C4E16AQEfgvakWxTjtQ/profile-displaybackgroundimage-shrink_200_800/0/1647441210890?e=1658966400&v=beta&t=FCzLYG22wJ8dSpqaSySk939n23ka9kGK8aIDkvqt9zI",
                id: 333
            )
          ]
      )
    ];
  }

  static final _storiesProvider = FutureProvider.autoDispose<List<Story>>(
      (ref) => _getStories()
  );

  static AsyncValue<List<Story>> watchStoryList(WidgetRef ref) =>
    ref.watch(_storiesProvider);

  static List<Story> getStoryList(WidgetRef ref) =>
    ref.read(_storiesProvider).value ?? [];

  static bool isValidStory(WidgetRef ref, int storyId, int? pageId) {
    final Story? story = getStoryList(ref).firstSafe((s) => s.id == storyId);
    if(story == null) return false;
    if(pageId == null) return true;
    return story.pages.any((p) => p.id == pageId);
  }

  static Story? getStory(WidgetRef ref, int? storyId) =>
      storyId == null ? null : getStoryList(ref).firstSafe((story) => story.id == storyId);

  static final RestorableProvider<RestorableIntN> currentStoryIdProvider = RestorableProvider(
          (ref) => RestorableIntN(null),
      restorationId: "current-story-id"
  );

  static RestorableIntN selectedStoryId(WidgetRef ref) =>
      ref.read(currentStoryIdProvider);

  static int? watchSelectedStoryId(WidgetRef ref) =>
      ref.watch(currentStoryIdProvider).value;

  static Story? watchSelectedStory(WidgetRef ref, {List<Story>? stories}) {
    final int? selectedStoryId = watchSelectedStoryId(ref);
    if(selectedStoryId == null) {
      return null;
    }

    stories ??= watchStoryList(ref).value;
    return stories?.firstSafe((story) => story.id == selectedStoryId);
  }

  static final RestorableProvider<RestorableIntN> currentPageIdProvider = RestorableProvider(
      (ref) => RestorableIntN(null),
      restorationId: "current-page-id"
  );

  static RestorableIntN currentPageId(WidgetRef ref) =>
      ref.read(currentPageIdProvider);

  static StoryPage? watchCurrentPage(WidgetRef ref, List<StoryPage> pages) {
    final int? currentPageId = ref.watch(currentPageIdProvider).value;
    if(currentPageId == null) return null;

    return pages.firstSafe((page) => page.id == currentPageId);
  }

  static int? currentPageIndex(WidgetRef ref, List<StoryPage> pages) {
    final int? pageId = currentPageId(ref).value;
    if(pageId == null) return null;
    return pages.indexWhere((page) => page.id == pageId);
  }

  static void moveToNextStoryPage(WidgetRef ref, List<StoryPage> pages) {

    if(pages.isEmpty) {
      currentPageId(ref).value = null;
      return;
    }

    int pageIndex = currentPageIndex(ref, pages) ?? -1;
    pageIndex++;

    if(pageIndex >= pages.length) {
      pageIndex = 0;
    }
    currentPageId(ref).value = pages[pageIndex].id;
  }

  static void selectStory(WidgetRef ref, Story? story) {
    selectedStoryId(ref).value = story?.id;
    if(story == null) {
      currentPageId(ref).value = null;
      return;
    }
    moveToNextStoryPage(ref, story.pages);
  }

  static void selectStoryId(WidgetRef ref, int? storyId) {

    Story? story;

    if(storyId != null) {
      final stories = getStoryList(ref);
      story = stories.firstSafe((story) => story.id == storyId);
    }

    selectStory(ref, story);
  }
}