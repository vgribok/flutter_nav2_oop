import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {

  void showFancySnackBar({required Widget content}) =>
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
            content: content,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            behavior: SnackBarBehavior.floating
        )
    );

  void showSnackBar(String text) => showFancySnackBar(content: Text(text));
}