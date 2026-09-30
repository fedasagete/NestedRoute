import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class NumberLineBoard extends StatefulWidget {
  const NumberLineBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<NumberLineBoard> createState() => _NumberLineBoardState();
}

class _NumberLineBoardState extends State<NumberLineBoard> {
  static const _green = Color(0xFF247A67);
  late int _current;
  int get _start => widget.scenario.values['start']!;
  int get _delta => widget.scenario.values['delta']!;
  int get _target => _start + _delta;
  int get _min => math.min(_start, _target) - 2;
  int get _max => math.max(_start, _target) + 2;

  @override
  void initState() {
    super.initState();
    _current = _start;
  }

  @override
  void didUpdateWidget(covariant NumberLineBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) _current = _start;
  }

  void _move(int direction) {
    final next = _current + direction;
    if (next < _min || next > _max) return;
    setState(() => _current = next);
    widget.onResult(_current == _target);
  }

  @override
  Widget build(BuildContext context) {
    final correct = _current == _target;
    final motion = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 180);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(_delta > 0 ? 'Ida’uu' : 'Hir’isuu',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: _green, fontWeight: FontWeight.w700, fontSize: 18)),
      const SizedBox(height: 12),
      FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('$_start ${_delta > 0 ? '+' : '−'} ${_delta.abs()} = ?',
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w800))),
      const SizedBox(height: 24),
      Center(
          child: AnimatedContainer(
              key: const ValueKey('line-current'),
              duration: motion,
              width: 104,
              height: 104,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: correct ? _green : const Color(0xFFFFE1A5),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x15000000),
                        offset: Offset(0, 6),
                        blurRadius: 16)
                  ]),
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('$_current',
                      style: TextStyle(
                          fontSize: 42,
                          color:
                              correct ? Colors.white : const Color(0xFF423826),
                          fontWeight: FontWeight.w800))))),
      const SizedBox(height: 14),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
              color: const Color(0xFFF0F6EF),
              borderRadius: BorderRadius.circular(22)),
          child: LayoutBuilder(builder: (context, constraints) {
            final markerX =
                (_current - _min) / (_max - _min) * constraints.maxWidth;
            return SizedBox(
                height: 130,
                child: Stack(clipBehavior: Clip.none, children: [
                  Positioned.fill(
                      child: CustomPaint(
                          painter: _NumberTrack(
                              min: _min,
                              max: _max,
                              start: _start,
                              current: _current,
                              target: widget.showHint ? _target : null))),
                  AnimatedPositioned(
                      duration: motion,
                      curve: Curves.easeOut,
                      left: markerX - 18,
                      top: 22,
                      child: Semantics(
                          label: '$_current',
                          child: Container(
                              key: const ValueKey('line-marker'),
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                  color: _green, shape: BoxShape.circle),
                              child: const Icon(Icons.pets,
                                  color: Colors.white, size: 23)))),
                ]));
          })),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(
            child: OutlinedButton(
                key: const ValueKey('line-left'),
                onPressed: _current > _min ? () => _move(-1) : null,
                style: OutlinedButton.styleFrom(
                    foregroundColor: _green,
                    minimumSize: const Size(0, 64),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const FittedBox(
                    child: Row(children: [
                  Icon(Icons.arrow_back_rounded),
                  SizedBox(width: 10),
                  Text('−1', style: TextStyle(fontSize: 24))
                ])))),
        const SizedBox(width: 16),
        Expanded(
            child: ElevatedButton(
                key: const ValueKey('line-right'),
                onPressed: _current < _max ? () => _move(1) : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 64),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const FittedBox(
                    child: Row(children: [
                  Text('+1', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded)
                ])))),
      ]),
      if (widget.showHint) ...[
        const SizedBox(height: 18),
        Container(
            key: const ValueKey('line-hint'),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3D8),
                borderRadius: BorderRadius.circular(18)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(_delta > 0
                  ? Icons.arrow_forward_rounded
                  : Icons.arrow_back_rounded),
              const SizedBox(width: 12),
              Flexible(
                  child: Text('${_delta.abs()} × ${_delta > 0 ? '+1' : '−1'}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
            ])),
      ],
    ]);
  }
}

class _NumberTrack extends CustomPainter {
  _NumberTrack(
      {required this.min,
      required this.max,
      required this.start,
      required this.current,
      this.target});
  final int min, max, start, current;
  final int? target;

  @override
  void paint(Canvas canvas, Size size) {
    const y = 70.0;
    final paint = Paint()
      ..color = const Color(0xFFB8CDBD)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(0, y), Offset(size.width, y), paint);
    final step = size.width / (max - min);
    for (var n = min; n <= max; n++) {
      final x = (n - min) * step;
      canvas.drawLine(Offset(x, y - 5), Offset(x, y + 7), paint);
      if (max - min > 12 && n.isOdd && n != start && n != current) continue;
      final label = TextPainter(
          text: TextSpan(
              text: '$n',
              style: TextStyle(
                  fontSize: 13,
                  color: n == current
                      ? const Color(0xFF247A67)
                      : const Color(0xFF6C7C70),
                  fontWeight:
                      n == current ? FontWeight.w800 : FontWeight.w500)),
          textDirection: TextDirection.ltr)
        ..layout();
      label.paint(canvas, Offset(x - label.width / 2, y + 14));
    }
    canvas.drawCircle(Offset((start - min) * step, y), 5,
        Paint()..color = const Color(0xFFEAA94A));
    if (target != null) {
      canvas.drawCircle(
          Offset((target! - min) * step, y),
          11,
          Paint()
            ..color = const Color(0xFF247A67)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(_NumberTrack oldDelegate) =>
      min != oldDelegate.min ||
      max != oldDelegate.max ||
      start != oldDelegate.start ||
      current != oldDelegate.current ||
      target != oldDelegate.target;
}
