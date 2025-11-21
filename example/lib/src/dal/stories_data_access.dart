import 'package:example/src/models/stories_models.dart';
import 'package:example/src/providers/stories_provider.dart' as providers;
import 'package:flutter_nav2_oop/all.dart';

class Stories {
  AsyncValue<List<Story>> getStories(WidgetRef ref) => 
      ref.watch(providers.storiesProvider);
  
  Story? watchForCurrentStory(WidgetRef ref) {
    final int? storyId = ref.watch(providers.restorableCurrentStoryIdProvider).value;
    if (storyId == null) return null;
    final stories = ref.watch(providers.storiesProvider).value;
    return _getById(stories, storyId);
  }

  static Story? _getById(List<Story>? stories, int? storyId) =>
      storyId == null ? null : stories?.firstSafeWhere((s) => s.id == storyId);

  void setCurrentStory(WidgetRef ref, Story? story) {
    ref.read(providers.restorableCurrentStoryIdProvider).value = story?.id;
    
    if (story == null) {
      StoryEx.cancelNextPageOperation();
    } else {
      final currentPageId = ref.read(providers.restorableCurrentPageIdProvider).value;
      final currentPage = story.getPageById(currentPageId) ?? story[0];
      StoryEx.setCurrentPage(ref, currentPage);
    }
  }

  void invalidate(WidgetRef ref) => ref.invalidate(providers.storiesProvider);
}

final storiesDal = Stories();

extension StoryEx on Story {
  static CancellationToken? _cancellationToken;

  static StoryPage? watchForCurrentPage(WidgetRef ref) {
    final int? pageId = ref.watch(providers.restorableCurrentPageIdProvider).value;
    if (pageId == null) return null;
    final story = storiesDal.watchForCurrentStory(ref);
    return story?.getPageById(pageId);
  }

  int getPageDurationMilliseconds(StoryPage? page) {
    final duration = page?.duration ?? defaultDuration;
    return (duration * 1000).toInt();
  }

  StoryPage? getPageById(int? pageId) =>
      pageId == null ? null : pages.firstSafeWhere((p) => p.id == pageId);

  int? indexOf(StoryPage? page) {
    if (page == null) return null;
    final index = pages.indexOf(page);
    return index < 0 ? null : index;
  }

  StoryPage? nextPage(StoryPage? page, {bool loop = true}) {
    if (pages.isEmpty) return null;
    int nextIndex = (indexOf(page) ?? -1) + 1;
    if (nextIndex >= pages.length && loop) nextIndex = 0;
    return this[nextIndex];
  }

  StoryPage? operator [](int? index) =>
      index == null || index < 0 || index >= pages.length ? null : pages[index];

  static void setCurrentPage(WidgetRef ref, StoryPage? page) {
    ref.read(providers.restorableCurrentPageIdProvider).value = page?.id;
    cancelNextPageOperation();
  }

  static void cancelNextPageOperation() {
    _cancellationToken?.cancel();
    _cancellationToken = null;
  }

  void scheduleNextStoryPage(WidgetRef ref, StoryPage? currentPage) {
    final delay = getPageDurationMilliseconds(currentPage);
    final nextPage = this.nextPage(currentPage, loop: true);
    scheduleStoryPage(ref, delay, nextPage);
  }

  void scheduleStoryPage(WidgetRef ref, int delayMilliseconds, StoryPage? pageToShow) {
    if (pages.isEmpty || pageToShow == null) return;

    cancelNextPageOperation();
    final pageIdProvider = ref.read(providers.restorableCurrentPageIdProvider);
    final pageId = pageToShow.id;
    _cancellationToken = CancellationToken();
    final token = _cancellationToken!;
    
    token.run(() => Future.delayed(
      Duration(milliseconds: delayMilliseconds),
      () {
        if (!token.isCancelled) {
          pageIdProvider.value = pageId;
        }
      }
    ));
  }

  static Future<bool> validateAndSetCurrentStoryAndPage(WidgetRef ref, int storyId, int? pageId) async {
    final stories = await ref.read(providers.storiesProvider.future);
    final story = Stories._getById(stories, storyId);
    if (story == null) return false;

    StoryPage? page = story.getPageById(pageId);
    if (page == null) {
      if (pageId != null) return false;
      if (story.pages.isNotEmpty) page = story[0];
    }

    storiesDal.setCurrentStory(ref, story);
    setCurrentPage(ref, page);
    return true;
  }
}

