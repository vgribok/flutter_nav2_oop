
import 'package:flutter/material.dart';

class CenteredColumn extends StatelessWidget {

  final List<Widget> children;

  const CenteredColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
    Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children
    ));
}