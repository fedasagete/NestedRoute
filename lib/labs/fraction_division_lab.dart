import 'package:flutter/material.dart';

/// Discovery construction for Grade 8, printed page 35.
class FractionDivisionLab extends StatefulWidget {
  const FractionDivisionLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<FractionDivisionLab> createState() => _FractionDivisionLabState();
}

class _FractionDivisionLabState extends State<FractionDivisionLab> {
  static const _green = Color(0xFF247A67);
  bool _split = false;
  final _filled = List.filled(8, false);
  int get _count => _filled.where((value) => value).length;
  bool get _correct =>
      _split &&
      _filled.take(6).every((value) => value) &&
      !_filled[6] &&
      !_filled[7];

  void _subdivide() {
    setState(() => _split = true);
    widget.onResult(false);
  }

  void _fit(int index) {
    setState(() => _filled[index] = !_filled[index]);
    widget.onResult(_correct);
  }

  void _reset() {
    setState(() {
      _split = false;
      _filled.fillRange(0, 8, false);
    });
    widget.onResult(false);
  }

  @override
  Widget build(BuildContext context) {
    final motion = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 180);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('Hiruu',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: _green, fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('3/4 ÷ 1/8 = ?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800))),
      const SizedBox(height: 20),
      Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: const Color(0xFFE1EBDC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _green, width: 2)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _split ? 8 : 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _split ? 4 : 2, mainAxisExtent: 98),
                  itemBuilder: (context, index) {
                    final highlighted = index < (_split ? 6 : 3);
                    final placed = _split && _filled[index];
                    return Semantics(
                        label: '${index + 1} / ${_split ? 8 : 4}',
                        button: _split,
                        selected: placed,
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                key: ValueKey(_split
                                    ? 'fraction-division-slot-$index'
                                    : 'fraction-division-quarter-$index'),
                                onTap: _split ? () => _fit(index) : null,
                                child: AnimatedContainer(
                                  duration: motion,
                                  margin: const EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: placed
                                          ? (highlighted
                                              ? _green
                                              : const Color(0xFFB7654F))
                                          : highlighted
                                              ? const Color(0xFFFFE1A5)
                                              : const Color(0xFFF1F4EB),
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: highlighted
                                              ? const Color(0xFFE5AA43)
                                              : const Color(0xFFD5DED0),
                                          width: widget.showHint && highlighted
                                              ? 3
                                              : 1)),
                                  child: placed
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 28)
                                      : _split
                                          ? Icon(Icons.add_rounded,
                                              color: highlighted
                                                  ? const Color(0xFFA88038)
                                                  : const Color(0xFFC2CBBB))
                                          : FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text('1/4',
                                                  style: TextStyle(
                                                      color: highlighted
                                                          ? const Color(
                                                              0xFF7D612E)
                                                          : const Color(
                                                              0xFFB1BCAA),
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                ))));
                  }))),
      const SizedBox(height: 18),
      ElevatedButton.icon(
          key: const ValueKey('fraction-division-split'),
          onPressed: _split ? null : _subdivide,
          style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 58),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
          icon:
              Icon(_split ? Icons.check_rounded : Icons.vertical_split_rounded),
          label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('4 → 8',
                  style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
      if (_split) ...[
        const SizedBox(height: 18),
        Center(
            child: Container(
                key: const ValueKey('fraction-division-count'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF1D4),
                    borderRadius: BorderRadius.circular(18)),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('$_count × 1/8',
                        style: const TextStyle(
                            color: _green,
                            fontSize: 27,
                            fontWeight: FontWeight.w800))))),
      ],
      if (_correct) ...[
        const SizedBox(height: 16),
        Container(
            key: const ValueKey('fraction-division-formula'),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFE2F0E5),
                borderRadius: BorderRadius.circular(18)),
            child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('3/4 × 8/1 = 6',
                    style: TextStyle(
                        color: _green,
                        fontSize: 24,
                        fontWeight: FontWeight.w800)))),
      ],
      if (widget.showHint) ...[
        const SizedBox(height: 16),
        Container(
            key: const ValueKey('fraction-division-hint'),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3D8),
                borderRadius: BorderRadius.circular(18)),
            child: Column(children: [
              const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('1/4 = 2/8',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700))),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < 2; i++)
                  Container(
                      width: 42,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: _green, width: 2),
                          borderRadius: BorderRadius.circular(5))),
              ]),
            ])),
      ],
      const SizedBox(height: 12),
      Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              key: const ValueKey('fraction-division-reset'),
              tooltip: '↻',
              onPressed: _reset,
              icon: const Icon(Icons.replay_rounded, color: _green))),
    ]);
  }
}
