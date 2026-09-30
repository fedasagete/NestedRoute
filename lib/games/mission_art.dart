import 'package:flutter/material.dart';

/// Bundled vector pieces: no emoji font or network image is needed to play.
class BananaToken extends StatelessWidget {
  const BananaToken({super.key, this.size = 32, this.ghost = false});
  final double size;
  final bool ghost;
  @override
  Widget build(BuildContext context) => Opacity(
      opacity: ghost ? .22 : 1,
      child: CustomPaint(size: Size.square(size), painter: _BananaPainter()));
}

class _BananaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 40, size.height / 40);
    final banana = Path()
      ..moveTo(7, 10)
      ..quadraticBezierTo(16, 30, 34, 11)
      ..quadraticBezierTo(34, 31, 19, 34)
      ..quadraticBezierTo(4, 32, 7, 10);
    canvas.drawPath(banana, Paint()..color = const Color(0xffffcb49));
    canvas.drawPath(
        banana,
        Paint()
          ..color = const Color(0xffb87c2d)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6);
    canvas.drawPath(
        Path()
          ..moveTo(9, 15)
          ..quadraticBezierTo(16, 34, 31, 18),
        Paint()
          ..color = const Color(0xffefa82e)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8);
    canvas.drawLine(
        const Offset(7, 10),
        const Offset(6, 6),
        Paint()
          ..color = const Color(0xff775139)
          ..strokeWidth = 3);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BananaPainter oldDelegate) => false;
}

class MissionPerson extends StatelessWidget {
  const MissionPerson(
      {super.key,
      this.size = 60,
      this.happy = false,
      this.color = const Color(0xff477e75)});
  final double size;
  final bool happy;
  final Color color;
  @override
  Widget build(BuildContext context) => CustomPaint(
      size: Size(size, size), painter: _PersonPainter(happy, color));
}

class _PersonPainter extends CustomPainter {
  const _PersonPainter(this.happy, this.color);
  final bool happy;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 60, size.height / 60);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(10, 35, 40, 26), const Radius.circular(16)),
        Paint()..color = color);
    canvas.drawCircle(
        const Offset(30, 22), 18, Paint()..color = const Color(0xff593e30));
    canvas.drawOval(const Rect.fromLTWH(15, 12, 30, 31),
        Paint()..color = const Color(0xffbf865b));
    canvas.drawArc(
        const Rect.fromLTWH(12, 4, 36, 26),
        3.14,
        3.14,
        false,
        Paint()
          ..color = const Color(0xff302820)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7);
    for (final x in [24.0, 36.0]) {
      canvas.drawCircle(
          Offset(x, 24), 1.8, Paint()..color = const Color(0xff33251f));
    }
    final smile = Paint()
      ..color = const Color(0xff63392d)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    if (happy) {
      canvas.drawArc(const Rect.fromLTWH(23, 26, 14, 9), 0, 3.14, false, smile);
    } else {
      canvas.drawLine(const Offset(26, 33), const Offset(34, 33), smile);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PersonPainter oldDelegate) =>
      happy != oldDelegate.happy || color != oldDelegate.color;
}

class MissionBasket extends StatelessWidget {
  const MissionBasket({super.key, required this.child, this.complete = false});
  final Widget child;
  final bool complete;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: complete ? const Color(0xffedf4d9) : const Color(0xfffff0d7),
          border: Border.all(
              color:
                  complete ? const Color(0xff789d57) : const Color(0xffc99154),
              width: 2),
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10), bottom: Radius.circular(22))),
      child: child);
}
