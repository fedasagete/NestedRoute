import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class EqualGroupsBoard extends StatefulWidget {
  const EqualGroupsBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<EqualGroupsBoard> createState() => _EqualGroupsBoardState();
}

class _EqualGroupsBoardState extends State<EqualGroupsBoard> {
  static const _green = Color(0xFF247A67);
  late List<int> _counts;
  int get _groups => widget.scenario.values['groups']!;
  int get _each => widget.scenario.values['each']!;
  int get _total => _counts.fold(0, (sum, value) => sum + value);

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() => _counts = List.filled(_groups, 0);

  @override
  void didUpdateWidget(covariant EqualGroupsBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) _reset();
  }

  void _change(int index, int amount) {
    final next = _counts[index] + amount;
    if (next < 0 || next > _each + 2) return;
    setState(() => _counts[index] = next);
    widget.onResult(_counts.every((count) => count == _each));
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Baay’isuu',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _green, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 12),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('$_groups × $_each = ?',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w800))),
          const SizedBox(height: 16),
          Center(
              child: Container(
                  key: const ValueKey('groups-total'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFE1A5),
                      borderRadius: BorderRadius.circular(18)),
                  child: Text('$_total',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800)))),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth < 270 ? 1 : 2;
            final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
            return Wrap(spacing: 12, runSpacing: 12, children: [
              for (var i = 0; i < _groups; i++)
                SizedBox(width: width, child: _basket(i)),
            ]);
          }),
          if (widget.showHint) ...[
            const SizedBox(height: 16),
            Container(
                key: const ValueKey('groups-hint'),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFF3D8),
                    borderRadius: BorderRadius.circular(18)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.shopping_basket_outlined, color: _green),
                  const SizedBox(width: 12),
                  Flexible(
                      child: Wrap(spacing: 4, runSpacing: 4, children: [
                    for (var i = 0; i < _each; i++) _seed(false),
                  ])),
                ])),
          ],
        ],
      );

  Widget _seed(bool filled) => Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
          color: filled ? const Color(0xFFE9AE4D) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: filled ? const Color(0xFFE9AE4D) : const Color(0xFFB2C9B8),
              width: 1.5)));

  Widget _basket(int index) {
    final count = _counts[index];
    final full = count == _each;
    final slots = widget.showHint && count < _each ? _each : count;
    return Container(
        key: ValueKey('group-basket-$index'),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: full ? const Color(0xFFE2F0E5) : const Color(0xFFFFF9EF),
            border: Border.all(
                color: full ? _green : const Color(0xFFEBDDCA), width: 1.5),
            borderRadius: BorderRadius.circular(22)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Icon(Icons.shopping_basket_outlined, color: _green, size: 28),
            Flexible(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('$count',
                        key: ValueKey('group-count-$index'),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800)))),
          ]),
          Container(
              height: 78,
              alignment: Alignment.center,
              child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 7,
                  children: [
                    for (var i = 0; i < slots; i++) _seed(i < count)
                  ])),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                key: ValueKey('group-remove-$index'),
                tooltip: '−1',
                onPressed: count > 0 ? () => _change(index, -1) : null,
                icon: const Icon(Icons.remove_rounded),
                color: _green),
            Material(
                color: _green,
                borderRadius: BorderRadius.circular(14),
                child: IconButton(
                    key: ValueKey('group-add-$index'),
                    tooltip: '+1',
                    onPressed:
                        count < _each + 2 ? () => _change(index, 1) : null,
                    icon: const Icon(Icons.add_rounded),
                    color: Colors.white)),
          ]),
        ]));
  }
}
