part of flutter_nav2_oop;

class WaitIndicator extends StatelessWidget {

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
              Text(waitText!)
          ]
      );
}