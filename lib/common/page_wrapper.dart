import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    Key? key,
    required this.child,
    this.backgroundImage,
    this.backgroundColor
  }) : super(key: key);

  final Widget child;
  final AssetImage? backgroundImage;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: backgroundImage == null ? backgroundColor : null,
        decoration: backgroundImage != null ? BoxDecoration(
            image: DecorationImage(
                image: backgroundImage!,
                fit: BoxFit.cover
            )
        ) : null,
        child: Scaffold(
          body: child,
          backgroundColor: Colors.transparent,
        ));
  }
}
