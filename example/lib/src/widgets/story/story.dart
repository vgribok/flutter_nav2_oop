import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

/// Renders the story page
class StoryPageWidget extends ConsumerWidget {

  final Story story;
  final StoryPage page;

  const StoryPageWidget(
      this.story, this.page,
      {super.key}
  );

  int _indexOf(StoryPage page) {
    return story.pages.indexWhere((p) => p.id == page.id);
  }

  double get _progress => (_indexOf(page) + 1) / story.pages.length;
  
  StoryPage? _nextPage() {
    final index = _indexOf(page);
    if (index < 0) return null;
    final nextIndex = (index + 1) % story.pages.length;
    return story.pages[nextIndex];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
    Column(children: [
            LinearProgressIndicator(
                value: _progress,
                backgroundColor: Theme.of(context).dividerColor,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Expanded(child:
              SingleChildScrollView(scrollDirection: Axis.vertical,
                  child: GestureDetector(child:
                    Image.network(page.imageURL),
                    onTap: () {
                      final next = _nextPage();
                      if (next != null) {
                        storiesProvider.setCurrentPage(ref, next.id);
                      }
                    }
                  )
              )
            )
          ]
      );
}