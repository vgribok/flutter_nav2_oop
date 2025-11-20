# Flutter Application Starter

This repo is a Flutter application starter. You can clone it, run it and start customizing it to make it yours.

It holds a small [library](./lib) and a [sample application](./example/)

## Summary

This application starter abstracts away main sources of Flutter application boilerplate like declarative navigation, ephemeral state and application state management, parsing user-typed URLs and bookmarks when running in the browser, screen orientation handling, modal screens - leaving you to implement [Screens](./example/lib/src/screens/), [Routes](./example/lib/src/routing), [persistent state](./example/lib/src/dal/), and tie everything together in a small, clean [main.dart](./example/lib/main.dart).

This application starter reins in the issues stemming from the difficulty of making [declarative navigation](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade), [application state, and ephemeral state](https://docs.flutter.dev/development/data-and-backend/state-mgmt/ephemeral-vs-app) work together. Most intro-level samples will show you how to use them in isolation, but in reality it's quite challenging to get these concerns implemented in a way that does not bog the developer down in an ocean of hacks and interdependencies.

Clone and evolve your own application if you don't want to fight the boilerplate war. For the state management it uses [Riverpod v3](https://riverpod.dev/) - the successor of the popular [Provider](https://github.com/rrousselGit/provider) package, both created by the same person. The [Riverpod Restorable v3](https://pub.dev/packages/flutter_riverpod_restorable) extends the Riverpod state management model to dealing with the ephemeral state, which is crucial to the UX for users of low-RAM, older Android phones.

The project goes past the typical PoC/HelloWorld and showcases more real-world-ish approach, where the app has its state restored after it gets evicted on Android when user switches between apps and back, where the async application initialization code has a clear place with the corresponding waiting UI, and where the application state gets rebuilt when the web browser user jumps to a bookmark.

### Main Features

Features delivered by this library out-of-the-box are:

- **Near zero boilerplate code in the application**  
  See the [main.dart](./example/lib/main.dart) example below for a minimal setup.
- **Tab-based and non-tabbed navigation using Flutter Router**  
  Utilizes Flutter's Router API instead of the classic Navigator, enabling both tabbed and non-tabbed navigation patterns.
- **Flutter declarative navigation approach**  
  Crucial for supporting Web: enables parsing and routing for user-typed (Web) URLs, direct URL pasting, and bookmarking.
- **Properly wired [Riverpod v3](https://pub.dev/packages/flutter_riverpod) app state management**  
  Ensures robust, testable, and maintainable state management across the app using the latest Riverpod patterns.
- **Ephemeral state restoration with [Riverpod Restorable v3](https://pub.dev/packages/flutter_riverpod_restorable)**  
  Supports restoring ephemeral state, which is essential for a smooth UX, especially on low-RAM devices.
- **Responsive handling of navigation controls**  
  Navigation adapts seamlessly when device screen orientation changes.
- **Support for 404 pages**  
  When a user types an unknown URL in the browser URL bar, a customizable 404 page is shown.
- **Easy creation of modal screens**  
  Modal screens can be defined and managed with minimal effort.
- **Real-world camera and geotagging example**  
  A [separate branch](https://github.com/vgribok/flutter_nav2_oop/tree/ios-and-android-only) demonstrates iOS and Android-only camera usage, including GPS geotagging and robust handling on low-RAM Android phones.

**Additional highlights:**

- **Direct Web URL Support**  
  The library parses URLs entered in the browser and reconstructs the navigation stack accordingly, supporting deep linking, direct URL pasting, and bookmarking.
- **404 and Deep Link Handling**  
  Each route class (see [routing](./example/lib/src/routing/)) provides a `fromUri(Uri)` factory method to match and parse URLs, including support for unknown routes.
- **Separation of Concerns**  
  Application logic, navigation, and state management are cleanly separated, making the codebase maintainable and extensible.
- **Customizable Tab Navigation**  
  Define tabs and their root screens using [TabScreenSlot](./lib/src/models/tabbed/tab_screen_slot.dart), with per-tab route parsing.
- **Screen and Route Abstractions**  
  Implement your own [screens](./example/lib/src/screens/) and [routes](./example/lib/src/routing/) by subclassing framework-provided base classes.
- **MaterialApp.router Integration**  
  Uses `MaterialApp.router` for full declarative navigation and state restoration.

This feature set goes far beyond simple "Counter" or "Hello, World!" examples, providing a robust foundation for real-world Flutter apps targeting mobile, web, and desktop platforms.

As you can see, this is significantly more than the "Counter" or a "Hello, World!" examples could ever teach you.

### Example

Your application `main.dart` will look like this:
<details>
    <summary>Click to show imports...</summary>

```dart
import 'package:example/src/providers/counter_provider.dart';
import 'package:example/src/providers/books_provider.dart';
import 'package:example/src/providers/stories_provider.dart';
import 'package:example/src/routing/counter_path.dart';
import 'package:example/src/routing/story/stories_path.dart';
import 'package:example/src/routing/story/story_path.dart';
import 'package:example/src/screens/counter_screen.dart';
import 'package:example/src/screens/story/stories_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:example/src/routing/book_details_path.dart';
import 'package:example/src/routing/book_list_path.dart';
import 'package:example/src/routing/settings_modal_child_path.dart';
import 'package:example/src/routing/settings_path.dart';
import 'package:example/src/routing/user_profile_path.dart';
import 'package:example/src/screens/book_list_screen.dart';
import 'package:example/src/screens/settings_screen.dart';
import 'package:example/src/screens/user_profile_screen.dart';
import 'package:example/theme.dart';
import 'package:flutter_nav2_oop/all.dart';
```
</details>

```dart
/// Run this file to see tab-based navigation demo
void main() {
  runApp(theApp.riverpodApp);
}

/// Simulating some long-ish async app initialization
/// logic, possibly with exceptions thrown
Future<void> _appInitSimulator(Ref ref) async {
  // Simulating an error in the initialization routine
  await Future.delayed(const Duration(milliseconds: 3000));
  //throw UnimplementedError("Something bad has happened..");
}

TabNavAwareApp get theApp => TabNavAwareApp(
    applicationId: "nav-aware-books-sample",
    appTitle: 'Books With Navigation',
    theme: mainColor.toTheme(),
    darkTheme: mainColor.toDarkTheme(),
    initialPath: CounterPath(),
    appGlobalStateInitProvider: FutureProvider(_appInitSimulator),
    key: const ValueKey("books-sample-app"),

    globalRestorableProviders: [
      restorableCounterProvider,
      restorableSelectedBookIdProvider,
      restorableCurrentStoryIdProvider,
      restorableCurrentPageIdProvider,
    ],

    tabs: [
      // Comment out this section to enable non-tab navigation demo
      TabScreenSlot(Icons.home, title: 'Books',
          rootScreenFactory: (tabIndex, ref) => BooksListScreen(tabIndex),
          routeParsers: [ BookListPath.fromUri, BookDetailsPath.fromUri ]
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
```

Once your [screen](example/lib/src/screens/book_list_screen.dart) and [route](example/lib/src/routing/book_details_path.dart) classes are implemented,
you get your app looking like this on Android, iPhone or Web.

![android UI screenshot](./doc/images/nav_2_app_android.png)
![iphone UI screenshot](./doc/images/nav_2-oop-iphone.png)
![web UI screenshot](./doc/images/nav_2_app_web.png)
Windows app has been run successfully too.

### State Management with Riverpod v3

The project uses Riverpod v3 with code generation for clean, type-safe state management:

```dart
// Define restorable state
final restorableCounterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);

// Create notifier with code generation
@riverpod
class Counter extends _$Counter {
  @override
  int build() => ref.watch(restorableCounterProvider).value;

  void increment() => ref.read(restorableCounterProvider).value++;
}
```

Key benefits:
- **Code generation** eliminates boilerplate
- **Type safety** with compile-time checks
- **State restoration** for seamless UX on low-RAM devices
- **Clean separation** between state definition and business logic

## Requirements

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Riverpod 3.0.0 or higher
- Code generation setup (`build_runner`, `riverpod_generator`)

## Challenge to Overcome

Flutter's declarative navigation (Navigator 2.0) is quite [complex](https://miro.medium.com/max/2400/1*hNt4Bc8FZBp_Gqh7iED3FA.png), is [scarcely-documented](https://flutter.dev/docs/development/ui/navigation) by an in-depth but somewhat outdated [Medium post](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade), and requires significant mind-shift to adopt its declarative style of rendering UI.

> This project has started as an attempt to abstract away declarative navigation boilerplate code into a reusable set of library classes, and to create a simple application starter template with tabbed navigation enabled by default, and with a few more very basic features, like app state management and restoration.

Declarative UI is an approach where *UI widgets are not responsible for managing the state*, but instead are re-rendered on each relevant state change. This approach has become quite common, first popularized by React, and now with Flutter too. Still, it poses challenges to navigation flow development as with declarative UI there can *no longer* be a `screenStack.push(topScreen)` type of code. Instead, `Widget[] renderScreenNavStack(appState)` is how navigation stacks are rendered in declarative UIs.

To complicate matters a bit more, supporting web UIs in addition to phone and desktop ones means that routing and navigation has to render meaningful URLs in the web browser address bar, as wells as being able to do the opposite: *construct the navigation stack* state from a URL typed in by user.

The [Google-sanctioned app code example](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart) everyone has to rely upon (as of time of writing) to learn declarative navigation programming, is pretty opaque, has a good amount of boilerplate, but most importantly, it does not separate concerns, mixing together library/framework parts with actual end-user application logic, resulting in steep learning curve required to make sense of declarative navigation and for using it efficiently.

The tasks one would have to solve, with no framework to help, are:
- Compute the screen stack based on the current app state.
- Compute which route to display in web browser's address bar based on the current app state.
- Determine which part of the app state to alter when a screen is removed from the nav stack by user hitting the back navigation arrow.
- Compute the state from the URL entered in the web browser address bar, including support of the 404 route and screen.
- With bottom navigation tab app UI layout, we need to separate tab navigation state management
  from the screens' child/overlay screens.

## Solution Outline

The [reusable library part](./lib/) takes care of the following application UI & navigation development facets.

1. No need to use `BottomNavigationBar` to define your nav tabs and then manually implement tab navigation. Instead you simply [supply tab data](example/lib/main.dart) and tab "root" screen factories.
2. No need to use `Scaffold` to define your screens. Instead you subclass [NavScreen](lib/src/screens/tabbed/tabbed_nav_screen.dart) and override its "`Widget buildBody(BuildContext)`" method.
3. No code duplication for [calculating top screen](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart-L108) and [determining the URL](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart-L88) to show in the browser address bar. Instead, each NavScreen subclasses [override `routePath`](example/lib/src/screens/settings_screen.dart) property getter, letting the framework pick the route URL to display from the top screen of the stack.
4. No need to write [spaghetti code](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart-L36) parsing user-entered browser URLs to set the app state. Instead, each route class has a standard `fromUri(Uri)` [factory method](example/lib/src/routing/user_profile_path.dart) that looks at the user-entered URI and decides whether it matches.
5. Use [`topScreen()` method](example/lib/src/screens/book_list_screen.dart) override to check relevant state and tell the framework whether another "overlay" screen needs to be shown on top of the current one. **This is the famous `UI = f(state)` part in action**.
6. Use [`removeFromNavStackTop()` method](example/lib/src/screens/book_details_screen.dart) override to update the state so that current screen would be removed from the top of the nav stack.
7. Get consistent and straightforward access to mutable state using Riverpod v3 with code generation.
8. Define restorable state with `restorableProvider` for automatic state restoration.
9. Use factories to customize framework-defined UI, like AppBar colors, bottom nav tabs, and the 404 screen.

> All of the above enables transparent routing and navigation
> implemented by the framework, leaving you with having to
> **implement only the screens, the routes corresponding to the
> screens, and the wiring-it-together initialization logic**.**
