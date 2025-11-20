import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:example/src/routing/story/stories_path.dart';
import 'package:example/src/screens/story/story_screen.dart';
import 'package:example/src/widgets/story/story_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

class StoriesListScreen extends TabNavScreen {
  const StoriesListScreen(super.tabIndex,
      {super.key})
    : super(screenTitle: "Stories");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final storiesAsync = storiesDal.getStories(ref);
    
    return storiesAsync.when(
      data: (stories) => RefreshIndicator(
        onRefresh: () async => storiesDal.invalidate(ref),
        child: StoryLayout(
          stories,
          selectedStoryId: null,
          childWidget: Column(
            children: [
              Icon(Icons.north, color: Theme.of(context).textTheme.headlineMedium?.color),
              Text(
                "Tap the profile to see the story",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  @override
  RoutePath get routePath => StoriesPath();

  @override
  NavScreen? topScreen(WidgetRef ref) {
    final Story? selectedStory = storiesDal.getCurrentStory(ref);
    if (selectedStory == null) return null;
    
    final storiesAsync = storiesDal.getStories(ref);
    final stories = storiesAsync.valueOrNull;
    if (stories == null) return null;
    
    final pageId = storiesDal.getCurrentPageId(ref);
    final page = pageId == null ? null :
        selectedStory.pages.cast<StoryPage?>().firstWhere(
          (p) => p?.id == pageId,
          orElse: () => null,
        );
    
    return StoryScreen(tabIndex, stories, selectedStory, page);
  }
}