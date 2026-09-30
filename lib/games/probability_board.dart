import 'dart:math';
import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class ProbabilityBoard extends StatefulWidget {
  const ProbabilityBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<ProbabilityBoard> createState() => _ProbabilityBoardState();
}

class _ProbabilityBoardState extends State<ProbabilityBoard> {
  int chosenRed = 0, chosenTotal = 0, draws = 0, redDraws = 0;
  bool? lastRed;
  Random random = Random();
  int get red => widget.scenario.values['red']!;
  int get blue => widget.scenario.values['blue']!;
  @override
  void didUpdateWidget(covariant ProbabilityBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      chosenRed = 0;
      chosenTotal = 0;
      draws = 0;
      redDraws = 0;
      lastRed = null;
      random = Random();
    }
  }

  void result() => widget
      .onResult(draws > 0 && chosenRed == red && chosenTotal == red + blue);
  void draw() {
    setState(() {
      lastRed = random.nextInt(red + blue) < red;
      draws++;
      if (lastRed!) redDraws++;
    });
    result();
  }

  void change(bool numerator, int delta) {
    setState(() {
      if (numerator) {
        chosenRed = (chosenRed + delta).clamp(0, 25);
      } else {
        chosenTotal = (chosenTotal + delta).clamp(0, 25);
      }
    });
    result();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const Text('🔴 ?', style: TextStyle(fontSize: 34)),
        const SizedBox(height: 14),
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color(0xffe5eef0),
                borderRadius: BorderRadius.circular(25)),
            child: Wrap(
                spacing: 9,
                runSpacing: 9,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < red + blue; i++)
                    Icon(Icons.circle,
                        size: 24,
                        color: i < red
                            ? const Color(0xffe97661)
                            : const Color(0xff5886cf)),
                ])),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedSwitcher(
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              child: Icon(lastRed == null ? Icons.help_outline : Icons.circle,
                  key: ValueKey('$draws'),
                  size: 45,
                  color: lastRed == null
                      ? const Color(0xff789195)
                      : (lastRed!
                          ? const Color(0xffe97661)
                          : const Color(0xff5886cf)))),
          const SizedBox(width: 16),
          FilledButton.tonalIcon(
              key: const ValueKey('probability-draw'),
              onPressed: draw,
              icon: const Icon(Icons.shuffle_rounded),
              label: const Text('Yaali')),
        ]),
        const SizedBox(height: 8),
        Text('🔴 $redDraws / $draws', style: const TextStyle(fontSize: 17)),
        const Divider(height: 30),
        const Text('P(🔴)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        _counter(true, chosenRed),
        Container(width: 100, height: 3, color: const Color(0xff274d54)),
        _counter(false, chosenTotal),
        if (widget.showHint)
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('🔴 $red / ($red + $blue)',
                  style: const TextStyle(fontSize: 23))),
      ]);
  Widget _counter(bool numerator, int value) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
            key: ValueKey('probability-${numerator ? 'red' : 'total'}-minus'),
            tooltip: '−1',
            onPressed: value == 0 ? null : () => change(numerator, -1),
            icon: const Icon(Icons.remove_circle_outline)),
        SizedBox(
            width: 80,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w800))),
        IconButton(
            key: ValueKey('probability-${numerator ? 'red' : 'total'}-plus'),
            tooltip: '+1',
            onPressed: value >= 25 ? null : () => change(numerator, 1),
            icon: const Icon(Icons.add_circle_outline)),
      ]);
}
