import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../learning/scenarios.dart';
import 'area_grid_board.dart';

class SimilarityBoard extends StatefulWidget {
  const SimilarityBoard({
    super.key,
    required this.scenario,
    required this.onResult,
    this.showHint = false,
  });
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<SimilarityBoard> createState() => _SimilarityBoardState();
}

class _SimilarityBoardState extends State<SimilarityBoard> {
  int _width = 1;
  int _height = 1;
  int get _baseWidth => widget.scenario.values['width']!;
  int get _baseHeight => widget.scenario.values['height']!;
  int get _scale => widget.scenario.values['scale']!;
  int get _targetWidth => _baseWidth * _scale;
  int get _targetHeight => _baseHeight * _scale;
  bool get _correct => _width == _targetWidth && _height == _targetHeight;

  @override
  void initState() {
    super.initState();
    _reportReset();
  }

  @override
  void didUpdateWidget(covariant SimilarityBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      _width = 1;
      _height = 1;
      _reportReset();
    }
  }

  void _reportReset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(_correct);
    });
  }

  void _resize({int? width, int? height}) {
    setState(() {
      _width = (width ?? _width).clamp(1, _targetWidth + _baseWidth);
      _height = (height ?? _height).clamp(1, _targetHeight + _baseHeight);
    });
    widget.onResult(_correct);
  }

  @override
  Widget build(BuildContext context) => GeometryBoardFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Icon(Icons.aspect_ratio_rounded, color: geometryTeal),
              const SizedBox(width: 10),
              Expanded(
                  child: Text('$_baseWidth × $_baseHeight',
                      style: geometryHeading)),
              GeometryBadge(
                  text: '× $_scale',
                  icon: Icons.open_in_full_rounded,
                  color: geometryTeal),
            ]),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (context, constraints) {
              final size = Size(constraints.maxWidth, 204);
              final layout = _ShapeLayout(
                  size, _targetWidth + _baseWidth, _targetHeight + _baseHeight);
              return Semantics(
                label: 'Resize both sides by the scale factor $_scale',
                child: GestureDetector(
                  key: const ValueKey('similarity-canvas'),
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) => _resize(
                    width: ((details.localPosition.dx - layout.right.dx) /
                            layout.unit)
                        .round(),
                    height: ((layout.right.dy - details.localPosition.dy) /
                            layout.unit)
                        .round(),
                  ),
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: CustomPaint(
                      painter: _SimilarityPainter(
                          baseWidth: _baseWidth,
                          baseHeight: _baseHeight,
                          scale: _scale,
                          width: _width,
                          height: _height),
                    ),
                  ),
                ),
              );
            }),
            Row(children: [
              Expanded(
                  child: Text('$_baseWidth → $_width',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: geometryTeal))),
              Text('$_baseHeight → $_height',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: geometryCoral)),
            ]),
            const SizedBox(height: 8),
            GeometryStepper(
                keyPrefix: 'similarity-width',
                label: 'Width',
                icon: Icons.swap_horiz_rounded,
                value: _width,
                onMinus: _width > 1 ? () => _resize(width: _width - 1) : null,
                onPlus: _width < _targetWidth + _baseWidth
                    ? () => _resize(width: _width + 1)
                    : null),
            GeometryStepper(
                keyPrefix: 'similarity-height',
                label: 'Height',
                icon: Icons.swap_vert_rounded,
                value: _height,
                onMinus:
                    _height > 1 ? () => _resize(height: _height - 1) : null,
                onPlus: _height < _targetHeight + _baseHeight
                    ? () => _resize(height: _height + 1)
                    : null),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: _correct
                      ? const Color(0xFFDDEFE5)
                      : const Color(0xFFE8EDE6),
                  borderRadius: BorderRadius.circular(12)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$_width × $_height',
                    key: const ValueKey('similarity-dimensions'),
                    style: geometryHeading),
                if (_correct) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_rounded, color: geometryTeal),
                ],
              ]),
            ),
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              GeometryHint(
                  key: const ValueKey('similarity-hint'),
                  text:
                      '$_baseWidth × $_scale = ?   ·   $_baseHeight × $_scale = ?'),
            ],
          ],
        ),
      );
}

class _ShapeLayout {
  _ShapeLayout(Size size, int maxWidth, int maxHeight)
      : unit = math.min(
            (size.width * .58 - 22) / maxWidth, (size.height - 38) / maxHeight),
        left = Offset(8, size.height - 24),
        right = Offset(size.width * .42, size.height - 24);

  final double unit;
  final Offset left;
  final Offset right;
}

class _SimilarityPainter extends CustomPainter {
  const _SimilarityPainter({
    required this.baseWidth,
    required this.baseHeight,
    required this.scale,
    required this.width,
    required this.height,
  });
  final int baseWidth;
  final int baseHeight;
  final int scale;
  final int width;
  final int height;

  @override
  void paint(Canvas canvas, Size size) {
    final targetWidth = baseWidth * scale;
    final targetHeight = baseHeight * scale;
    final layout =
        _ShapeLayout(size, targetWidth + baseWidth, targetHeight + baseHeight);
    final original = Rect.fromLTWH(
        layout.left.dx,
        layout.left.dy - baseHeight * layout.unit,
        baseWidth * layout.unit,
        baseHeight * layout.unit);
    final target = Rect.fromLTWH(
        layout.right.dx,
        layout.right.dy - targetHeight * layout.unit,
        targetWidth * layout.unit,
        targetHeight * layout.unit);
    final current = Rect.fromLTWH(
        layout.right.dx,
        layout.right.dy - height * layout.unit,
        width * layout.unit,
        height * layout.unit);
    final proportional = width * baseHeight == height * baseWidth;
    canvas.drawRect(original, Paint()..color = geometryTeal.withOpacity(.75));
    canvas.drawRect(target, Paint()..color = geometryGold.withOpacity(.13));
    canvas.drawRect(
        current,
        Paint()
          ..color =
              (proportional ? geometryTeal : geometryCoral).withOpacity(.70));
    _grid(canvas, original, layout.unit, baseWidth, baseHeight);
    _grid(canvas, current, layout.unit, width, height);
    final dashed = Paint()
      ..color = const Color(0xFF98720C)
      ..strokeWidth = 2;
    _dash(canvas, target.topLeft, target.topRight, dashed);
    _dash(canvas, target.topRight, target.bottomRight, dashed);
    _dash(canvas, target.bottomRight, target.bottomLeft, dashed);
    _dash(canvas, target.bottomLeft, target.topLeft, dashed);
    canvas.drawCircle(current.topRight, 9, Paint()..color = geometryGold);
    canvas.drawCircle(
        current.topRight,
        9,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    _label(canvas, '× $scale', Offset(size.width * .34, size.height - 65));
    _label(
        canvas, '$baseWidth', Offset(original.center.dx, original.bottom + 14));
    _label(canvas, '$width', Offset(current.center.dx, current.bottom + 14));
  }

  void _grid(Canvas canvas, Rect rect, double unit, int columns, int rows) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.40)
      ..strokeWidth = 1;
    for (var i = 1; i < columns; i++) {
      canvas.drawLine(Offset(rect.left + i * unit, rect.top),
          Offset(rect.left + i * unit, rect.bottom), paint);
    }
    for (var i = 1; i < rows; i++) {
      canvas.drawLine(Offset(rect.left, rect.top + i * unit),
          Offset(rect.right, rect.top + i * unit), paint);
    }
  }

  void _dash(Canvas canvas, Offset start, Offset end, Paint paint) {
    final distance = (end - start).distance;
    if (distance == 0) return;
    final direction = (end - start) / distance;
    for (double offset = 0; offset < distance; offset += 9) {
      canvas.drawLine(start + direction * offset,
          start + direction * math.min(offset + 5, distance), paint);
    }
  }

  void _label(Canvas canvas, String value, Offset center) {
    final painter = TextPainter(
        text: TextSpan(
            text: value,
            style: const TextStyle(
                color: Color(0xFF29473D),
                fontSize: 14,
                fontWeight: FontWeight.w800)),
        textDirection: TextDirection.ltr)
      ..layout();
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _SimilarityPainter oldDelegate) =>
      oldDelegate.baseWidth != baseWidth ||
      oldDelegate.baseHeight != baseHeight ||
      oldDelegate.scale != scale ||
      oldDelegate.width != width ||
      oldDelegate.height != height;
}
