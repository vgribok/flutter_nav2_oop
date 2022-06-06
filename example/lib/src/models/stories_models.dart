import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';

@immutable
class Bubble
{
  final String imageURL;
  final String text;

  const Bubble({required this.imageURL, required this.text});
}

@immutable
class StoryPage
{
  final int id;
  final double? duration;
  final String imageURL;

  const StoryPage({required this.imageURL, required this.id, this.duration});
}

@immutable
class Story {
  final int id;
  final Bubble bubble;
  final double defaultDuration;

  final List<StoryPage> pages;

  const Story({
    required this.id,
    required this.defaultDuration,
    required this.bubble,
    required this.pages
  });

  int getPageDurationMillisec(int pageId) {
    final double durationSeconds = pages.firstSafe((page) => page.id == pageId)?.duration ?? defaultDuration;
    return (durationSeconds * 1000).toInt();
  }
}

/*
    {
      "id": "123",
      "bubble": {
        "imageURL": "",
        "text": ""
      },
      "defaultDuration": 3.0, // seconds
      "pages": [
        {
           "id": "111",
           "imageURL": "https://storageservice.com/111.png",
           "duration": 5.0 // seconds
        },
        {
            "id": "222",
            "imageURL": "https://storageservice.com/222.png"
        },
        {
            "id": "333",
            "imageURL": "https://storageservice.com/222.png"
        }
      ]
    }
*/