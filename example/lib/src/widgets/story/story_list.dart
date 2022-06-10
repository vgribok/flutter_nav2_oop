import 'package:example/src/models/stories_models.dart';
import 'package:example/src/widgets/story/profile_bubble.dart';
import 'package:flutter/material.dart';

/// Reusable widget showing the list of [ProfileBubble]s
class ProfileBubbleList extends StatelessWidget {
  final List<Story> stories;
  final int? selectedStoryId;

  const ProfileBubbleList(this.stories, {super.key, required this.selectedStoryId});

  @override
  Widget build(BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(Story story in stories)
            ProfileBubble(story, selected: story.id == selectedStoryId)
        ]
    );
}