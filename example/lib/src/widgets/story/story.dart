import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders the story page
class StoryPageWidget extends ConsumerWidget {

  final Story story;
  final StoryPage page;

  const StoryPageWidget(
      this.story, this.page,
      {super.key}
  );

  double get _progress => ((story.indexOf(page) ?? 0)+1)/story.pages.length;
  StoryPage? get _nextPage => story.nextPage(page, loop: true);

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
                    onTap: () => StoryEx.setCurrentPage(ref, _nextPage)
                  )
              )
            )
          ]
      );
}