import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders clickable profile bubble (Avatar)
class ProfileBubble extends ConsumerWidget {
  final bool selected;
  final Story story;

  ProfileBubble(this.story, { required this.selected })
    : super(key: ValueKey(story.id));

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      GestureDetector(
        onTap: () => Stories.setCurrentStory(ref, story),
        child: Column(
          children: [
            CircleAvatar(
                radius: selected ? 30 : 40,
                backgroundImage: NetworkImage(story.bubble.imageURL)
            ),
            if(selected) Text(story.bubble.text)
          ]
        )
      );
}