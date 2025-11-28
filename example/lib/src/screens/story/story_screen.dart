import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:example/src/routing/story/story_path.dart';
import 'package:example/src/widgets/story/story.dart';
import 'package:example/src/widgets/story/story_layout.dart';
import 'package:flutter/material.dart';
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

  int? get currentPageIndex => selectedStory.indexOf(currentPage);

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    if (watchForInCurrentTab(ref)) {
      selectedStory.scheduleNextStoryPage(ref, currentPage);
    } else {
      storiesDal.cancelNextPageOperation();
    }
    
    return StoryLayout(stories, selectedStoryId: selectedStory.id,
        childWidget: currentPage == null ? const Text(
            "The story is waiting to begin..")
            : StoryPageWidget(selectedStory, currentPage!)
    );
  }

  @override
  RoutePath get routePath => StoryPath(storyId: selectedStory.id, pageId: currentPage?.id);

  @override
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
    storiesDal.setCurrentStory(ref, null);
  }
}