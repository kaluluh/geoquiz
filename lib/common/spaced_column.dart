import 'package:flutter/material.dart';

class SpacedColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const SpacedColumn({
    Key? key,
    required this.children,
    this.spacing = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    return children.asMap().map((index, child) {
      if (index == 0) {
        return MapEntry(index, child);
      }
      return MapEntry(
        index,
        Padding(
          padding: EdgeInsets.only(top: spacing),
          child: child,
        ),
      );
    }).values.toList();
  }
}
