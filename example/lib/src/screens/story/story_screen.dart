import 'package:example/src/dal/stories_data.access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:example/src/routing/story/story_path.dart';
import 'package:example/src/widgets/story/story_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nav2_oop/all.dart';

class StoryScreen extends TabNavScreen {
  final Story selectedStory;
  final List<Story> stories;
  final StoryPage? currentPage;

  const StoryScreen(super.tabIndex,
      this.stories,
      this.selectedStory,
      this.currentPage,
      {super.key}
  )
    : super(screenTitle: "The Story");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
      StoryLayout(stories, selectedStoryId: selectedStory.id,
          child: Text("Page ${currentPage?.id ?? "[NONE]"} goes here")
      );

  @override
  RoutePath get routePath => StoryPath(storyId: selectedStory.id, pageId: currentPage?.id);

  @override
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
    StoryDal.selectStory(ref, null);
  }
}