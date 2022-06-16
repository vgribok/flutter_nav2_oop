part of flutter_nav2_oop;

class WaitIndicator extends StatelessWidget {

  final String waitText;

  const WaitIndicator({this.waitText = "Loading...", super.key});

  @override
  Widget build(BuildContext context) =>
      Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const Divider(thickness: 1, indent: 50, endIndent: 50),
            Text(waitText)
          ]
      ));
}