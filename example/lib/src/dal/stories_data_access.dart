import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storiesProvider = StoriesProvider();

class StoriesProvider extends FutureProviderFacade<List<Story>> {

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
                imageURL: "https://lh3.googleusercontent.com/pw/AM-JKLXwPtGwAM_TreSNFtEl3dMQ8k1Mf2p6KMuB28ikQoEUChDceFywdumf_AoyWkfRnVUI0nhNEANV21hqxpEL1r6XjTjXoQUbofVxPfgdIF6C8qvF0ye_TulFMPrAzODlDxNyrhMnksjf_o4k4GjBcH82Bg=w3544-h1994-no",
                duration: 5.0
            ),
            StoryPage(
                imageURL: "https://pbs.twimg.com/media/E-YezAjXoBMYHCC.jpg",
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

  final RestorableProvider<RestorableIntN> _currentStoryIdProvider = RestorableProvider(
      (ref) => RestorableIntN(null),
      restorationId: "current-story-id"
  );

  List<RestorableProvider> get ephemerals => [_currentStoryIdProvider];

  Story? watchForCurrentStory(WidgetRef ref) {
    final int? currentStoryId = ref.watch(_currentStoryIdProvider).value;
    if(currentStoryId == null) return null;
    final List<Story>? stories = watchForValue(ref);
    return _getById(stories, currentStoryId);
  }

  static Story? _getById(List<Story>? stories, int? storyId) =>
      storyId == null ? null :
          stories?.firstSafe((story) => story.id == storyId);

  static int? indexOf(List<Story> stories, Story? story) {
    if (story == null) return null;
    int index = stories.indexOf(story);
    return index < 0 ? null : index;
  }

  Story? storyAt(List<Story> stories, int? index) =>
      index == null || index < 0 || index >= stories.length ? null : stories[index];

  void setCurrentStory(WidgetRef ref, Story? story) {
    ref.read(_currentStoryIdProvider).value = story?.id;

    if(story != null) {
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

  int getPageDurationMillisec(StoryPage? page) {
    final double durationSeconds = page?.duration ?? defaultDuration;
    return (durationSeconds * 1000).toInt();
  }

  StoryPage? getPageById(int? pageId) =>
      pageId == null ? null :
      pages.firstSafe((page) => page.id == pageId);

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

  static void setCurrentPage(WidgetRef ref, StoryPage? page) =>
      _currentPageIdUnwatched(ref).value = page?.id;

  static final _nextPageScheduler = CancellableScheduledOperation();

  static void cancelNextPageOperation() => _nextPageScheduler.cancelOperation();

  void scheduleNextStoryPage(WidgetRef ref, StoryPage? currentPage) {
    final int delay = getPageDurationMillisec(currentPage);
    final StoryPage? nPage = nextPage(currentPage, loop: true);
    scheduleStoryPage(ref, delay, nPage);
  }

  void scheduleStoryPage(WidgetRef ref, int delayMillisec, StoryPage? pageToShow) {
    if(pages.isEmpty || pageToShow == null) return;

    _nextPageScheduler.delayOperation(
      Duration(milliseconds: delayMillisec), () => setCurrentPage(ref, pageToShow)
    );
  }

  static Future<bool> validateAndSetCurrentStoryAndPage(WidgetRef ref, int storyId, int? pageId) async {

    final List<Story> stories = await storiesProvider.getUnwatchedFuture(ref);
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
