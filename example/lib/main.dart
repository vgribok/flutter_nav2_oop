import 'package:example/src/dal/books_data_access.dart';
import 'package:example/src/dal/file_system_dal.dart';
import 'package:example/src/dal/geolocation_dal.dart';
import 'package:example/src/dal/selected_picture_dal.dart';
import 'package:example/src/dal/stories_data_access.dart';
import 'package:example/src/routing/counter_path.dart';
import 'package:example/src/routing/pictures/picture_list_path.dart';
import 'package:example/src/routing/pictures/photo_preview_path.dart';
import 'package:example/src/routing/story/stories_path.dart';
import 'package:example/src/routing/story/story_path.dart';
import 'package:example/src/screens/counter_screen.dart';
import 'package:example/src/screens/pictures/picture_list_screen.dart';
import 'package:example/src/screens/story/stories_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:example/src/routing/settings_modal_child_path.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/routing/user_profile_path.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:example/src/screens/user_profile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Run this file to see tab-based navigation demo
void main() {
  runApp(theApp.riverpodApp);
}

final _fileSystemFutureProvider = FileSystemFutureProvider();

/// Illustrates some long-ish async app initialization
/// logic, possibly with exceptions thrown
Future<void> _appStateInitializer(Ref ref) =>
  Future.wait([
    _fileSystemFutureProvider.getUnwatchedFuture2(ref),
    getGeolocation(), // to pop up the permissions dialog before using the camera
    //Future.delayed(const Duration(milliseconds: 3000));
  ]);

TabNavAwareApp get theApp => TabNavAwareApp(
  applicationId: "nav-aware-books-sample",
  appTitle: 'Books With Navigation',
  theme: myTheme,
  initialPath: PictureListPath(),
  appGlobalStateInitProvider: FutureProvider(_appStateInitializer),
  key: const ValueKey("books-sample-app"),

  globalRestorableProviders: [
    ...SelectedPictureDal.ephemerals,
    ...booksProvider.ephemerals,
    ...CounterScreen.ephemerals,
    ...Stories.ephemerals,
    ...StoryEx.ephemerals
  ],

  tabs: [
    TabScreenSlot(Icons.camera_alt, title: 'Pictures',
        rootScreenFactory: (tabIndex, ref) => PictureListScreen(tabIndex),
        routeParsers: [ PictureListPath.fromUri, PhotoPreviewPath.fromUri ]
    ),
    TabScreenSlot(Icons.plus_one, title: 'Counter',
        rootScreenFactory: (tabIndex, ref) => CounterScreen(tabIndex),
        routeParsers: [ CounterPath.fromUri ]
    ),
    TabScreenSlot(Icons.settings, title: 'Settings',
        rootScreenFactory: (tabIndex, ref) => SettingsScreen(tabIndex),
        routeParsers: [ SettingsPath.fromUri, SettingsModalChildPath.fromUri ]
    ),
    TabScreenSlot(Icons.person, title: 'User',
        rootScreenFactory: (tabIndex, ref) => UserProfileScreen(tabIndex),
        routeParsers: [ UserProfilePath.fromUri ]
    ),
    TabScreenSlot(
        Icons.interests, title: "Stories",
        rootScreenFactory: (tabIndex, ref) => StoriesListScreen(tabIndex),
        routeParsers: [ StoriesPath.fromUri, StoryPath.fromUri ]
    )
  ]
);
