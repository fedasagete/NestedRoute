import 'dart:math' as math;

import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import '../games/area_grid_board.dart';

class PythagorasLab extends StatefulWidget {
  const PythagorasLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<PythagorasLab> createState() => _PythagorasLabState();
}

class _PythagorasLabState extends State<PythagorasLab> {
  final Set<int> _threeRows = {};
  final Set<int> _fourRows = {};
  int get _threeArea => _threeRows.length * 3;
  int get _fourArea => _fourRows.length * 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _moveRow(int side, int row) {
    setState(() {
      final rows = side == 3 ? _threeRows : _fourRows;
      if (!rows.add(row)) rows.remove(row);
    });
    widget.onResult(_threeArea + _fourArea == 25);
  }

  void _reset() {
    setState(() {
      _threeRows.clear();
      _fourRows.clear();
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
                  child: Text('3² + 4² → □', style: geometryHeading)),
              IconButton(
                  key: const ValueKey('pythagoras-reset'),
                  tooltip: 'Reset squares',
                  onPressed: _reset,
                  icon: const Icon(Icons.replay_rounded, color: geometryTeal)),
            ]),
            Semantics(
              label: 'Right triangle with legs 3 and 4. '
                  'Move the 9 and 16 unit squares onto the hypotenuse square.',
              child: SizedBox(
                key: const ValueKey('pythagoras-squares'),
                height: 278,
                child: CustomPaint(
                    painter: _PythagorasPainter(
                        threeRows: Set.of(_threeRows),
                        fourRows: Set.of(_fourRows))),
              ),
            ),
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _rows(3, _threeRows, geometryTeal)),
              const SizedBox(width: 10),
              Expanded(child: _rows(4, _fourRows, geometryCoral)),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: _threeArea + _fourArea == 25
                      ? const Color(0xFFDDEFE5)
                      : const Color(0xFFE8EDE6),
                  borderRadius: BorderRadius.circular(14)),
              child: Text(
                  '$_threeArea + $_fourArea = ${_threeArea + _fourArea}',
                  key: const ValueKey('pythagoras-count'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF193A35),
                      fontSize: 21,
                      fontWeight: FontWeight.w800)),
            ),
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              const GeometryHint(
                  key: ValueKey('pythagoras-hint'),
                  text: '3 □ → 5 × 5   ·   4 □ → 5 × 5'),
            ],
          ],
        ),
      );

  Widget _rows(int side, Set<int> moved, Color color) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$side × $side',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (var row = 0; row < side; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Semantics(
                label: 'Move row ${row + 1} of $side unit squares',
                selected: moved.contains(row),
                child: OutlinedButton(
                  key: ValueKey('pythagoras-row-$side-$row'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    backgroundColor: moved.contains(row)
                        ? color.withOpacity(.08)
                        : color.withOpacity(.18),
                    foregroundColor: color,
                    side: BorderSide(color: color.withOpacity(.45)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _moveRow(side, row),
                  child: Row(children: [
                    Expanded(
                        child: Text('$side □',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800))),
                    Icon(
                        moved.contains(row)
                            ? Icons.undo_rounded
                            : Icons.arrow_forward_rounded,
                        size: 20),
                  ]),
                ),
              ),
            ),
        ],
      );
}

class _PythagorasPainter extends CustomPainter {
  const _PythagorasPainter({required this.threeRows, required this.fourRows});
  final Set<int> threeRows;
  final Set<int> fourRows;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = math.min((size.width - 18) / 10, (size.height - 24) / 11);
    final origin =
        Offset((size.width - 10 * unit) / 2 + 3 * unit, 7 * unit + 12);
    Offset point(double x, double y) => origin + Offset(x * unit, y * unit);
    void square(List<Offset> points, Color fill, Color border) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = fill);
      canvas.drawPath(
          path,
          Paint()
            ..color = border
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
    }

    for (var row = 0; row < 3; row++) {
      for (var column = 0; column < 3; column++) {
        final x = column - 3.0;
        final y = row - 3.0;
        square(
            [
              point(x, y),
              point(x + 1, y),
              point(x + 1, y + 1),
              point(x, y + 1)
            ],
            threeRows.contains(row)
                ? Colors.white
                : geometryTeal.withOpacity(.74),
            geometryTeal.withOpacity(.55));
      }
    }
    for (var row = 0; row < 4; row++) {
      for (var column = 0; column < 4; column++) {
        final x = column.toDouble();
        final y = row.toDouble();
        square(
            [
              point(x, y),
              point(x + 1, y),
              point(x + 1, y + 1),
              point(x, y + 1)
            ],
            fourRows.contains(row)
                ? Colors.white
                : geometryCoral.withOpacity(.79),
            geometryCoral.withOpacity(.65));
      }
    }
    final movedColors = [
      for (final _ in threeRows) ...List.filled(3, geometryTeal),
      for (final _ in fourRows) ...List.filled(4, geometryCoral),
    ];
    Offset targetPoint(double column, double row) =>
        point(column * .8 + row * .6, -3 + column * .6 - row * .8);
    for (var row = 0; row < 5; row++) {
      for (var column = 0; column < 5; column++) {
        final index = row * 5 + column;
        final x = column.toDouble();
        final y = row.toDouble();
        square(
            [
              targetPoint(x, y),
              targetPoint(x + 1, y),
              targetPoint(x + 1, y + 1),
              targetPoint(x, y + 1)
            ],
            index < movedColors.length
                ? movedColors[index].withOpacity(.78)
                : const Color(0xFFFFF0CC),
            const Color(0xFFBFA45C));
      }
    }
    final triangle = Path()
      ..moveTo(point(0, 0).dx, point(0, 0).dy)
      ..lineTo(point(0, -3).dx, point(0, -3).dy)
      ..lineTo(point(4, 0).dx, point(4, 0).dy)
      ..close();
    canvas.drawPath(triangle, Paint()..color = const Color(0xFFF0F5E6));
    canvas.drawPath(
        triangle,
        Paint()
          ..color = const Color(0xFF284E43)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    final rightAngle = Path()
      ..moveTo(point(0, -.4).dx, point(0, -.4).dy)
      ..lineTo(point(.4, -.4).dx, point(.4, -.4).dy)
      ..lineTo(point(.4, 0).dx, point(.4, 0).dy);
    canvas.drawPath(
        rightAngle,
        Paint()
          ..color = geometryTeal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8);
    _label(canvas, '3', point(.5, -1.65));
    _label(canvas, '4', point(2, -.45));
    _label(canvas, movedColors.length == 25 ? '5' : '?', point(1.8, -1.8));
  }

  void _label(Canvas canvas, String value, Offset center) {
    final text = TextPainter(
        text: TextSpan(
            text: value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF284E43))),
        textDirection: TextDirection.ltr)
      ..layout();
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PythagorasPainter oldDelegate) =>
      !setEquals(oldDelegate.threeRows, threeRows) ||
      !setEquals(oldDelegate.fourRows, fourRows);
}
