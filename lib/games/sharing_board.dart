import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class SharingBoard extends StatefulWidget {
  const SharingBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<SharingBoard> createState() => _SharingBoardState();
}

class _SharingBoardState extends State<SharingBoard> {
  static const _green = Color(0xFF247A67);
  late List<int> _shares;
  int get _total => widget.scenario.values['total']!;
  int get _people => widget.scenario.values['people']!;
  int get _each => _total ~/ _people;
  int get _remaining => _total - _shares.fold(0, (sum, count) => sum + count);

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() => _shares = List.filled(_people, 0);

  @override
  void didUpdateWidget(covariant SharingBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) _reset();
  }

  void _move(int index, int amount) {
    if (amount > 0 && _remaining == 0 || amount < 0 && _shares[index] == 0) {
      return;
    }
    setState(() => _shares[index] += amount);
    widget
        .onResult(_remaining == 0 && _shares.every((count) => count == _each));
  }

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Hiruu',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _green, fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 12),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$_total ÷ $_people = ?',
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w800))),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: const Color(0xFFFFE8BC),
                borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 30, color: Color(0xFF936222)),
                const SizedBox(width: 14),
                SizedBox(
                    key: const ValueKey('sharing-supply-count'),
                    child: Text('$_remaining',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w800))),
              ]),
              if (_remaining > 0) ...[
                const SizedBox(height: 10),
                Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (var i = 0;
                          i < (_remaining > 20 ? 20 : _remaining);
                          i++)
                        _token(),
                      if (_remaining > 20)
                        Text('+${_remaining - 20}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                    ]),
              ],
            ])),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Icon(Icons.arrow_downward_rounded, color: _green)),
        LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth < 270 ? 1 : 2;
          final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
          return Wrap(spacing: 12, runSpacing: 12, children: [
            for (var i = 0; i < _people; i++)
              SizedBox(width: width, child: _person(i)),
          ]);
        }),
        if (widget.showHint) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('sharing-hint'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF0F6EF),
                  borderRadius: BorderRadius.circular(18)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.person_outline_rounded, color: _green),
                const SizedBox(width: 12),
                Flexible(
                    child: Text('$_each',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800))),
                const SizedBox(width: 12),
                Flexible(
                    child: Wrap(spacing: 4, runSpacing: 4, children: [
                  for (var i = 0; i < _each; i++) _token(outline: true),
                ])),
              ])),
        ],
      ]);

  Widget _token({bool outline = false}) => Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
          color: outline ? Colors.transparent : const Color(0xFFE9AE4D),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFFCEA563), width: 1.5)));

  Widget _person(int index) {
    final count = _shares[index];
    final fair = count == _each;
    final visible = count > 12 ? 12 : count;
    final slots = widget.showHint && visible < _each ? _each : visible;
    return Container(
        key: ValueKey('sharing-person-$index'),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: fair ? const Color(0xFFE2F0E5) : const Color(0xFFFFF9EF),
            border: Border.all(
                color: fair ? _green : const Color(0xFFEBDDCA), width: 1.5),
            borderRadius: BorderRadius.circular(22)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: const Color(0xFFDCEBDC),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.person_outline_rounded, color: _green)),
            Flexible(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('$count',
                        key: ValueKey('sharing-count-$index'),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800)))),
          ]),
          Container(
              height: 88,
              alignment: Alignment.center,
              child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 7,
                  children: [
                    for (var i = 0; i < slots; i++)
                      _token(outline: i >= visible),
                    if (count > 12)
                      Text('+${count - 12}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                  ])),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                key: ValueKey('sharing-remove-$index'),
                tooltip: '−1',
                onPressed: count > 0 ? () => _move(index, -1) : null,
                icon: const Icon(Icons.remove_rounded),
                color: _green),
            Material(
                color: _remaining > 0 ? _green : const Color(0xFFC7D3C8),
                borderRadius: BorderRadius.circular(14),
                child: IconButton(
                    key: ValueKey('sharing-add-$index'),
                    tooltip: '+1',
                    onPressed: _remaining > 0 ? () => _move(index, 1) : null,
                    icon: const Icon(Icons.add_rounded),
                    color: Colors.white)),
          ]),
        ]));
  }
}
