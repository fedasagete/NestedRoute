import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class DataBoard extends StatefulWidget {
  const DataBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<DataBoard> createState() => _DataBoardState();
}

class _DataBoardState extends State<DataBoard> {
  late List<int> piles;
  int? selected;
  int get total => piles.fold(0, (sum, value) => sum + value);
  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    piles = ['a', 'b', 'c', 'd', 'e']
        .map((key) => widget.scenario.values[key]!)
        .toList();
    selected = null;
  }

  @override
  void didUpdateWidget(covariant DataBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) reset();
  }

  void tap(int index) {
    setState(() {
      if (selected == null) {
        if (piles[index] > 0) selected = index;
      } else if (selected == index) {
        selected = null;
      } else {
        piles[selected!]--;
        piles[index]++;
        selected = null;
      }
    });
    widget.onResult(piles.every((value) => value * 5 == total));
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const Icon(Icons.equalizer_rounded, size: 42, color: Color(0xff426876)),
        const SizedBox(height: 14),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$total ÷ 5 = ?',
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w900))),
        const SizedBox(height: 8),
        const Text('↗  1  ↘', style: TextStyle(fontSize: 25)),
        const SizedBox(height: 20),
        LayoutBuilder(
            builder: (context, constraints) => Wrap(
                    spacing: 5,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var i = 0; i < 5; i++)
                        InkWell(
                            key: ValueKey('data-pile-$i'),
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => tap(i),
                            child: AnimatedContainer(
                                duration:
                                    MediaQuery.of(context).disableAnimations
                                        ? Duration.zero
                                        : const Duration(milliseconds: 160),
                                width: (constraints.maxWidth - 20) / 5,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 2),
                                decoration: BoxDecoration(
                                    color: selected == i
                                        ? const Color(0xffffd576)
                                        : const Color(0xffe3edef),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: selected == i
                                            ? const Color(0xffb47718)
                                            : Colors.transparent,
                                        width: 2)),
                                child: Column(children: [
                                  Text('${i + 1}',
                                      style: const TextStyle(
                                          color: Color(0xff738b90))),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                      height: piles.reduce(
                                                  (a, b) => a > b ? a : b) *
                                              8.0 +
                                          8,
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                for (var j = 0;
                                                    j < piles[i];
                                                    j++)
                                                  Container(
                                                      key: ValueKey(
                                                          'data-unit-$i-$j'),
                                                      height: 5,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 3),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xff3d8994),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      3))),
                                              ]))),
                                  const SizedBox(height: 8),
                                  FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text('${piles[i]}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800))),
                                ]))),
                    ])),
        const SizedBox(height: 20),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(piles.map((value) => '$value').join(' + '),
                style: const TextStyle(fontSize: 20))),
        Text('= $total',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        if (widget.showHint)
          Padding(
              padding: const EdgeInsets.all(12),
              child: Text('$total ÷ 5 = ${total ~/ 5}',
                  style:
                      const TextStyle(fontSize: 23, color: Color(0xff347381)))),
      ]);
}
