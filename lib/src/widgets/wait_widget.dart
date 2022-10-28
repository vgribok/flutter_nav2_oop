part of flutter_nav2_oop;

/// Shows the [CircularProgressIndicator] with an optional text,
/// optionally wrapped in a [Center] widget.
class WaitIndicator extends StatelessWidget {

  /// Optional text to show along with the wait indicator
  final String? waitText;
  final bool centered;

  const WaitIndicator({this.waitText = "Loading...", this.centered = true, super.key});

  @override
  Widget build(BuildContext context) =>
      centered ? Center(child: _body(context)) : _body(context);

  Widget _body(BuildContext context) =>
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if(waitText != null)
              const Divider(thickness: 1, indent: 50, endIndent: 50),
            if(waitText != null)
              Text(waitText!, key: const ValueKey("wait indicator text"))
          ]
      );
}