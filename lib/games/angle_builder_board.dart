import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../learning/scenarios.dart';
import 'area_grid_board.dart';

class AngleBuilderBoard extends StatefulWidget {
  const AngleBuilderBoard({
    super.key,
    required this.scenario,
    required this.onResult,
    this.showHint = false,
  });
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<AngleBuilderBoard> createState() => _AngleBuilderBoardState();
}

class _AngleBuilderBoardState extends State<AngleBuilderBoard> {
  int _angle = 0;
  int get _a => widget.scenario.values['a']!;
  int get _b => widget.scenario.values['b']!;
  int get _total => _a + _b + _angle;

  @override
  void initState() {
    super.initState();
    _reportReset();
  }

  @override
  void didUpdateWidget(covariant AngleBuilderBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      _angle = 0;
      _reportReset();
    }
  }

  void _reportReset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _setAngle(int angle) {
    setState(() => _angle = angle.clamp(0, 180));
    widget.onResult(_total == 180);
  }

  @override
  Widget build(BuildContext context) => GeometryBoardFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Icon(Icons.architecture_rounded, color: geometryTeal),
              const SizedBox(width: 10),
              const Expanded(
                  child: Text('Kofa · 180°', style: geometryHeading)),
              if (_total == 180)
                const Icon(Icons.check_circle_rounded, color: geometryTeal),
            ]),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (context, constraints) {
              final size = Size(constraints.maxWidth, 184);
              return Semantics(
                label: 'Join the three angles into a 180 degree straight line',
                child: GestureDetector(
                  key: const ValueKey('angle-dial'),
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) {
                    final center = Offset(size.width / 2, size.height - 25);
                    final touch = details.localPosition;
                    final degrees =
                        math.atan2(center.dy - touch.dy, center.dx - touch.dx) *
                            180 /
                            math.pi;
                    _setAngle((degrees - _a - _b).round());
                  },
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: CustomPaint(
                        painter: _AnglePainter(a: _a, b: _b, angle: _angle)),
                  ),
                ),
              );
            }),
            Wrap(spacing: 6, runSpacing: 6, children: [
              GeometryBadge(
                  text: '$_a°',
                  icon: Icons.pie_chart_rounded,
                  color: geometryTeal),
              GeometryBadge(
                  text: '$_b°',
                  icon: Icons.pie_chart_rounded,
                  color: geometryCoral),
              GeometryBadge(
                  text: '$_angle°',
                  icon: Icons.touch_app_rounded,
                  color: const Color(0xFF9E710B)),
            ]),
            const SizedBox(height: 10),
            GeometryStepper(
              keyPrefix: 'angle',
              label: 'Kofa',
              icon: Icons.rotate_right_rounded,
              value: _angle,
              suffix: '°',
              onMinus: _angle > 0 ? () => _setAngle(_angle - 1) : null,
              onPlus: _angle < 180 ? () => _setAngle(_angle + 1) : null,
            ),
            Slider(
              key: const ValueKey('angle-slider'),
              value: _angle.toDouble(),
              max: 180,
              divisions: 180,
              activeColor: geometryTeal,
              label: '$_angle°',
              semanticFormatterCallback: (value) => '${value.round()} degrees',
              onChanged: (value) => _setAngle(value.round()),
            ),
            Container(
              key: const ValueKey('angle-total'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: _total == 180
                      ? const Color(0xFFDDEFE5)
                      : const Color(0xFFE8EDE6),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('$_a° + $_b° + $_angle° = $_total°',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF193A35))),
            ),
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              GeometryHint(
                key: const ValueKey('angle-hint'),
                text: '180° − $_a° − $_b° = ?°',
              ),
            ],
          ],
        ),
      );
}

class _AnglePainter extends CustomPainter {
  const _AnglePainter({required this.a, required this.b, required this.angle});
  final int a;
  final int b;
  final int angle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final center = Offset(size.width / 2, size.height - 25);
    final radius = math.min(size.width / 2 - 12, size.height - 35);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
        rect, math.pi, math.pi, true, Paint()..color = const Color(0xFFE3EAE1));
    var start = math.pi;
    final values = [a, b, angle];
    final colors = [geometryTeal, geometryCoral, geometryGold];
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] * math.pi / 180;
      canvas.drawArc(rect, start, sweep, true,
          Paint()..color = colors[i].withOpacity(.84));
      canvas.drawLine(
          center,
          center + Offset(math.cos(start), math.sin(start)) * radius,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 3);
      if (values[i] > 14) {
        final location = center +
            Offset(math.cos(start + sweep / 2), math.sin(start + sweep / 2)) *
                radius *
                .65;
        _label(canvas, '${values[i]}°', location,
            i == 2 ? const Color(0xFF624A04) : Colors.white);
      }
      start += sweep;
    }
    canvas.drawArc(
        rect,
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = geometryTeal.withOpacity(.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawLine(
        Offset(center.dx - radius - 5, center.dy),
        Offset(center.dx + radius + 5, center.dy),
        Paint()
          ..color = const Color(0xFF29473D)
          ..strokeWidth = 3);
    final handle = center + Offset(math.cos(start), math.sin(start)) * radius;
    canvas.drawLine(
        center,
        handle,
        Paint()
          ..color = const Color(0xFF986E0B)
          ..strokeWidth = 3);
    canvas.drawCircle(handle, 8, Paint()..color = geometryGold);
    canvas.drawCircle(
        handle,
        8,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawCircle(center, 4, Paint()..color = const Color(0xFF29473D));
    _label(canvas, '180°', Offset(center.dx, center.dy + 16),
        const Color(0xFF29473D));
  }

  void _label(Canvas canvas, String value, Offset center, Color color) {
    final painter = TextPainter(
        text: TextSpan(
            text: value,
            style: TextStyle(
                color: color, fontSize: 15, fontWeight: FontWeight.w800)),
        textDirection: TextDirection.ltr)
      ..layout();
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _AnglePainter oldDelegate) =>
      oldDelegate.a != a || oldDelegate.b != b || oldDelegate.angle != angle;
}
