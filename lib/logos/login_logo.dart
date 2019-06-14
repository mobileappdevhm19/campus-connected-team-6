import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginLogo extends StatelessWidget {
  LoginLogo({
    Key key,
    this.size,
    this.colors,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  final double size;

  final MaterialColor colors;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = size ?? iconTheme.size;
    final MaterialColor logoColors = colors ?? Colors.blue;
    return AnimatedContainer(
        width: iconSize,
        height: iconSize,
        duration: duration,
        curve: curve,
        child: Image.asset('assets/flutter-icon.png'));
  }
}
