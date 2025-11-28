import 'package:example/src/models/stories_models.dart';
import 'package:example/src/providers/stories_provider.dart' as providers;
import 'package:flutter_nav2_oop/all.dart';

extension StoryListEx on List<Story> {
  Story? getById(int? storyId) =>
      storyId == null ? null : firstSafeWhere((s) => s.id == storyId);
}

class Stories {
  // Provider access helpers - encapsulate .value boilerplate
  int? _watchCurrentStoryId(WidgetRef ref) => 
      ref.watch(providers.restorableCurrentStoryIdProvider).value;
  
  void _setCurrentStoryId(WidgetRef ref, int? id) => 
      ref.read(providers.restorableCurrentStoryIdProvider).value = id;
  
  int? _watchCurrentPageId(WidgetRef ref) => 
      ref.watch(providers.restorableCurrentPageIdProvider).value;
  
  int? _readCurrentPageId(WidgetRef ref) => 
      ref.read(providers.restorableCurrentPageIdProvider).value;
  
  void _setCurrentPageId(WidgetRef ref, int? id) => 
      ref.read(providers.restorableCurrentPageIdProvider).value = id;
  
  // Public API - clean, no boilerplate
  AsyncValue<List<Story>> getStories(WidgetRef ref) => 
      ref.watch(providers.storiesProvider);
  
  Future<List<Story>> getStoriesAsync(WidgetRef ref) async =>
      await ref.read(providers.storiesProvider.future);
  
  Story? watchForCurrentStory(WidgetRef ref) {
    final storyId = _watchCurrentStoryId(ref);
    if (storyId == null) return null;
    final stories = ref.watch(providers.storiesProvider).value;
    return stories?.getById(storyId);
  }
  
  StoryPage? watchForCurrentPage(WidgetRef ref) {
    final pageId = _watchCurrentPageId(ref);
    if (pageId == null) return null;
    final story = watchForCurrentStory(ref);
    return story?.getPageById(pageId);
  }

  void setCurrentStory(WidgetRef ref, Story? story) {
    _setCurrentStoryId(ref, story?.id);
    
    if (story == null) {
      cancelNextPageOperation();
    } else {
      final currentPageId = _readCurrentPageId(ref);
      final currentPage = story.getPageById(currentPageId) ?? story[0];
      setCurrentPage(ref, currentPage);
    }
  }
  
  void setCurrentPage(WidgetRef ref, StoryPage? page) {
    _setCurrentPageId(ref, page?.id);
    cancelNextPageOperation();
  }
  
  void cancelNextPageOperation() {
    _cancellationToken?.cancel();
    _cancellationToken = null;
  }
  
  CancellationToken? _cancellationToken;
  
  Future<bool> validateAndSetCurrentStoryAndPage(WidgetRef ref, int storyId, int? pageId) async {
    final stories = await getStoriesAsync(ref);
    final story = stories.getById(storyId);
    if (story == null) return false;

    StoryPage? page = story.getPageById(pageId);
    if (page == null) {
      if (pageId != null) return false;
      if (story.pages.isNotEmpty) page = story[0];
    }

    setCurrentStory(ref, story);
    setCurrentPage(ref, page);
    return true;
  }
  
  void scheduleStoryPage(WidgetRef ref, Story story, int delayMilliseconds, StoryPage? pageToShow) {
    if (story.pages.isEmpty || pageToShow == null) return;

    cancelNextPageOperation();
    final pageId = pageToShow.id;
    _cancellationToken = CancellationToken();
    final token = _cancellationToken!;
    
    token.run(() => Future.delayed(
      Duration(milliseconds: delayMilliseconds),
      () {
        if (!token.isCancelled) {
          _setCurrentPageId(ref, pageId);
        }
      }
    ));
  }

  void invalidate(WidgetRef ref) => ref.invalidate(providers.storiesProvider);
}

final storiesDal = Stories();

extension StoryEx on Story {
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

  void scheduleNextStoryPage(WidgetRef ref, StoryPage? currentPage) {
    final delay = getPageDurationMilliseconds(currentPage);
    final nextPage = this.nextPage(currentPage, loop: true);
    storiesDal.scheduleStoryPage(ref, this, delay, nextPage);
  }
}

