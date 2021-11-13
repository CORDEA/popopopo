import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.easeInToLinear,
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _CustomPainter(
                      text: 'Flutter Demo',
                      style: Theme.of(context).textTheme.headline1!,
                      progress: _animation.value,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                  return;
                }
                _controller.forward();
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomPainter extends CustomPainter {
  _CustomPainter({
    required this.text,
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

  final String text;
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
    if (oldDelegate is! _CustomPainter) {
      return false;
    }
    return oldDelegate.progress != progress || oldDelegate.text != text;
  }
}
