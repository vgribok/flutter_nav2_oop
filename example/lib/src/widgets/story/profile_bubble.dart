import 'package:example/src/dal/stories_data.access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileBubble extends ConsumerWidget {
  final bool selected;
  final Bubble bubble;
  final int storyId;

  ProfileBubble(this.bubble, this.storyId, { required this.selected })
    : super(key: ValueKey(storyId));

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      GestureDetector(
        onTap: () => StoryDal.selectStoryId(ref, storyId),
        child: Column(
          children: [
            CircleAvatar(
                radius: selected ? 30 : 40,
                backgroundImage: NetworkImage(bubble.imageURL)
            ),
            if(selected) Text(bubble.text)
          ]
        )
      );
}