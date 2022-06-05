import 'package:example/src/models/stories_models.dart';
import 'package:example/src/widgets/story/profile_bubble.dart';
import 'package:flutter/material.dart';

class StoryList extends StatelessWidget {
  final List<Story> stories;
  final int? selectedStoryId;

  const StoryList(this.stories, {super.key, required this.selectedStoryId});

  @override
  Widget build(BuildContext context) {

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(Story story in stories)
            ProfileBubble(story.bubble, story.id, selected: story.id == selectedStoryId)
        ]
    );
  }
}