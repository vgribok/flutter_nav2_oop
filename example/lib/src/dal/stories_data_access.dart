import 'package:example/src/models/stories_models.dart';
import 'package:example/src/providers/stories_provider.dart' as providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Stories {
  AsyncValue<List<Story>> getStories(WidgetRef ref) => 
      ref.watch(providers.storiesProvider);
  
  int? getCurrentStoryId(WidgetRef ref) => 
      ref.watch(providers.restorableCurrentStoryIdProvider).value;
  
  int? getCurrentPageId(WidgetRef ref) => 
      ref.watch(providers.restorableCurrentPageIdProvider).value;
  
  Story? getCurrentStory(WidgetRef ref) {
    final storyId = getCurrentStoryId(ref);
    if (storyId == null) return null;
    final stories = ref.watch(providers.storiesProvider).value;
    if (stories == null) return null;
    try {
      return stories.firstWhere((s) => s.id == storyId);
    } catch (_) {
      return null;
    }
  }
  
  void setCurrentStory(WidgetRef ref, int? storyId) {
    ref.read(providers.restorableCurrentStoryIdProvider).value = storyId;
    ref.read(providers.restorableCurrentPageIdProvider).value = null;
  }
  
  void setCurrentPage(WidgetRef ref, int? pageId) => 
      ref.read(providers.restorableCurrentPageIdProvider).value = pageId;

  Future<bool> selectStoryIfExists(WidgetRef ref, int storyId, int? pageId) async {
    final stories = await ref.read(providers.storiesProvider.future);
    final exists = stories.any((s) => s.id == storyId);
    if (exists) {
      setCurrentStory(ref, storyId);
      setCurrentPage(ref, pageId);
    }
    return exists;
  }

  void invalidate(WidgetRef ref) => ref.invalidate(providers.storiesProvider);

  List<NotifierProvider> get ephemerals => [
    providers.restorableCurrentStoryIdProvider,
    providers.restorableCurrentPageIdProvider,
  ];
}

final storiesProvider = Stories();

class StoryEx {
  List<NotifierProvider> get ephemerals => [];
}

final storyProvider = StoryEx();
