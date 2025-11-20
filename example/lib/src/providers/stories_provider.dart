import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';
import 'package:example/src/models/stories_models.dart';

part 'stories_provider.g.dart';

final restorableCurrentStoryIdProvider = restorableProvider<RestorableIntN>(
  create: (ref) => RestorableIntN(null),
  restorationId: 'current-story-id',
);

final restorableCurrentPageIdProvider = restorableProvider<RestorableIntN>(
  create: (ref) => RestorableIntN(null),
  restorationId: 'current-page-id',
);

@riverpod
Future<List<Story>> stories(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return const [
    Story(
      id: 0,
      defaultDuration: 3.0,
      bubble: Bubble(imageURL: 'https://picsum.photos/100/100?1', text: 'Adventure'),
      pages: [
        StoryPage(id: 0, imageURL: 'https://picsum.photos/400/800?1'),
        StoryPage(id: 1, imageURL: 'https://picsum.photos/400/800?2'),
        StoryPage(id: 2, imageURL: 'https://picsum.photos/400/800?3'),
      ],
    ),
    Story(
      id: 1,
      defaultDuration: 3.0,
      bubble: Bubble(imageURL: 'https://picsum.photos/100/100?2', text: 'Mystery'),
      pages: [
        StoryPage(id: 0, imageURL: 'https://picsum.photos/400/800?4'),
        StoryPage(id: 1, imageURL: 'https://picsum.photos/400/800?5'),
        StoryPage(id: 2, imageURL: 'https://picsum.photos/400/800?6'),
      ],
    ),
  ];
}
