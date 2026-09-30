import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class FractionTilesBoard extends StatefulWidget {
  const FractionTilesBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<FractionTilesBoard> createState() => _FractionTilesBoardState();
}

class _FractionTilesBoardState extends State<FractionTilesBoard> {
  static const _green = Color(0xFF247A67);
  late List<bool> _shaded;
  int get _parts => widget.scenario.values['parts']!;
  int get _wanted => widget.scenario.values['selected']!;
  int get _count => _shaded.where((selected) => selected).length;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() => _shaded = List.filled(_parts, false);

  @override
  void didUpdateWidget(covariant FractionTilesBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) _reset();
  }

  void _toggle(int index) {
    setState(() => _shaded[index] = !_shaded[index]);
    widget.onResult(_count == _wanted);
  }

  Widget _fraction(int numerator, {Color color = _green}) => SizedBox(
      width: 70,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$numerator',
                style: TextStyle(
                    color: color, fontSize: 32, fontWeight: FontWeight.w800))),
        Container(
            height: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: color),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$_parts',
                style: TextStyle(
                    color: color, fontSize: 32, fontWeight: FontWeight.w800))),
      ]));

  @override
  Widget build(BuildContext context) {
    final motion = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 160);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.flag_outlined, color: _green, size: 28),
        const SizedBox(width: 22),
        _fraction(_wanted),
      ]),
      const SizedBox(height: 22),
      LayoutBuilder(builder: (context, constraints) {
        var columns = 1;
        for (final candidate in [5, 4, 3, 2]) {
          if (_parts % candidate == 0) {
            columns = candidate;
            break;
          }
        }
        final tileWidth = (constraints.maxWidth - 16) / columns;
        final tileHeight = columns == 1 ? 52.0 : 90.0;
        return Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFFE6EEDD),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _green, width: 2)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Wrap(children: [
                  for (var i = 0; i < _parts; i++)
                    SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: Semantics(
                            label: '${i + 1} / $_parts',
                            button: true,
                            selected: _shaded[i],
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    key: ValueKey('fraction-tile-$i'),
                                    onTap: () => _toggle(i),
                                    child: AnimatedContainer(
                                      duration: motion,
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: _shaded[i]
                                              ? _green
                                              : const Color(0xFFFFF8E9),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: widget.showHint &&
                                                  i < _wanted &&
                                                  !_shaded[i]
                                              ? Border.all(
                                                  color:
                                                      const Color(0xFFE3AD45),
                                                  width: 3)
                                              : null),
                                      child: Icon(
                                          _shaded[i]
                                              ? Icons.check_rounded
                                              : Icons.add_rounded,
                                          size: 27,
                                          color: _shaded[i]
                                              ? Colors.white
                                              : const Color(0xFFC9D3BE)),
                                    ))))),
                ])));
      }),
      const SizedBox(height: 22),
      Center(
          child: Container(
              key: const ValueKey('fraction-current'),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                  color: _count == _wanted
                      ? const Color(0xFFE2F0E5)
                      : const Color(0xFFFFE8BC),
                  borderRadius: BorderRadius.circular(22)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _fraction(_count),
                const SizedBox(width: 16),
                Icon(
                    _count == _wanted
                        ? Icons.check_circle_rounded
                        : Icons.touch_app_outlined,
                    color: _green),
              ]))),
      if (widget.showHint) ...[
        const SizedBox(height: 16),
        Container(
            key: const ValueKey('fraction-hint'),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3D8),
                borderRadius: BorderRadius.circular(18)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.touch_app_outlined, color: Color(0xFF936222)),
              const SizedBox(width: 12),
              Flexible(
                  child: Text('$_wanted / $_parts',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700))),
            ])),
      ],
    ]);
  }
}
