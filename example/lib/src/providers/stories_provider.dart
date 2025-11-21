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
  await Future.delayed(const Duration(milliseconds: 750));
  return const [
    Story(
      id: 1,
      defaultDuration: 2.0,
      bubble: Bubble(
        imageURL: "https://pbs.twimg.com/profile_images/2699103767/1e9cec7a8399310f4902cfff9d32f14c_400x400.jpeg",
        text: "That's my life",
      ),
      pages: [
        StoryPage(
          id: 111,
          imageURL: "https://3.bp.blogspot.com/-m6HW6cJbrZM/VoybblszDqI/AAAAAAAAYVU/t3pwGleRTosr5tVl7AgynRVvxFYofLVaQCKgB/w1200-h630-p-k-no-nu/IMG_4735.jpg",
          duration: 5.0
        ),
        StoryPage(
          imageURL: "https://pbs.twimg.com/media/E-YezAjXoBMYHCC.jpg",
          id: 222
        ),
        StoryPage(
          imageURL: "https://m.media-amazon.com/images/W/WEBP_402378-T1/images/I/41uPfg7sAxL._AC_SX679_.jpg",
          id: 333
        )
      ]
    )
  ];
}
