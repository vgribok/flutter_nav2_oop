import 'package:flutter/material.dart';

/// Renders network image with error fallback
class InternetImageWidget extends StatelessWidget {
  final String url;
  final BoxFit? fit;

  const InternetImageWidget(this.url, {this.fit, super.key});

  @override
  Widget build(BuildContext context) => Image.network(
    url,
    fit: fit,
    errorBuilder: (context, __, ___) => LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width,
        height: constraints.maxHeight.isFinite ? constraints.maxHeight : MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
        child: const Center(
          child: Text('Missing internet picture', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
        ),
      ),
    ),
  );
}
