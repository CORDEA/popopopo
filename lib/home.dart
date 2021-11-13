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
  }) : _painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr,
        );

  final TextPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    _painter.layout();
    _painter.paint(
      canvas,
      Offset(
        (size.width / 2) - (_painter.width / 2),
        (size.height / 2) - (_painter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
