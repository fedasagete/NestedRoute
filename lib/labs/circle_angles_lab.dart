import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../games/area_grid_board.dart';

class CircleAnglesLab extends StatefulWidget {
  const CircleAnglesLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<CircleAnglesLab> createState() => _CircleAnglesLabState();
}

class _CircleAnglesLabState extends State<CircleAnglesLab> {
  double _point = 90;
  int _measure = 0;
  bool _moved = false;
  bool get _correct => _measure == 50 && _moved;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _setMeasure(int value) {
    setState(() => _measure = value.clamp(0, 100));
    widget.onResult(_correct);
  }

  void _movePoint(double value) {
    setState(() {
      _point = value.clamp(20, 160);
      _moved = _moved || (_point - 90).abs() >= 10;
    });
    widget.onResult(_correct);
  }

  void _reset() {
    setState(() {
      _point = 90;
      _measure = 0;
      _moved = false;
    });
    widget.onResult(false);
  }

  @override
  Widget build(BuildContext context) => GeometryBoardFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Expanded(
                  child: Text('Geengoo · Kofa', style: geometryHeading)),
              IconButton(
                  key: const ValueKey('circle-reset'),
                  tooltip: 'Reset angles',
                  onPressed: _reset,
                  icon: const Icon(Icons.replay_rounded, color: geometryTeal)),
            ]),
            LayoutBuilder(builder: (context, constraints) {
              final size = Size(constraints.maxWidth, 256);
              return GestureDetector(
                key: const ValueKey('circle-diagram'),
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  final center = Offset(size.width / 2, size.height / 2);
                  final relative = details.localPosition - center;
                  _movePoint(
                      math.atan2(relative.dy, relative.dx) * 180 / math.pi);
                },
                child: Semantics(
                  label: 'Move the point around the lower arc. '
                      'Both lines meet the same two arc endpoints.',
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: CustomPaint(
                        painter:
                            _CirclePainter(point: _point, measure: _measure)),
                  ),
                ),
              );
            }),
            Wrap(spacing: 8, runSpacing: 8, children: [
              const GeometryBadge(
                  text: '100°',
                  icon: Icons.circle_outlined,
                  color: geometryTeal),
              GeometryBadge(
                  text: '$_measure°',
                  icon: Icons.touch_app_rounded,
                  color: geometryCoral),
              GeometryBadge(
                  text: '● ↔ ●',
                  icon: _moved
                      ? Icons.check_circle_rounded
                      : Icons.pan_tool_alt_rounded,
                  color: _moved ? geometryTeal : const Color(0xFF9E710B)),
            ]),
            const SizedBox(height: 10),
            GeometryStepper(
                keyPrefix: 'circle-measure',
                label: 'Inscribed angle',
                icon: Icons.architecture_rounded,
                value: _measure,
                suffix: '°',
                onMinus: _measure > 0 ? () => _setMeasure(_measure - 1) : null,
                onPlus:
                    _measure < 100 ? () => _setMeasure(_measure + 1) : null),
            Slider(
                key: const ValueKey('circle-measure-slider'),
                value: _measure.toDouble(),
                max: 100,
                divisions: 100,
                label: '$_measure°',
                activeColor: geometryTeal,
                onChanged: (value) => _setMeasure(value.round())),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                      key: const ValueKey('circle-point-left'),
                      tooltip: 'Move point left',
                      onPressed: () => _movePoint(_point + 20),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: geometryTeal))),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.touch_app_rounded, color: geometryCoral)),
              SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                      key: const ValueKey('circle-point-right'),
                      tooltip: 'Move point right',
                      onPressed: () => _movePoint(_point - 20),
                      icon: const Icon(Icons.arrow_forward_rounded,
                          color: geometryTeal))),
              if (_correct)
                const Icon(Icons.check_circle_rounded, color: geometryTeal),
            ]),
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              const GeometryHint(
                  key: ValueKey('circle-hint'),
                  text: '100° = ?° + ?°   ·   ● ↔ ●'),
            ],
          ],
        ),
      );
}

/// Unit-circle points shared by the drawing and numerical angle checks.
/// The movable point stays on the major arc opposite the fixed 100° arc.
class CircleAngleGeometry {
  CircleAngleGeometry(this.pointDegrees)
      : assert(pointDegrees >= 20 && pointDegrees <= 160);
  final double pointDegrees;
  Offset get first => _onCircle(-140);
  Offset get second => _onCircle(-40);
  Offset get point => _onCircle(pointDegrees);
  double get centralDegrees => _angle(first, second);
  double get inscribedDegrees => _angle(first - point, second - point);

  Offset _onCircle(double degrees) => Offset(
      math.cos(degrees * math.pi / 180), math.sin(degrees * math.pi / 180));

  double _angle(Offset first, Offset second) =>
      math.acos(((first.dx * second.dx + first.dy * second.dy) /
              (first.distance * second.distance))
          .clamp(-1.0, 1.0)) *
      180 /
      math.pi;
}

class _CirclePainter extends CustomPainter {
  const _CirclePainter({required this.point, required this.measure});
  final double point;
  final int measure;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 22;
    final geometry = CircleAngleGeometry(point);
    final first = center + geometry.first * radius;
    final second = center + geometry.second * radius;
    final moving = center + geometry.point * radius;
    final circle = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFEDF4EC));
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = geometryTeal.withOpacity(.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawArc(
        circle,
        -140 * math.pi / 180,
        geometry.centralDegrees * math.pi / 180,
        false,
        Paint()
          ..color = geometryGold
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke);
    final centralSector = Rect.fromCircle(center: center, radius: radius * .38);
    canvas.drawArc(
        centralSector,
        -140 * math.pi / 180,
        geometry.centralDegrees * math.pi / 180,
        true,
        Paint()..color = geometryTeal.withOpacity(.20));
    final centralRay = Paint()
      ..color = geometryTeal
      ..strokeWidth = 2;
    canvas.drawLine(center, first, centralRay);
    canvas.drawLine(center, second, centralRay);
    final chord = Paint()
      ..color = geometryCoral
      ..strokeWidth = 2.7;
    canvas.drawLine(moving, first, chord);
    canvas.drawLine(moving, second, chord);
    final firstDirection =
        math.atan2(first.dy - moving.dy, first.dx - moving.dx);
    final secondDirection =
        math.atan2(second.dy - moving.dy, second.dx - moving.dx);
    var sweep = secondDirection - firstDirection;
    while (sweep < -math.pi) {
      sweep += 2 * math.pi;
    }
    while (sweep > math.pi) {
      sweep -= 2 * math.pi;
    }
    final arcRadius = math.min(38.0, radius * .38);
    canvas.drawArc(
        Rect.fromCircle(center: moving, radius: arcRadius),
        firstDirection,
        sweep,
        true,
        Paint()..color = geometryCoral.withOpacity(.17));
    for (var tick = 0; tick <= 100; tick += 10) {
      final angle = firstDirection + tick * math.pi / 180 * sweep.sign;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
          moving + direction * (arcRadius - 4),
          moving + direction * (arcRadius + 2),
          Paint()
            ..color = geometryTeal.withOpacity(.6)
            ..strokeWidth = 1.2);
      if (tick % 30 == 0) {
        final label = moving + direction * (arcRadius + 12);
        _label(canvas, '$tick', label, 11, geometryTeal, bounds: size);
      }
    }
    final measuredAngle = firstDirection + measure * math.pi / 180 * sweep.sign;
    final needle = moving +
        Offset(math.cos(measuredAngle), math.sin(measuredAngle)) *
            (arcRadius + 3);
    canvas.drawLine(
        moving,
        needle,
        Paint()
          ..color = const Color(0xFF8F6809)
          ..strokeWidth = 3);
    canvas.drawCircle(needle, 4, Paint()..color = geometryGold);
    canvas.drawCircle(center, 4, Paint()..color = geometryTeal);
    canvas.drawCircle(first, 5, Paint()..color = geometryGold);
    canvas.drawCircle(second, 5, Paint()..color = geometryGold);
    canvas.drawCircle(moving, 8, Paint()..color = geometryCoral);
    canvas.drawCircle(
        moving,
        8,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    _label(canvas, '100°', center + Offset(0, -radius * .54), 16, geometryTeal);
  }

  void _label(
      Canvas canvas, String value, Offset center, double fontSize, Color color,
      {Size? bounds}) {
    final text = TextPainter(
        text: TextSpan(
            text: value,
            style: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.w800, color: color)),
        textDirection: TextDirection.ltr)
      ..layout();
    final half = Offset(text.width / 2, text.height / 2);
    final fitted = bounds == null
        ? center
        : Offset(center.dx.clamp(half.dx + 2, bounds.width - half.dx - 2),
            center.dy.clamp(half.dy + 2, bounds.height - half.dy - 2));
    text.paint(canvas, fitted - half);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) =>
      oldDelegate.point != point || oldDelegate.measure != measure;
}
