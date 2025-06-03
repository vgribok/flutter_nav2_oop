part of '../../all.dart';

class CenteredColumn extends StatelessWidget {

  final List<Widget> children;

  const CenteredColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
      Center(key: const ValueKey("center-for-column"),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              key: const ValueKey("centered-column"),
              children: children
          )
      );
}