library flutter_nav2_oop;

// TODO: add localization support
// TODO: publish the library on pub.dev

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';

part './src/models/root_screen_slot.dart';
part './src/models/nav_model.dart';
part 'src/models/tabbed/tab_screen_slot.dart';
part 'src/models/tabbed/tab_nav_model.dart';

part 'src/routing/paths/details_route_path.dart';
part 'src/routing/paths/not_found_route_path.dart';
part 'src/routing/paths/route_path.dart';
part 'src/routing/paths/nested_route_path.dart';
part 'src/routing/tabbed/tab_route_path.dart';

part './src/routing/nav_aware_app.dart';
part 'src/routing/tabbed/tab_nav_aware_app.dart';
part './src/routing/nav_aware_route_info_parser.dart';
part 'src/routing/tabbed/tab_nav_aware_route_info_parser.dart';
part './src/routing/nav_aware_routing_delegate.dart';
part 'src/routing/tabbed/tab_nav_aware_routing_delegate.dart';
part './src/routing/no_animation_transition_delegate.dart';

part './src/screens/404_nav_screen.dart';
part './src/screens/nav_screen.dart';
part 'src/screens/tabbed/tabbed_nav_screen.dart';
part './src/screens/full_screen_modal_dialog.dart';
part './src/screens/app_init_error_screen.dart';
part './src/screens/app_init_wait_screen.dart';

part './src/utility/restorable_enum.dart';
part './src/utility/uri_extensions.dart';
part './src/utility/riverpod_extensions.dart';
part './src/utility/iterable_extensions.dart';
part './src/utility/context_extensions.dart';
part './src/utility/object_extensions.dart';
part './src/utility/platform_utilities.dart';
part './src/utility/disposable.dart';
part './src/utility/cancellable_token.dart';
part './src/utility/color_extensions.dart';

part './src/widgets/async_button.dart';
part './src/widgets/async_value_widget.dart';
part './src/widgets/better_future_builder.dart';
part './src/widgets/error_display_widget.dart';
part './src/widgets/wait_widget.dart';
part './src/widgets/confirmation_message_box.dart';
part './src/widgets/centered_column.dart';
part './src/widgets/future_provider_widget.dart';
part './src/widgets/refresh_indicator_container.dart';
