import 'package:example/src/widgets/centered_column.dart';
import 'package:flutter/material.dart';

class TwoActionCard extends StatelessWidget {

  final String title;
  final String? subtitle;
  final String action1ButtonText;
  final String action2ButtonText;
  final IconData action1Icon;
  final IconData action2Icon;
  final VoidCallback? onAction1ButtonPressed;
  final VoidCallback? onAction2ButtonPressed;

  TwoActionCard({
    required this.title,
    this.subtitle,
    required this.action1ButtonText,
    required this.action1Icon,
    required this.action2Icon,
    required this.action2ButtonText,
    this.onAction1ButtonPressed,
    this.onAction2ButtonPressed,
    super.key
  }) {
    if(onAction1ButtonPressed == null && onAction2ButtonPressed == null) {
      throw ArgumentError("Either onAction1ButtonPressed or onAction2ButtonPressed (or both) need to be specified", "onAction2ButtonPressed");
    }
  }

  @override
  Widget build(BuildContext context) =>
      Card(elevation: 5, margin: const EdgeInsets.all(10), shadowColor: Theme.of(context).errorColor,
          child: ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              title: Center(child: Text(title)),
              subtitle: CenteredColumn(children: [
                const SizedBox(height: 10),
                if(subtitle != null)
                  Text(subtitle!),
                if(subtitle != null)
                    const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(onAction1ButtonPressed != null)
                        ElevatedButton(onPressed: onAction1ButtonPressed,
                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                                child: CenteredColumn(children:
                                [
                                  Icon(action1Icon),
                                  Text(action1ButtonText),
                                ])
                            )),
                      if(onAction1ButtonPressed != null && onAction2ButtonPressed != null)
                        const SizedBox(width: 10),
                      if(onAction2ButtonPressed != null)
                        OutlinedButton(onPressed: onAction2ButtonPressed,
                            child: Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                                child: CenteredColumn(children:
                                [
                                  Icon(action2Icon),
                                  Text(action2ButtonText),
                                ])
                            ))
                    ]
                )
              ]))
      );
}