import 'package:flutter/material.dart';

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
class StoryHeader {
  final int id;
  final Bubble bubble;
  final double defaultDuration;

  const StoryHeader({
    required this.id,
    required this.defaultDuration,
    required this.bubble,
  });
}

@immutable
class Story extends StoryHeader {

  final List<StoryPage> pages;

  const Story({
    required super.id,
    required super.defaultDuration,
    required super.bubble,
    required this.pages
  });
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