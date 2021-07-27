import 'package:flutter_nav2_oop/nav2/routing/route_path.dart';

abstract class DetailsRoutePath<T> extends RoutePath {

  final T id;

  DetailsRoutePath({
    required int navTabIndex,
    required this.id,
    required String resource
  }) : super(
      navTabIndex: navTabIndex,
      resource: resource
  );

  @override
  String get location => '${super.location}$id';
}
