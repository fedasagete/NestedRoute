import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Original tile discovery adapted from Grade 8 chapter 2, pages 48–55.
/// Squares are introduced on pages 48–49; the principal root is on 54–55.
class SquareRootLab extends StatefulWidget {
  const SquareRootLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<SquareRootLab> createState() => _SquareRootLabState();
}

class _SquareRootLabState extends State<SquareRootLab> {
  static const _green = Color(0xFF247A67);
  static const _amber = Color(0xFFE3AD4B);
  static const _supply = 25;
  int _side = 1;
  bool _explored = false;
  bool get _correct => _explored && _side == 5;
  int get _capacity => _side * _side;
  int get _used => _side == 1 ? _supply : math.min(_capacity, _supply);
  int get _spare => _supply - _used;
  int get _missing => math.max(0, _capacity - _supply);

  void _changeSide(int amount) {
    final next = _side + amount;
    if (next < 1 || next > 7) return;
    setState(() {
      _side = next;
      _explored = true;
    });
    widget.onResult(_correct);
  }

  void _reset() {
    setState(() {
      _side = 1;
      _explored = false;
    });
    widget.onResult(false);
  }

  Widget _tile(int index, double size, {bool present = true}) => SizedBox(
      width: size,
      height: size,
      child: Container(
        key: ValueKey(
            present ? 'square-root-unit-$index' : 'square-root-empty-$index'),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: present ? _green : const Color(0xFFFFF8E8),
            border: Border.all(
                color: present ? const Color(0xFFD6E8D6) : _amber, width: 1),
            borderRadius: BorderRadius.circular(size < 20 ? 1 : 4)),
        child: !present
            ? Icon(Icons.add_rounded,
                size: size * 0.45, color: _amber.withOpacity(0.65))
            : null,
      ));

  Widget _strip() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('1',
              style: TextStyle(color: _green, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          for (var i = 0; i < _supply; i++) _tile(i, 10),
        ]),
        const SizedBox(width: 16),
        const Text('25',
            style: TextStyle(color: _green, fontWeight: FontWeight.w700)),
      ]);

  Widget _square() => LayoutBuilder(builder: (context, constraints) {
        final unitSize = math.min(32.0, (constraints.maxWidth - 24) / _side);
        return Center(
            child: SizedBox(
                width: unitSize * _side + 24,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    const SizedBox(width: 24, height: 24),
                    for (var column = 1; column <= _side; column++)
                      SizedBox(
                          width: unitSize,
                          height: 24,
                          child: Center(
                              child: Text('$column',
                                  key: ValueKey('square-root-edge-x-$column'),
                                  style: const TextStyle(
                                      color: _green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700)))),
                  ]),
                  for (var row = 0; row < _side; row++)
                    Row(children: [
                      SizedBox(
                          width: 24,
                          height: unitSize,
                          child: Center(
                              child: Text('${row + 1}',
                                  key:
                                      ValueKey('square-root-edge-y-${row + 1}'),
                                  style: const TextStyle(
                                      color: _green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700)))),
                      for (var column = 0; column < _side; column++)
                        _tile(row * _side + column, unitSize,
                            present: row * _side + column < _supply),
                    ]),
                ])));
      });

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Iskuweer-ruuttii',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _green, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.grid_on_rounded, color: _green, size: 30),
          SizedBox(width: 12),
          Flexible(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('25',
                      style: TextStyle(
                          fontSize: 34, fontWeight: FontWeight.w800)))),
          SizedBox(width: 16),
          Icon(Icons.arrow_forward_rounded, color: _green),
          SizedBox(width: 16),
          Icon(Icons.crop_square_rounded, color: _green, size: 36),
        ]),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              key: const ValueKey('square-root-decrease-side'),
              tooltip: '−1',
              onPressed: _side > 1 ? () => _changeSide(-1) : null,
              icon: const Icon(Icons.remove_rounded),
              color: _green),
          const SizedBox(width: 12),
          Container(
              key: const ValueKey('square-root-side'),
              width: 64,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFE1A5),
                  borderRadius: BorderRadius.circular(18)),
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('$_side',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800)))),
          const SizedBox(width: 12),
          Material(
              color: _side < 7 ? _green : const Color(0xFFCED9CC),
              borderRadius: BorderRadius.circular(16),
              child: IconButton(
                  key: const ValueKey('square-root-increase-side'),
                  tooltip: '+1',
                  onPressed: _side < 7 ? () => _changeSide(1) : null,
                  icon: const Icon(Icons.add_rounded),
                  color: Colors.white)),
        ]),
        const SizedBox(height: 18),
        Container(
            key: const ValueKey('square-root-arrangement'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: _correct
                    ? const Color(0xFFE1F0E2)
                    : const Color(0xFFF3F6EC),
                border: Border.all(
                    color: _correct ? _green : const Color(0xFFDEE6D5),
                    width: 2),
                borderRadius: BorderRadius.circular(24)),
            child: _side == 1 ? _strip() : _square()),
        const SizedBox(height: 14),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                _side == 1 ? '1 × 25 = 25' : '$_side × $_side = $_capacity',
                key: const ValueKey('square-root-dimensions'),
                style: const TextStyle(
                    color: _green, fontSize: 24, fontWeight: FontWeight.w800))),
        if (_spare > 0) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('square-root-spare'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D4),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.inventory_2_outlined,
                      color: Color(0xFF956B2E)),
                  const SizedBox(width: 10),
                  Text('$_spare',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 10),
                Wrap(alignment: WrapAlignment.center, children: [
                  for (var i = _used; i < _supply; i++) _tile(i, 32),
                ]),
              ])),
        ],
        if (_missing > 0) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('square-root-missing'),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D4),
                  borderRadius: BorderRadius.circular(18)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.crop_square_rounded, color: Color(0xFF956B2E)),
                const SizedBox(width: 12),
                Text('$_missing',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800)),
              ])),
        ],
        if (_correct) ...[
          const SizedBox(height: 18),
          Container(
              key: const ValueKey('square-root-definition'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE1F0E2),
                  borderRadius: BorderRadius.circular(20)),
              child: const Column(children: [
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('5 × 5 = 5² = 25',
                        style: TextStyle(
                            color: _green,
                            fontSize: 22,
                            fontWeight: FontWeight.w800))),
                SizedBox(height: 12),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('√25 = 5 ≥ 0',
                        style: TextStyle(
                            color: _green,
                            fontSize: 24,
                            fontWeight: FontWeight.w800))),
                SizedBox(height: 16),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('x² = 25 ⇒ x = ±5',
                        style: TextStyle(
                            color: Color(0xFF625A47),
                            fontSize: 20,
                            fontWeight: FontWeight.w700))),
              ])),
        ],
        if (widget.showHint) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('square-root-hint'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D8),
                  borderRadius: BorderRadius.circular(18)),
              child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('a × a = a²',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700)))),
        ],
        const SizedBox(height: 10),
        Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                key: const ValueKey('square-root-reset'),
                tooltip: '↻',
                onPressed: _reset,
                icon: const Icon(Icons.replay_rounded, color: _green))),
      ]);
}
