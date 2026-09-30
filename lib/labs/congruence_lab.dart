import 'dart:math' as math;

import 'package:flutter/gestures.dart'
    show
        Drag,
        DragEndDetails,
        DragUpdateDetails,
        ImmediateMultiDragGestureRecognizer;
import 'package:flutter/material.dart';
import '../games/area_grid_board.dart';

/// Original discovery activity based on G7 printed pages 169 and 174.
class CongruenceLab extends StatefulWidget {
  const CongruenceLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<CongruenceLab> createState() => _CongruenceLabState();
}

class _CongruenceLabState extends State<CongruenceLab> {
  Offset _translation = const Offset(-1, 1);
  int _rotation = 90;
  double _scale = 1;
  bool _motion = false;
  CongruenceTriangle get _triangle => CongruenceTriangle(
      scale: _scale,
      rotationDegrees: _rotation.toDouble(),
      translation: _translation);
  bool get _correct => _motion && _triangle.matches(const CongruenceTriangle());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _moveTo(Offset position) {
    final next =
        Offset(position.dx.clamp(-1.0, 1.0), position.dy.clamp(-1.0, 1.0));
    setState(() {
      _motion = _motion || (next - _translation).distance > 1e-8;
      _translation = next;
    });
    widget.onResult(_correct);
  }

  void _rotateTo(int angle) {
    final next = (angle % 360 + 360) % 360;
    setState(() {
      _motion = _motion || next != _rotation;
      _rotation = next;
    });
    widget.onResult(_correct);
  }

  void _resize(double scale) {
    setState(() => _scale = scale);
    widget.onResult(_correct);
  }

  void _reset() {
    setState(() {
      _translation = const Offset(-1, 1);
      _rotation = 90;
      _scale = 1;
      _motion = false;
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
              const Icon(Icons.change_history_rounded, color: geometryTeal),
              const SizedBox(width: 8),
              const Expanded(child: Text('3 · 4 · 5', style: geometryHeading)),
              _button('congruence-reset', Icons.replay_rounded,
                  'Reset triangle', _reset),
            ]),
            LayoutBuilder(builder: (context, constraints) {
              final size = Size(constraints.maxWidth, 244);
              final layout = _TriangleLayout(size);
              return RawGestureDetector(
                key: const ValueKey('congruence-canvas'),
                behavior: HitTestBehavior.opaque,
                gestures: {
                  ImmediateMultiDragGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          ImmediateMultiDragGestureRecognizer>(
                    () => ImmediateMultiDragGestureRecognizer(),
                    (recognizer) {
                      recognizer.onStart = (_) => _TriangleDrag(
                            onUpdate: (details) => _moveTo(
                                _translation + details.delta / layout.unit),
                            onEnd: () => _moveTo(Offset(
                                (_translation.dx * 2).round() / 2,
                                (_translation.dy * 2).round() / 2)),
                          );
                    },
                  ),
                },
                child: Semantics(
                  label:
                      'Move and rotate the triangle onto the outlined triangle. '
                      'Changing size keeps its angles but changes its side lengths.',
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: CustomPaint(
                        painter: _CongruencePainter(
                            triangle: _triangle,
                            correct: _correct,
                            hint: widget.showHint)),
                  ),
                ),
              );
            }),
            GeometryBadge(
                key: const ValueKey('congruence-side-lengths'),
                text: _triangle.sideLengths.map(_number).join(' · '),
                icon: Icons.touch_app_rounded,
                color: geometryCoral),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _button('congruence-left', Icons.arrow_back_rounded, 'Move left',
                  () => _moveTo(_translation + const Offset(-.5, 0))),
              _button(
                  'congruence-right',
                  Icons.arrow_forward_rounded,
                  'Move right',
                  () => _moveTo(_translation + const Offset(.5, 0))),
              _button('congruence-up', Icons.arrow_upward_rounded, 'Move up',
                  () => _moveTo(_translation + const Offset(0, -.5))),
              _button(
                  'congruence-down',
                  Icons.arrow_downward_rounded,
                  'Move down',
                  () => _moveTo(_translation + const Offset(0, .5))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              _button('congruence-rotate-left', Icons.rotate_left_rounded,
                  'Rotate left 45 degrees', () => _rotateTo(_rotation - 45)),
              Expanded(
                  child: Text('$_rotation°',
                      textAlign: TextAlign.center, style: geometryHeading)),
              _button('congruence-rotate-right', Icons.rotate_right_rounded,
                  'Rotate right 45 degrees', () => _rotateTo(_rotation + 45)),
            ]),
            Slider(
                key: const ValueKey('congruence-rotation-slider'),
                min: 0,
                max: 315,
                divisions: 7,
                value: _rotation.toDouble(),
                label: '$_rotation°',
                activeColor: geometryTeal,
                onChanged: (value) => _rotateTo(value.round())),
            Row(children: [
              Expanded(child: _scaleButton('congruence-scale-original', 1)),
              const SizedBox(width: 8),
              Expanded(child: _scaleButton('congruence-scale-large', 1.5)),
            ]),
            if (_correct) ...[
              const SizedBox(height: 12),
              Container(
                key: const ValueKey('congruence-correspondence'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFDDEFE5),
                    borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  const Text('RRR · SSS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: geometryTeal,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                  const SizedBox(height: 8),
                  for (final (side, color) in [
                    (3, geometryCoral),
                    (4, geometryTeal),
                    (5, const Color(0xFF99720C))
                  ])
                    Text('$side = $side',
                        style: TextStyle(
                            color: color,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                ]),
              ),
            ],
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              Container(
                key: const ValueKey('congruence-hint'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF0CD),
                    borderRadius: BorderRadius.circular(12)),
                child: const Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Icon(Icons.open_with_rounded, color: Color(0xFF8A640B)),
                      Icon(Icons.rotate_left_rounded, color: Color(0xFF8A640B)),
                      Text('× 1',
                          style: TextStyle(
                              color: Color(0xFF8A640B),
                              fontWeight: FontWeight.w800,
                              fontSize: 18)),
                    ]),
              ),
            ],
          ],
        ),
      );

  Widget _button(
          String key, IconData icon, String label, VoidCallback action) =>
      SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
              key: ValueKey(key),
              tooltip: label,
              onPressed: action,
              icon: Icon(icon, color: geometryTeal)));

  Widget _scaleButton(String key, double scale) => OutlinedButton(
        key: ValueKey(key),
        onPressed: () => _resize(scale),
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            foregroundColor: geometryTeal,
            backgroundColor:
                _scale == scale ? const Color(0xFFDDEFE5) : Colors.white,
            side: BorderSide(
                color:
                    _scale == scale ? geometryTeal : const Color(0xFFBDCDC4)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text('× ${_number(scale)}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      );
}

/// The vertex order is fixed, so rotations never exchange corresponding sides.
class CongruenceTriangle {
  const CongruenceTriangle(
      {this.scale = 1,
      this.rotationDegrees = 0,
      this.translation = Offset.zero})
      : assert(scale > 0);
  final double scale;
  final double rotationDegrees;
  final Offset translation;

  List<Offset> get vertices {
    final angle = rotationDegrees * math.pi / 180;
    return const [Offset(-4 / 3, -1), Offset(8 / 3, -1), Offset(-4 / 3, 2)]
        .map((vertex) {
      final point = vertex * scale;
      return translation +
          Offset(point.dx * math.cos(angle) - point.dy * math.sin(angle),
              point.dx * math.sin(angle) + point.dy * math.cos(angle));
    }).toList();
  }

  List<double> get sideLengths {
    final points = vertices;
    return [
      (points[0] - points[2]).distance,
      (points[0] - points[1]).distance,
      (points[1] - points[2]).distance
    ];
  }

  List<double> get angleDegrees {
    final points = vertices;
    return List.generate(3, (index) {
      final first = points[(index + 1) % 3] - points[index];
      final second = points[(index + 2) % 3] - points[index];
      return math.acos(((first.dx * second.dx + first.dy * second.dy) /
                  (first.distance * second.distance))
              .clamp(-1.0, 1.0)) *
          180 /
          math.pi;
    });
  }

  bool matches(CongruenceTriangle other) {
    final mine = vertices;
    final theirs = other.vertices;
    return List.generate(3, (index) => (mine[index] - theirs[index]).distance)
        .every((distance) => distance < .06);
  }
}

String _number(double value) => (value - value.round()).abs() < 1e-8
    ? '${value.round()}'
    : value.toStringAsFixed(1);

class _TriangleDrag extends Drag {
  _TriangleDrag({required this.onUpdate, required this.onEnd});
  final ValueChanged<DragUpdateDetails> onUpdate;
  final VoidCallback onEnd;

  @override
  void update(DragUpdateDetails details) => onUpdate(details);
  @override
  void end(DragEndDetails details) => onEnd();
  @override
  void cancel() => onEnd();
}

class _TriangleLayout {
  _TriangleLayout(Size size)
      : unit = math.min(size.width - 26, size.height - 26) / 10.6,
        center = Offset(size.width / 2, size.height / 2);
  final double unit;
  final Offset center;
  Offset pixel(Offset point) => center + point * unit;
}

class _CongruencePainter extends CustomPainter {
  const _CongruencePainter(
      {required this.triangle, required this.correct, required this.hint});
  final CongruenceTriangle triangle;
  final bool correct;
  final bool hint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final layout = _TriangleLayout(size);
    final grid = Paint()..color = geometryTeal.withOpacity(.12);
    for (double x = -4.5; x <= 4.5; x += .5) {
      for (double y = -4.5; y <= 4.5; y += .5) {
        canvas.drawCircle(layout.pixel(Offset(x, y)), .75, grid);
      }
    }
    final target =
        const CongruenceTriangle().vertices.map(layout.pixel).toList();
    final moving = triangle.vertices.map(layout.pixel).toList();
    final targetPath = _path(target);
    canvas.drawPath(targetPath, Paint()..color = geometryTeal.withOpacity(.12));
    final outline = Paint()
      ..color = geometryTeal
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke;
    for (var edge = 0; edge < 3; edge++) {
      _dash(canvas, target[edge], target[(edge + 1) % 3], outline);
    }
    canvas.drawPath(
        _path(moving),
        Paint()
          ..color = (correct ? geometryTeal : geometryGold).withOpacity(.28));
    canvas.drawPath(
        _path(moving),
        Paint()
          ..color = correct ? geometryTeal : geometryCoral
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.7);
    for (final vertex in moving) {
      canvas.drawCircle(
          vertex, 4, Paint()..color = correct ? geometryTeal : geometryCoral);
    }
    if (!correct) {
      _sideLabels(
          canvas, target, layout.center, const [4.0, 5.0, 3.0], geometryTeal);
      final lengths = triangle.sideLengths;
      _sideLabels(canvas, moving, layout.pixel(triangle.translation),
          [lengths[1], lengths[2], lengths[0]], geometryCoral);
    } else {
      _sideLabels(
          canvas, moving, layout.center, const [4.0, 5.0, 3.0], geometryTeal);
      for (var edge = 0; edge < 3; edge++) {
        final start = moving[edge];
        final end = moving[(edge + 1) % 3];
        final along = (end - start) / (end - start).distance;
        final normal = Offset(-along.dy, along.dx);
        for (var tick = 0; tick <= edge; tick++) {
          final midpoint = (start + end) / 2 + along * (tick - edge / 2) * 4;
          canvas.drawLine(
              midpoint - normal * 4,
              midpoint + normal * 4,
              Paint()
                ..color = geometryTeal
                ..strokeWidth = 2);
        }
      }
    }
    if (hint && triangle.translation.distance > .05) {
      final start = layout.pixel(triangle.translation);
      final end = layout.center;
      final direction = (end - start) / (end - start).distance;
      final normal = Offset(-direction.dy, direction.dx);
      final arrow = Paint()
        ..color = const Color(0xFFAC821D)
        ..strokeWidth = 2;
      canvas.drawLine(start, end, arrow);
      canvas.drawLine(end, end - direction * 8 + normal * 4, arrow);
      canvas.drawLine(end, end - direction * 8 - normal * 4, arrow);
    }
  }

  Path _path(List<Offset> points) => Path()
    ..moveTo(points[0].dx, points[0].dy)
    ..lineTo(points[1].dx, points[1].dy)
    ..lineTo(points[2].dx, points[2].dy)
    ..close();

  void _sideLabels(Canvas canvas, List<Offset> points, Offset center,
      List<double> sides, Color color) {
    for (var edge = 0; edge < 3; edge++) {
      final midpoint = (points[edge] + points[(edge + 1) % 3]) / 2;
      final away = midpoint - center;
      final location = midpoint + away / away.distance * 15;
      final text = TextPainter(
          text: TextSpan(
              text: _number(sides[edge]),
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.w800)),
          textDirection: TextDirection.ltr)
        ..layout();
      final label = Rect.fromCenter(
          center: location, width: text.width + 6, height: text.height + 4);
      canvas.drawRRect(RRect.fromRectAndRadius(label, const Radius.circular(4)),
          Paint()..color = const Color(0xFFF6FAF6).withOpacity(.92));
      text.paint(canvas, location - Offset(text.width / 2, text.height / 2));
    }
  }

  void _dash(Canvas canvas, Offset start, Offset end, Paint paint) {
    final length = (end - start).distance;
    final direction = (end - start) / length;
    for (double offset = 0; offset < length; offset += 10) {
      canvas.drawLine(start + direction * offset,
          start + direction * math.min(offset + 6, length), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CongruencePainter oldDelegate) =>
      oldDelegate.triangle.translation != triangle.translation ||
      oldDelegate.triangle.rotationDegrees != triangle.rotationDegrees ||
      oldDelegate.triangle.scale != triangle.scale ||
      oldDelegate.correct != correct ||
      oldDelegate.hint != hint;
}
