import 'package:flutter/material.dart';

class Headings {
  static const String h1 = 'h1';
  static const String h2 = 'h2';
  static const String h3 = 'h3';
  static const String h4 = 'h4';
  static const String h5 = 'h5';
  static const String h6 = 'h6';

  // A map of heading levels to their corresponding font styles.
  static const Map<String, TextStyle> _headingStyles = {
    h1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    h2: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    h3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    h4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    h5: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    h6: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  };
}

class Heading extends StatelessWidget {
  const Heading({
    Key? key,
    required this.text,
    required this.level,
    this.styleOverride,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String level;
  final String text;
  final TextStyle? styleOverride;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    // Merge the style override with the default style for the heading level.
    final TextStyle style = styleOverride != null
        ? Headings._headingStyles[level]!.merge(styleOverride)
        : Headings._headingStyles[level]!;
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}