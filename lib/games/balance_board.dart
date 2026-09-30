import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class BalanceBoard extends StatefulWidget {
  const BalanceBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<BalanceBoard> createState() => _BalanceBoardState();
}

class _BalanceBoardState extends State<BalanceBoard> {
  int chosen = 0;
  int get factor => widget.scenario.values['factor']!;
  int get offset => widget.scenario.values['offset']!;
  int get target => factor * widget.scenario.values['solution']! + offset;
  int get current => factor * chosen + offset;
  @override
  void didUpdateWidget(covariant BalanceBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) chosen = 0;
  }

  void change(int amount) {
    setState(() => chosen = (chosen + amount).clamp(0, 30));
    widget.onResult(current == target);
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const Text('⚖', style: TextStyle(fontSize: 44)),
        const SizedBox(height: 12),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                '$factor × ? ${offset < 0 ? '− ${offset.abs()}' : '+ $offset'} = $target',
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w800))),
        const SizedBox(height: 28),
        AnimatedRotation(
            turns: current == target ? 0 : (current < target ? -.018 : .018),
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 280),
            child: Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color(0xff193e43),
                    borderRadius: BorderRadius.circular(10)))),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _pan(current, const Color(0xffd9eff3), true)),
          const Padding(
              padding: EdgeInsets.only(top: 36),
              child: Text('↔', style: TextStyle(fontSize: 26))),
          Expanded(child: _pan(target, const Color(0xffffe9b7), false)),
        ]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              key: const ValueKey('balance-minus'),
              tooltip: '−1',
              onPressed: chosen > 0 ? () => change(-1) : null,
              icon: const Icon(Icons.remove_circle_outline, size: 38)),
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('x = $chosen',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900))))),
          IconButton(
              key: const ValueKey('balance-plus'),
              tooltip: '+1',
              onPressed: chosen < 30 ? () => change(1) : null,
              icon: const Icon(Icons.add_circle_outline, size: 38)),
        ]),
        if (widget.showHint)
          Padding(
              padding: const EdgeInsets.all(12),
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      '($target ${offset < 0 ? '+ ${offset.abs()}' : '− $offset'}) ÷ $factor = ?',
                      style: const TextStyle(
                          fontSize: 21, color: Color(0xff326d75))))),
        const SizedBox(height: 12),
      ]);
  Widget _pan(int number, Color color, bool bags) => Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(22)),
      child: Column(children: [
        if (bags)
          Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < factor; i++)
                  Container(
                      width: 40,
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('$chosen',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)))),
              ])
        else
          Wrap(
              alignment: WrapAlignment.center,
              spacing: 3,
              runSpacing: 3,
              children: [
                for (var i = 0; i < number; i++)
                  const Icon(Icons.circle, size: 13, color: Color(0xffb97426)),
              ]),
        if (bags)
          Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                  '× $factor   ${offset < 0 ? '− ${offset.abs()}' : '+ $offset'}')),
        const SizedBox(height: 10),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$number',
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w900))),
      ]));
}
