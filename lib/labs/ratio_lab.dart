import 'package:flutter/material.dart';

/// Ratio grouping and scaling for Grade 7, printed pages 54–55.
class RatioLab extends StatefulWidget {
  const RatioLab({super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<RatioLab> createState() => _RatioLabState();
}

class _RatioLabState extends State<RatioLab> {
  static const _green = Color(0xFF247A67);
  static const _amberColor = Color(0xFFE2A33C);
  static const _blueColor = Color(0xFF579AB3);
  int _amber = 0;
  int _blue = 0;
  int get _total => _amber + _blue;
  bool get _correct => _amber == 4 && _blue == 6;

  void _change(bool amber, int amount) {
    if (amount > 0 && _total == 10 ||
        amount < 0 && (amber ? _amber : _blue) == 0) return;
    setState(() {
      if (amber) {
        _amber += amount;
      } else {
        _blue += amount;
      }
    });
    widget.onResult(_correct);
  }

  void _reset() {
    setState(() {
      _amber = 0;
      _blue = 0;
    });
    widget.onResult(false);
  }

  Widget _dot(bool amber, {bool filled = true, double size = 22}) {
    final color = amber ? _amberColor : _blueColor;
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
                color: color.withOpacity(filled ? 1 : 0.36), width: 2)));
  }

  Widget _counter(bool amber) {
    final count = amber ? _amber : _blue;
    final color = amber ? _amberColor : _blueColor;
    final name = amber ? 'amber' : 'blue';
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _dot(amber),
                const SizedBox(width: 10),
                Flexible(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('$count',
                            key: ValueKey('ratio-count-$name'),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800)))),
              ]),
              const SizedBox(height: 10),
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    IconButton(
                        key: ValueKey('ratio-remove-$name'),
                        tooltip: '−1',
                        onPressed: count > 0 ? () => _change(amber, -1) : null,
                        color: color,
                        icon: const Icon(Icons.remove_rounded)),
                    Material(
                        color: _total < 10 ? color : const Color(0xFFCCD5CB),
                        borderRadius: BorderRadius.circular(14),
                        child: IconButton(
                            key: ValueKey('ratio-add-$name'),
                            tooltip: '+1',
                            onPressed:
                                _total < 10 ? () => _change(amber, 1) : null,
                            color: Colors.white,
                            icon: const Icon(Icons.add_rounded))),
                  ]),
            ])));
  }

  Widget _group(int index) {
    final amberHere = (_amber - index * 2).clamp(0, 2);
    final blueHere = (_blue - index * 3).clamp(0, 3);
    final full = amberHere == 2 && blueHere == 3;
    return Expanded(
        child: Container(
            key: ValueKey(
                full ? 'ratio-full-group-$index' : 'ratio-group-$index'),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            decoration: BoxDecoration(
                color: full ? const Color(0xFFE2F0E5) : const Color(0xFFF3F6EE),
                border: Border.all(
                    color: full ? _green : const Color(0xFFD8E2D4), width: 2),
                borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < 2; i++)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: _dot(true, filled: i < amberHere)),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: _dot(false, filled: i < blueHere)),
              ]),
              const SizedBox(height: 12),
              const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('2 : 3',
                      style: TextStyle(
                          color: _green,
                          fontSize: 18,
                          fontWeight: FontWeight.w700))),
            ])));
  }

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('2 : 3',
                style: TextStyle(
                    color: _green, fontSize: 34, fontWeight: FontWeight.w800))),
        const SizedBox(height: 14),
        Center(
            child: Container(
                key: const ValueKey('ratio-total'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFE8BC),
                    borderRadius: BorderRadius.circular(18)),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('$_total / 10',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w800))))),
        const SizedBox(height: 20),
        Row(children: [
          _counter(true),
          const SizedBox(width: 12),
          _counter(false)
        ]),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Icon(Icons.arrow_downward_rounded, color: _green)),
        Row(children: [_group(0), const SizedBox(width: 12), _group(1)]),
        if (_amber > 4 || _blue > 6) ...[
          const SizedBox(height: 12),
          Container(
              key: const ValueKey('ratio-extras'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF1DE),
                  borderRadius: BorderRadius.circular(16)),
              child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (var i = 4; i < _amber; i++) _dot(true),
                    for (var i = 6; i < _blue; i++) _dot(false),
                  ])),
        ],
        if (_correct) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('ratio-formula'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE2F0E5),
                  borderRadius: BorderRadius.circular(18)),
              child: const Column(children: [
                Text('×2',
                    style: TextStyle(
                        color: _green,
                        fontSize: 19,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('2 : 3 = 4 : 6',
                        style: TextStyle(
                            color: _green,
                            fontSize: 24,
                            fontWeight: FontWeight.w800))),
              ])),
        ],
        if (widget.showHint) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('ratio-hint'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D8),
                  borderRadius: BorderRadius.circular(18)),
              child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('2 × (2 + 3) = 10',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700)))),
        ],
        const SizedBox(height: 10),
        Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                key: const ValueKey('ratio-reset'),
                tooltip: '↻',
                onPressed: _reset,
                icon: const Icon(Icons.replay_rounded, color: _green))),
      ]);
}
