import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../learning/scenarios.dart';
import 'area_grid_board.dart';

class VolumeBoard extends StatefulWidget {
  const VolumeBoard({
    super.key,
    required this.scenario,
    required this.onResult,
    this.showHint = false,
  });
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<VolumeBoard> createState() => _VolumeBoardState();
}

class _VolumeBoardState extends State<VolumeBoard> {
  int _width = 1;
  int _depth = 1;
  int _height = 0;
  int get _targetWidth => widget.scenario.values['width']!;
  int get _targetDepth => widget.scenario.values['depth']!;
  int get _targetHeight => widget.scenario.values['height']!;
  bool get _correct =>
      _width == _targetWidth &&
      _depth == _targetDepth &&
      _height == _targetHeight;

  @override
  void initState() {
    super.initState();
    _reportReset();
  }

  @override
  void didUpdateWidget(covariant VolumeBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      _width = 1;
      _depth = 1;
      _height = 0;
      _reportReset();
    }
  }

  void _reportReset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _resize({int? width, int? depth, int? height}) {
    setState(() {
      _width = (width ?? _width).clamp(1, _targetWidth + 2);
      _depth = (depth ?? _depth).clamp(1, _targetDepth + 2);
      _height = (height ?? _height).clamp(0, _targetHeight + 2);
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
              const Icon(Icons.view_in_ar_rounded, color: geometryTeal),
              const SizedBox(width: 10),
              const Text('Qabee', style: geometryHeading),
              const Spacer(),
              if (_correct)
                const Icon(Icons.check_circle_rounded, color: geometryTeal),
            ]),
            const SizedBox(height: 10),
            GeometryBadge(
                text: '$_targetWidth × $_targetDepth × $_targetHeight',
                icon: Icons.open_in_full_rounded,
                color: geometryTeal),
            const SizedBox(height: 6),
            Semantics(
              label: '$_height layers of ${_width * _depth} unit cubes',
              child: SizedBox(
                key: const ValueKey('volume-cubes'),
                height: 216,
                child: CustomPaint(
                  painter: _VolumePainter(
                    width: _width,
                    depth: _depth,
                    height: _height,
                    targetWidth: _targetWidth,
                    targetDepth: _targetDepth,
                    targetHeight: _targetHeight,
                  ),
                ),
              ),
            ),
            GeometryBadge(
                key: const ValueKey('volume-layer-count'),
                text: '${_width * _depth} □ × $_height',
                icon: Icons.layers_rounded,
                color: geometryTeal),
            const SizedBox(height: 6),
            GeometryStepper(
                keyPrefix: 'volume-width',
                label: 'Base width',
                icon: Icons.swap_horiz_rounded,
                value: _width,
                onMinus: _width > 1 ? () => _resize(width: _width - 1) : null,
                onPlus: _width < _targetWidth + 2
                    ? () => _resize(width: _width + 1)
                    : null),
            GeometryStepper(
                keyPrefix: 'volume-depth',
                label: 'Base depth',
                icon: Icons.unfold_more_rounded,
                value: _depth,
                onMinus: _depth > 1 ? () => _resize(depth: _depth - 1) : null,
                onPlus: _depth < _targetDepth + 2
                    ? () => _resize(depth: _depth + 1)
                    : null),
            GeometryStepper(
                keyPrefix: 'volume-height',
                label: 'Layers',
                icon: Icons.layers_rounded,
                value: _height,
                onMinus:
                    _height > 0 ? () => _resize(height: _height - 1) : null,
                onPlus: _height < _targetHeight + 2
                    ? () => _resize(height: _height + 1)
                    : null),
            const SizedBox(height: 10),
            Container(
              key: const ValueKey('volume-count'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: _correct
                      ? const Color(0xFFDDEFE5)
                      : const Color(0xFFE8EDE6),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                '$_width × $_depth × $_height = ${_width * _depth * _height}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF193A35)),
              ),
            ),
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              GeometryHint(
                  key: const ValueKey('volume-hint'),
                  text: '$_targetWidth × $_targetDepth □   →   '
                      '${_targetWidth * _targetDepth} □ × $_targetHeight'),
            ],
          ],
        ),
      );
}

class _VolumePainter extends CustomPainter {
  const _VolumePainter({
    required this.width,
    required this.depth,
    required this.height,
    required this.targetWidth,
    required this.targetDepth,
    required this.targetHeight,
  });
  final int width;
  final int depth;
  final int height;
  final int targetWidth;
  final int targetDepth;
  final int targetHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = math.max(width, targetWidth);
    final maxDepth = math.max(depth, targetDepth);
    final maxHeight = math.max(height, targetHeight);
    final unit = math.min(
        48.0,
        math.min((size.width - 26) * 2 / (maxWidth + maxDepth),
            (size.height - 24) / ((maxWidth + maxDepth) / 4 + maxHeight * .7)));
    final origin = Offset(size.width / 2 - (maxWidth - maxDepth) * unit / 4,
        size.height - 16 - (maxWidth + maxDepth) * unit / 4);
    Offset point(num x, num y, num z) =>
        origin + Offset((x - y) * unit / 2, (x + y) * unit / 4 - z * unit * .7);

    final ghost = Paint()
      ..color = geometryGold.withOpacity(.65)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final targetBase = [
      point(0, 0, 0),
      point(targetWidth, 0, 0),
      point(targetWidth, targetDepth, 0),
      point(0, targetDepth, 0),
    ];
    canvas.drawPath(
        _polygon(targetBase), Paint()..color = geometryGold.withOpacity(.10));
    final targetTop = [
      point(0, 0, targetHeight),
      point(targetWidth, 0, targetHeight),
      point(targetWidth, targetDepth, targetHeight),
      point(0, targetDepth, targetHeight),
    ];
    canvas.drawPath(_polygon(targetBase), ghost);
    canvas.drawPath(_polygon(targetTop), ghost);
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(targetBase[i], targetTop[i], ghost);
    }

    for (var row = 0; row < depth; row++) {
      for (var column = 0; column < width; column++) {
        canvas.drawPath(
            _polygon([
              point(column, row, 0),
              point(column + 1, row, 0),
              point(column + 1, row + 1, 0),
              point(column, row + 1, 0),
            ]),
            Paint()
              ..color = geometryTeal.withOpacity(.45)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.3);
      }
    }
    for (var layer = 0; layer < height; layer++) {
      for (var row = 0; row < depth; row++) {
        for (var column = 0; column < width; column++) {
          final top = [
            point(column, row, layer + 1),
            point(column + 1, row, layer + 1),
            point(column + 1, row + 1, layer + 1),
            point(column, row + 1, layer + 1),
          ];
          final right = [
            top[1],
            top[2],
            point(column + 1, row + 1, layer),
            point(column + 1, row, layer),
          ];
          final front = [
            top[2],
            top[3],
            point(column, row + 1, layer),
            point(column + 1, row + 1, layer),
          ];
          _face(canvas, right,
              layer.isEven ? const Color(0xFF218E80) : const Color(0xFF409D89));
          _face(canvas, front,
              layer.isEven ? const Color(0xFF66B7A1) : const Color(0xFF80C5A9));
          _face(canvas, top,
              layer.isEven ? const Color(0xFFA8DCC6) : const Color(0xFFC4E8CF));
        }
      }
    }
  }

  Path _polygon(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  void _face(Canvas canvas, List<Offset> points, Color color) {
    final path = _polygon(points);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFF3FFF4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = .85);
  }

  @override
  bool shouldRepaint(covariant _VolumePainter oldDelegate) =>
      oldDelegate.width != width ||
      oldDelegate.depth != depth ||
      oldDelegate.height != height ||
      oldDelegate.targetWidth != targetWidth ||
      oldDelegate.targetDepth != targetDepth ||
      oldDelegate.targetHeight != targetHeight;
}
