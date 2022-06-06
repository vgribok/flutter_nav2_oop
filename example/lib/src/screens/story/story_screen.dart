import 'package:example/src/dal/stories_data.access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:example/src/routing/story/story_path.dart';
import 'package:example/src/widgets/story/story.dart';
import 'package:example/src/widgets/story/story_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_nav2_oop/all.dart';

class StoryScreen extends TabNavScreen {
  final Story selectedStory;
  final List<Story> stories;
  final StoryPage? currentPage;
  final int? currentPageIndex;

  const StoryScreen(super.tabIndex,
      this.stories,
      this.selectedStory,
      this.currentPage,
      this.currentPageIndex,
      {super.key}
  )
    : super(screenTitle: "The Story");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {

    if(currentPageIndex != null) {
      StoryDal.scheduleNextStoryPage(ref, selectedStory, currentPageIndex! + 1);
    }

    return StoryLayout(stories, selectedStoryId: selectedStory.id,
        child: currentPage == null ? const Text(
            "The story is waiting to begin..")
            : StoryPageWidget(
            selectedStory.pages, currentPage!, currentPageIndex!,
            selectedStory.pages.length)
    );
  }

  @override
  RoutePath get routePath => StoryPath(storyId: selectedStory.id, pageId: currentPage?.id);

  @override
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
    StoryDal.selectStory(ref, null);
  }
}