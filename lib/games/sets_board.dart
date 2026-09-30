import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class SetsBoard extends StatefulWidget {
  const SetsBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<SetsBoard> createState() => _SetsBoardState();
}

class _SetsBoardState extends State<SetsBoard> {
  static const zones = ['aOnly', 'shared', 'bOnly'];
  late List<String> targets;
  late List<String?> placed;
  int? selected;
  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    targets = [
      for (final zone in zones)
        for (var i = 0; i < widget.scenario.values[zone]!; i++) zone
    ];
    placed = List<String?>.filled(targets.length, null);
    selected = null;
  }

  @override
  void didUpdateWidget(covariant SetsBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) reset();
  }

  void put(String zone) {
    if (selected == null) return;
    setState(() {
      placed[selected!] = zone;
      selected = null;
    });
    widget.onResult(
        List.generate(targets.length, (i) => placed[i] == targets[i])
            .every((v) => v));
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('A = ●     B = 🔵',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800))),
        const SizedBox(height: 18),
        Wrap(
            spacing: 9,
            runSpacing: 9,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < targets.length; i++)
                Semantics(
                    label:
                        '${targets[i] == 'bOnly' ? '★' : '●'} ${targets[i] == 'aOnly' ? '🟠' : '🔵'} ${i + 1}',
                    button: true,
                    selected: selected == i,
                    child: InkWell(
                        key: ValueKey('set-token-$i'),
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => setState(() => selected = i),
                        child: Container(
                            width: 54,
                            height: 60,
                            decoration: BoxDecoration(
                                color: selected == i
                                    ? const Color(0xffd0e9ed)
                                    : Colors.white,
                                border: Border.all(
                                    color: selected == i
                                        ? const Color(0xff397983)
                                        : const Color(0xffdbe5e6),
                                    width: 2),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      targets[i] == 'bOnly'
                                          ? Icons.star_rounded
                                          : Icons.circle,
                                      size: 28,
                                      color: targets[i] == 'aOnly'
                                          ? const Color(0xffe8a03d)
                                          : const Color(0xff4b83db)),
                                  Text(
                                      placed[i] == null
                                          ? '·'
                                          : (placed[i] == 'shared'
                                              ? 'A∩B'
                                              : (placed[i] == 'aOnly'
                                                  ? 'A'
                                                  : 'B')),
                                      style: const TextStyle(fontSize: 11)),
                                ])))),
            ]),
        const SizedBox(height: 22),
        SizedBox(
            height: 90,
            child: CustomPaint(
                painter: _VennPainter(),
                child: Row(children: [
                  for (final label in ['A', 'A∩B', 'B'])
                    Expanded(
                        child: Center(
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(label,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22))))),
                ]))),
        const SizedBox(height: 14),
        Row(children: [
          for (var i = 0; i < zones.length; i++)
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                        key: ValueKey('set-zone-${zones[i]}'),
                        onPressed:
                            selected == null ? null : () => put(zones[i]),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15)),
                        child: Column(children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(['A ∖ B', 'A ∩ B', 'B ∖ A'][i])),
                          Text('${placed.where((p) => p == zones[i]).length}')
                        ])))),
        ]),
        if (widget.showHint)
          const Padding(
              padding: EdgeInsets.all(15),
              child: Text('●🟠 → A     ●🔵 → A∩B     ★🔵 → B',
                  style: TextStyle(fontSize: 16))),
      ]);
}

class _VennPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width * .48;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * .4, size.height / 2),
            width: width,
            height: size.height * .9),
        Paint()..color = const Color(0x66efb247));
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * .6, size.height / 2),
            width: width,
            height: size.height * .9),
        Paint()..color = const Color(0x665889d9));
  }

  @override
  bool shouldRepaint(covariant _VennPainter oldDelegate) => false;
}
