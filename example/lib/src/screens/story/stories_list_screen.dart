import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:example/src/routing/story/stories_path.dart';
import 'package:example/src/screens/story/story_screen.dart';
import 'package:example/src/widgets/story/story_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nav2_oop/all.dart';

class StoriesListScreen extends TabNavScreen {
  const StoriesListScreen(super.tabIndex,
      {super.key})
    : super(screenTitle: "Stories");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
      FutureProviderBuilder<List<Story>>(
          provider: storiesProvider,
          waitText: "Loading stories...",
          builder: (stories) =>
            RefreshIndicatorProviderContainer(refreshProvider: storiesProvider,
              child: StoryLayout(stories, selectedStoryId: null,
                childWidget: Column(
                    children: [
                      Icon(Icons.north, color: Theme.of(context).textTheme.headlineMedium?.color),
                      Text(
                        "Tap the profile to see the story",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      )
                    ]
                )
              )
            )
      );

  @override
  RoutePath get routePath => StoriesPath();

  @override
  NavScreen? topScreen(WidgetRef ref) {

    final Story? selectedStory = storiesProvider.watchForCurrentStory(ref);
    if(selectedStory == null) return null;

    final StoryPage? page = StoryEx.watchForCurrentPage(ref);
    final List<Story> stories = storiesProvider.watchValue(ref)!;

    return StoryScreen(tabIndex, stories, selectedStory, page);
  }
}