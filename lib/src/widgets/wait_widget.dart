part of '../../all.dart';

/// Shows the [CircularProgressIndicator] with an optional text,
/// optionally wrapped in a [Center] widget.
class WaitIndicator extends StatelessWidget {

  /// Optional text to show along with the wait indicator
  final String? waitText;
  final bool centered;
  final Color? color;

  const WaitIndicator({this.waitText = "Loading...", this.centered = true, this.color, super.key});

  @override
  Widget build(BuildContext context) =>
      centered ? Center(child: _body(context)) : _body(context);

  Widget _body(BuildContext context) =>
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: color),
            if(waitText != null)
              Divider(thickness: 1, indent: 50, endIndent: 50, color: color),
            if(waitText != null)
              Text(waitText!, key: const ValueKey("wait indicator text"),
                  style: context.textTheme.bodyMedium!.copyWith(color: color ?? context.colorScheme.onSurface)
              )
          ]
      );
}