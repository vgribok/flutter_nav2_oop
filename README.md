# Flutter 2 Navigator abstracted with OOP

> **TL;DR** If you have tried Flutter Navigator 2.0 (FN2) and  were stymied by its complexity and opacity, fear not: this little (necessarily opinionated) library + tabbed app sample combo will ensure that you will not have to spend cycles writing navigation/routing-related boilerplate code, instead of focusing on your application "meat" code, supplying *[screens](example/lib/src/screens)*, *[routes](example/lib/src/routing)* that are mapped to those screens, and the *[app initialization code](example/lib/main.dart)* wiring together navigation tabs and their "root" screens, to have web & native UI and navigation working out-of-the box:<br/>

Your application `main.dart` will look like this:
```dart
import 'package:flutter/material.dart';
import 'package:example/src/models/book.dart';
import 'package:example/src/models/show_settings_modal_state.dart';
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

void main() {
  runApp(BooksApp());
}

class BooksApp extends NavAwareAppState {

  BooksApp() :
        super(
          appTitle: 'Books App',
          theme: myTheme,
          navState: NavAwareState(),

          routeParsers: [
            BookListPath.fromUri,
            BookDetailsPath.fromUri,
            UserProfilePath.fromUri,
            SettingsPath.fromUri,
            SettingsModalChildPath.fromUri
          ],

          tabs: [
            TabInfo(
                icon: Icons.home,
                title: 'Books',
                stateItems: [SelectedBookState()],
                rootScreenFactory: (nvState) => BooksListScreen(nvState)),
            TabInfo(
                icon: Icons.person,
                title: 'User',
                rootScreenFactory: (nvState) => UserProfileScreen(nvState)),
            TabInfo(
                icon: Icons.settings,
                title: 'Settings',
                stateItems: [SettingsShowModalState()],
                rootScreenFactory: (nvState) => SettingsScreen(nvState))
          ]
      )
  {
    navState.assertSingleStateItemOfEachType();
  }
}
```

Once your [screen](example/lib/src/screens/book_list_screen.dart) and [route](example/lib/src/routing/book_details_path.dart) classes are implemented,
you get your app looking like this.

![web UI screenshot](./doc/images/nav_2_app_android.png) 
![web UI screenshot](./doc/images/nav_2_app_web.png)


## Challenge to Overcome

Navigator 2, as a part of Flutter 2.0, is quite [complex](https://miro.medium.com/max/2400/1*hNt4Bc8FZBp_Gqh7iED3FA.png), is [scarcely-documented](https://flutter.dev/docs/development/ui/navigation) by an in-depth but somewhat outdated [Medium post](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade), and requires significant mind-shift to adopt its  declarative style of rendering UI.

> This project is an attempt to abstract away FN2 boilerplate code into a reusable set of library classes, and to create a simple application starter template with tabbed navigation enabled by default. 

Declarative UI is an approach where *UI widgets are not part of the state*, but rather are re-rendered on each relevant state change. It has become quite common, first thanks to React, and now thanks to Flutter. Still, it poses challenges to navigation flow development as with declarative UI there can *no longer* be a `screenStack.push(topScreen)` type of code. Instead, `Widget[] renderScreenNavStack(appState)` is how navigation stacks are rendered in declarative UIs.

To complicate matters a bit more, supporting web UIs in addition to native ones means that routing and navigation has to render meaningful URLs in the web browser address bar, as wells as being able to do the opposite: construct the navigation stack state from a URL typed in by a human being.

The [Google-sanctioned app code example](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart) everyone has to rely upon (as of time of writing) to learn Navigator 2 (N2) programming, is pretty opaque, has a good amount of boilerplate, but most importantly, it does not separate concerns, mixing together library/framework parts with actual end-user application logic, resulting in steep learning curve required to make sense of the FN2 and for using it efficiently.

The tasks one would have to solve, with no framework to help, are:
- Compute the screen stack based on the current app state.
- Compute which route to display in web browser's address bar based on the current app state.
- Determine which part of the app state to alter when a screen is removed from the nav stack by user hitting the back navigation arrow.
- Compute the state from the URL entered in the web browser address bar, including support of the 404 route and screen.
- Assuming bottom navigation tab app UI layout, we need to separate tab navigation state management from the screens' child/overlay screens.

## Solution Outline

The [reusable library part](./lib/) takes care of the following application UI & navigation development facets.

1. No need to use `BottomNavigationBar` to define your nav tabs and then manually implement tab navigation. Instead you simply [supply tab data](example/lib/main.dart) and tab "root" screen factories.
2. No need to use `Scaffold` to define your screens. Instead you subclass [TabbedNavScreen](lib/src/screens/tabbed_nav_screen.dart) and override its "`Widget buildBody(BuildContext)`" method.
3. No code duplication for [calculating top screen](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart-L108) and [determining the URL](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart-L88) to show in the browser address bar. Instead, each TabbedNavScreen subclass [overrides `routePath`](example/lib/src/screens/settings_screen.dart) property getter, letting the framework pick the route URL to display from the top screen of the stack.
4. No need to write [spaghetti code](https://gist.github.com/johnpryan/430c1d3ad771c43bf249c07fa3aeef14#file-main-dart-L36) parsing user-entered browser URLs to set the app state. Instead, each route class has a standard `fromUri(Uri)` [factory method](example/lib/src/routing/user_profile_path.dart) that looks at the user-entered URI and decides whether it matches.
5. Use [`topScreen` property](example/lib/src/screens/book_list_screen.dart) override to check relevant state and tell the framework whether another "overlay" screen needs to be shown on top of the current one. **This is the famous `UI = f(state)` part in action**.
6. Use [`removeFromNavStackTop()` method](example/lib/src/screens/book_details_screen.dart) override to update the state so that current screen would be removed from the top of the nav stack.
7. Get consistent and straightforward access to mutable state by calling [`T stateByType<T()>` method](lib/src/models/tab_nav_model.dart).
8. Use factories to customize framework-defined UI, like AppBar colors, bottom nav tabs, and the 404 screen.

> All of the above enables transparent routing and navigation implemented by the framework, leaving you with having to implement the screens, routes corresponding to the screens, and the wiring-it-together initialization logic.

 

