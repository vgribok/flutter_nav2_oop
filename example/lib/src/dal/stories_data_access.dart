// ignore_for_file: subtype_of_sealed_class

import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

final storiesProvider = StoriesProvider();

class StoriesProvider extends FutureProvider<List<Story>> {

  StoriesProvider(): super((ref) => _callStoriesApi());

  /// Pseudo-data-access call emulating remote API invocation
  static Future<List<Story>> _callStoriesApi() async {
    // Simulate long-ish API call
    await Future.delayed(const Duration(milliseconds: 750));

    // throw StateError("Failed to fetch stories from the API");

    return [
      const Story(id: 1,
          defaultDuration: 2.0,
          bubble: Bubble(
            imageURL: "https://pbs.twimg.com/profile_images/2699103767/1e9cec7a8399310f4902cfff9d32f14c_400x400.jpeg",
            text: "That's my life",
          ),
          pages:
          [
            StoryPage(id: 111,
                imageURL: "https://3.bp.blogspot.com/-m6HW6cJbrZM/VoybblszDqI/AAAAAAAAYVU/t3pwGleRTosr5tVl7AgynRVvxFYofLVaQCKgB/w1200-h630-p-k-no-nu/IMG_4735.jpg",
                duration: 5.0
            ),
            StoryPage(
                imageURL: "https://pbs.twimg.com/media/E-YezAjXoBMYHCC.jpg",
                id: 222
            ),
            StoryPage(
                imageURL: "https://m.media-amazon.com/images/W/WEBP_402378-T1/images/I/41uPfg7sAxL._AC_SX679_.jpg",
                id: 333
            )
          ]
      )
    ];
  }

  final _currentStoryIdProvider = RestorableIntProviderFacadeN(
      restorationId: "current-story-id"
  );

  List<RestorableProvider> get ephemerals => [_currentStoryIdProvider.restorableProvider];

  Story? watchForCurrentStory(WidgetRef ref) {
    final int? currentStoryId = _currentStoryIdProvider.watchValue(ref);
    if(currentStoryId == null) return null;
    final List<Story>? stories = watchValue(ref);
    return _getById(stories, currentStoryId);
  }

  static Story? _getById(List<Story>? stories, int? storyId) =>
      storyId == null ? null :
      stories?.firstSafeWhere((story) => story.id == storyId);

  static int? indexOf(List<Story> stories, Story? story) {
    if (story == null) return null;
    int index = stories.indexOf(story);
    return index < 0 ? null : index;
  }

  Story? storyAt(List<Story> stories, int? index) =>
      index == null || index < 0 || index >= stories.length ? null : stories[index];

  void setCurrentStory(WidgetRef ref, Story? story) {
    _currentStoryIdProvider.setValue(ref, story?.id);

    if(story == null) {
      StoryEx.cancelNextPageOperation();
    }else {
      final int? currentPageId = StoryEx._currentPageIdUnwatched(ref).value;
      final StoryPage? currentPage = story.getPageById(currentPageId) ?? story[0];
      StoryEx.setCurrentPage(ref, currentPage);
    }
  }
}

extension StoryEx on Story {

  static final RestorableProvider<
      RestorableIntN> _currentPageIdProvider = RestorableProvider(
          (ref) => RestorableIntN(null),
      restorationId: "current-page-id"
  );

  static List<RestorableProvider> get ephemerals => [_currentPageIdProvider];

  static StoryPage? watchForCurrentPage(WidgetRef ref) {
    final int? currentPageId = ref.watch(_currentPageIdProvider).value;
    if (currentPageId == null) return null;
    final Story? currentStory = storiesProvider.watchForCurrentStory(ref);
    return currentStory?.getPageById(currentPageId);
  }

  int getPageDurationMilliseconds(StoryPage? page) {
    final double durationSeconds = page?.duration ?? defaultDuration;
    return (durationSeconds * 1000).toInt();
  }

  StoryPage? getPageById(int? pageId) =>
      pageId == null ? null :
      pages.firstSafeWhere((page) => page.id == pageId);

  int? indexOf(StoryPage? page) {
    if (page == null) return null;
    final int index = pages.indexOf(page);
    return index < 0 ? null : index;
  }

  StoryPage? nextPage(StoryPage? page,{ bool loop = true }) {
    if(pages.isEmpty) return null;
    int nextPageIndex = (indexOf(page) ?? -1) + 1;
    if(nextPageIndex >= pages.length && loop) {
      nextPageIndex = 0;
    }
    return this[nextPageIndex];
  }

  StoryPage? operator [](int? index) =>
      index == null || index < 0 || index >= pages.length ? null : pages[index];

  static RestorableIntN _currentPageIdUnwatched(WidgetRef ref) =>
      ref.read(_currentPageIdProvider);

  static void setCurrentPage(WidgetRef ref, StoryPage? page) {
    _currentPageIdUnwatched(ref).value = page?.id;
    cancelNextPageOperation();
  }

  static CancellationToken? _cancellationToken;

  static void cancelNextPageOperation() {
    _cancellationToken?.cancel();
    _cancellationToken = null;
  }

  void scheduleNextStoryPage(WidgetRef ref, StoryPage? currentPage) {
    final int delay = getPageDurationMilliseconds(currentPage);
    final StoryPage? nPage = nextPage(currentPage, loop: true);
    scheduleStoryPage(ref, delay, nPage);
  }

  void scheduleStoryPage(WidgetRef ref, int delayMilliseconds, StoryPage? pageToShow) {
    if(pages.isEmpty || pageToShow == null) return;

    cancelNextPageOperation();

    _cancellationToken = CancellationToken();
    final token = _cancellationToken!;
    _cancellationToken!.run(() =>
        Future.delayed(
            Duration(milliseconds: delayMilliseconds),
                () {
              if(!token.isCancelled) setCurrentPage(ref, pageToShow);
            }
        )
    );
  }

  static Future<bool> validateAndSetCurrentStoryAndPage(WidgetRef ref, int storyId, int? pageId) async {

    final List<Story> stories = await storiesProvider.readFuture(ref);
    final Story? story = StoriesProvider._getById(stories, storyId);
    if(story == null) return false;

    StoryPage? page = story.getPageById(pageId);
    if(page == null) {
      if(pageId != null) return false; // pageId was invalid for the specified story
      if(story.pages.isNotEmpty) {
        page = story[0];
      }
    }

    storiesProvider.setCurrentStory(ref, story);
    StoryEx.setCurrentPage(ref, page);

    return true;
  }
}
