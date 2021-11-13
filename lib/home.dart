import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: CustomPaint(
          painter: _CustomPainter(
            text: 'Flutter Demo',
            style: Theme.of(context).textTheme.headline1!,
          ),
        ),
      ),
    );
  }
}

class _CustomPainter extends CustomPainter {
  _CustomPainter({
    required String text,
    required TextStyle style,
  })  : _foregroundPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: style.copyWith(color: _primaryColor),
          ),
          textDirection: TextDirection.ltr,
        )..layout(),
        _backgroundPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: style.copyWith(color: _accentColor),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

  static const _clipRadius = 100.0;

  static const _primaryColor = Color(0xff004d40);
  static const _accentColor = Color(0xffffcdd2);

  final TextPainter _foregroundPainter;
  final TextPainter _backgroundPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _primaryColor,
    );

    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: _clipRadius,
        ),
      );
    canvas.drawPath(path, Paint()..color = _accentColor);
    _backgroundPainter.paint(
      canvas,
      Offset(
        (size.width / 2) - (_foregroundPainter.width / 2),
        (size.height / 2) - (_foregroundPainter.height / 2),
      ),
    );

    canvas.clipPath(path);

    _foregroundPainter.paint(
      canvas,
      Offset(
        (size.width / 2) - (_foregroundPainter.width / 2),
        (size.height / 2) - (_foregroundPainter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
