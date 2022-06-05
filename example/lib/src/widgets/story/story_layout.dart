import 'package:example/src/models/stories_models.dart';
import 'package:example/src/widgets/story/story_list.dart';
import 'package:flutter/material.dart';

class StoryLayout extends StatelessWidget {

  final List<Story> stories;
  final int? selectedStoryId;
  final Widget child;

  const StoryLayout(
      this.stories,
      {
        required this.selectedStoryId,
        required this.child,
        super.key
      }
  );

  @override
  Widget build(BuildContext context) =>
      Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5)),
          StoryList(stories, selectedStoryId: selectedStoryId),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
          child
        ],
      );
}