
import 'package:example/src/dal/stories_data.access.dart';
import 'package:example/src/models/stories_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryPageWidget extends ConsumerWidget {

  final List<StoryPage> pages;
  final StoryPage page;
  final int pageIndex;
  final int pageCount;

  const StoryPageWidget(
      this.pages, this.page, this.pageIndex, this.pageCount,
      {super.key}
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
    Column(children: [
            LinearProgressIndicator(
                value: (pageIndex+1)/pageCount,
                backgroundColor: Theme.of(context).dividerColor,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Expanded(child:
              SingleChildScrollView(scrollDirection: Axis.vertical,
                  child: GestureDetector(child:
                    Image.network(page.imageURL),
                    onTap: () => StoryDal.moveToNextStoryPage(ref, pages, pageIndex + 1),
                  )
              )
            )
          ]
      );
}