library flutter_nav2_oop;

// TODO: rename the package as nav2_with_tabs
// TODO: publish the library on pub.dev
// TODO: add localization support

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_restorable/flutter_riverpod_restorable.dart';

part './src/models/tab_info.dart';
part './src/models/tab_nav_model.dart';

part './src/routing/details_route_path.dart';
part './src/routing/nav_aware_app_state.dart';
part './src/routing/nav_aware_route_info_parser.dart';
part './src/routing/nav_aware_routing_delegate.dart';
part './src/routing/no_animation_transition_delegate.dart';
part './src/routing/not_found_route_path.dart';
part './src/routing/route_path.dart';

part './src/screens/404_nav_screen.dart';
part './src/screens/tabbed_nav_screen.dart';
part './src/screens/full_screen_modal_dialog.dart';

part './src/utility/uri_extensions.dart';
part './src/utility/iterable_extensions.dart';
part './src/utility/restorable_enum.dart';