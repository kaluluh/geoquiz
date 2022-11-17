import 'package:flutter/material.dart';

class ElevatedButtonSideIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? height;

  const ElevatedButtonSideIcon({
    Key? key,
    this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textStyle,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: height != null ? Size(0, height!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
