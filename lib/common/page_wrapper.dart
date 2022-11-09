import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    Key? key,
    required this.child,
    this.backgroundImage
  }) : super(key: key);

  final Widget child;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_image.png"),
                fit: BoxFit.cover)),
        child: Scaffold(
          body: child,
          // backgroundColor: Colors.purple.withOpacity(0.5),
        ));
  }
}
