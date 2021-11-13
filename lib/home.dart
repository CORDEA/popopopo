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
            progress: 0.8,
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
    required this.progress,
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

  static const _primaryColor = Color(0xff004d40);
  static const _accentColor = Color(0xffffcdd2);

  final double progress;
  final TextPainter _foregroundPainter;
  final TextPainter _backgroundPainter;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = _primaryColor,
    );

    final progress = this.progress * 2;
    final Path path;
    if (progress > 1) {
      final p = progress - 1;
      path = Path()
        ..moveTo(size.width, size.height)
        ..lineTo(size.width, 0)
        ..lineTo(size.width * (1 - p), 0)
        ..lineTo(0, size.height * (1 - p))
        ..lineTo(0, size.height)
        ..close();
    } else {
      path = Path()
        ..moveTo(size.width, size.height)
        ..lineTo(size.width, size.height * (1 - progress))
        ..lineTo(size.width * (1 - progress), size.height)
        ..close();
    }
    canvas.drawPath(path, Paint()..color = _accentColor);

    final offset = Offset(
      (size.width / 2) - (_foregroundPainter.width / 2),
      (size.height / 2) - (_foregroundPainter.height / 2),
    );
    _backgroundPainter.paint(canvas, offset);
    canvas.clipPath(path);
    _foregroundPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
