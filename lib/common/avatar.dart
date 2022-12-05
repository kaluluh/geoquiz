import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.uid, required this.name, this.size = 48}) : super(key: key);

  final String uid;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Color avatarColor = _generateColorCode(uid);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatarColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: _getContrastColor(avatarColor),
            fontSize: size / 2,
          ),
        ),
      ),
    );
  }

  Color _generateColorCode(String uid) {
    final int r = uid.codeUnitAt(0) % 255;
    final int g = uid.codeUnitAt(1) % 255;
    final int b = uid.codeUnitAt(2) % 255;
    return Color.fromARGB(255, r, g, b);
  }

  Color _getContrastColor(Color color) {
    final double y = (299 * color.red + 587 * color.green + 114 * color.blue) / 1000;
    return y >= 128 ? Colors.black : Colors.white;
  }
}
