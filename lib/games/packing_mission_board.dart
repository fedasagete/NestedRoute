import 'dart:async';

import 'package:flutter/material.dart';

import '../learning/scenarios.dart';
import 'mission_art.dart';

class PackingMissionBoard extends StatefulWidget {
  const PackingMissionBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false,
      this.english = false,
      this.onHelpUsed,
      this.onAction,
      this.demonstrateOnStart = false});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;
  final bool english;
  final VoidCallback? onHelpUsed;
  final VoidCallback? onAction;
  final bool demonstrateOnStart;
  @override
  State<PackingMissionBoard> createState() => _PackingMissionBoardState();
}

class _PackingMissionBoardState extends State<PackingMissionBoard> {
  static const _ink = Color(0xff263c35);
  static const _teal = Color(0xff247a67);
  late List<List<int>> _baskets;
  int? _selected;
  Timer? _timer;
  Timer? _restoreTimer;
  bool _demoing = false;
  bool _preparing = false;
  List<List<int>>? _savedBaskets;
  int? _savedSelection;
  int _demoCursor = 0;
  final _firstReceiverKey = GlobalKey();
  int _entryGeneration = 0;

  int get _groups => widget.scenario.values['groups']!;
  int get _each => widget.scenario.values['each']!;
  int get _supplySize => _groups * _each;
  int get _demoLimit => _supplySize < 5 ? _supplySize : 5;
  bool get _locked => _demoing || _preparing;
  int get _total => _baskets.fold(0, (sum, basket) => sum + basket.length);
  bool get _correct => _baskets.every((basket) => basket.length == _each);
  List<int> get _loose {
    final packed = _baskets.expand((basket) => basket).toSet();
    return [
      for (var id = 0; id < _supplySize; id++)
        if (!packed.contains(id)) id
    ];
  }

  @override
  void initState() {
    super.initState();
    _empty();
    _reportReset();
    _scheduleFirstExample();
  }

  void _empty() {
    _baskets = List.generate(_groups, (_) => <int>[]);
    _selected = null;
  }

  void _reportReset() {
    final id = widget.scenario.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.scenario.id == id) widget.onResult(false);
    });
  }

  void _scheduleFirstExample() {
    final generation = ++_entryGeneration;
    if (!widget.demonstrateOnStart) return;
    final id = widget.scenario.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          generation != _entryGeneration ||
          widget.scenario.id != id) return;
      _prepareExample(auto: true);
    });
  }

  Future<void> _prepareExample({bool auto = false}) async {
    if (!mounted || _locked || (auto && !widget.demonstrateOnStart)) return;
    final generation = ++_entryGeneration;
    final id = widget.scenario.id;
    bool current() =>
        mounted && generation == _entryGeneration && widget.scenario.id == id;
    setState(() => _preparing = true);
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 200);
    for (final policy in [
      ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      ScrollPositionAlignmentPolicy.keepVisibleAtStart
    ]) {
      final receiver = _firstReceiverKey.currentContext;
      if (receiver == null) {
        if (current()) setState(() => _preparing = false);
        return;
      }
      await Scrollable.ensureVisible(receiver,
          alignmentPolicy: policy, duration: duration);
      if (!current()) return;
    }
    setState(() => _preparing = false);
    _demo();
  }

  @override
  void didUpdateWidget(covariant PackingMissionBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      _cancelDemo();
      _empty();
      _reportReset();
      _scheduleFirstExample();
    }
  }

  void _cancelDemo() {
    _timer?.cancel();
    _restoreTimer?.cancel();
    _timer = null;
    _restoreTimer = null;
    _demoing = false;
    _preparing = false;
    _savedBaskets = null;
    _savedSelection = null;
  }

  @override
  void dispose() {
    _entryGeneration++;
    _cancelDemo();
    super.dispose();
  }

  void _place(int basket, [int? fruit]) {
    if (_locked) return;
    final loose = _loose;
    final chosen = fruit ?? _selected ?? (loose.isEmpty ? null : loose.first);
    if (chosen == null || !loose.contains(chosen)) return;
    setState(() {
      _baskets[basket].add(chosen);
      _selected = null;
    });
    widget.onAction?.call();
    widget.onResult(_correct);
  }

  void _remove(int basket, [int? fruit]) {
    if (_locked || _baskets[basket].isEmpty) return;
    final chosen = fruit ?? _baskets[basket].last;
    if (!_baskets[basket].contains(chosen)) return;
    setState(() => _baskets[basket].remove(chosen));
    widget.onAction?.call();
    widget.onResult(_correct);
  }

  void _reset() {
    if (_locked) return;
    setState(_empty);
    widget.onResult(false);
  }

  void _selectFruit(int id) {
    if (_locked || !_loose.contains(id)) return;
    setState(() => _selected = id);
  }

  void _demo() {
    if (_demoing) return;
    widget.onHelpUsed?.call();
    _savedBaskets = _baskets.map((basket) => List<int>.of(basket)).toList();
    _savedSelection = _selected;
    setState(() {
      _empty();
      _demoing = true;
      _demoCursor = 0;
      if (MediaQuery.of(context).disableAnimations) {
        for (var fruit = 0; fruit < _demoLimit; fruit++) {
          _baskets[fruit ~/ _each].add(fruit);
        }
        _demoCursor = _demoLimit;
      }
    });
    widget.onResult(false);
    if (_demoCursor < _demoLimit) {
      _timer =
          Timer.periodic(const Duration(milliseconds: 250), (_) => _demoStep());
    }
    _restoreTimer = Timer(const Duration(milliseconds: 1500), _restoreDemo);
  }

  void _demoStep() {
    if (!mounted || !_demoing) return;
    setState(() {
      _baskets[_demoCursor ~/ _each].add(_demoCursor);
      _demoCursor++;
    });
    if (_demoCursor == _demoLimit) _timer?.cancel();
  }

  void _restoreDemo() {
    if (!mounted || !_demoing) return;
    setState(() {
      _baskets = _savedBaskets!;
      _selected = _savedSelection;
      _cancelDemo();
    });
    widget.onResult(_correct);
  }

  Widget _number(String key, int value) => Text('$value',
      key: ValueKey(key),
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: _ink));

  Widget _looseFruit(int id) => LongPressDraggable<int>(
        data: id,
        delay: const Duration(milliseconds: 250),
        maxSimultaneousDrags: _locked ? 0 : 1,
        feedback: const Material(
            color: Colors.transparent, child: BananaToken(size: 48)),
        childWhenDragging: const SizedBox(
            width: 48,
            height: 48,
            child: Center(child: BananaToken(ghost: true))),
        child: Semantics(
          label: widget.english ? 'Select banana' : 'Muuzii filadhu',
          selected: _selected == id,
          child: InkWell(
            key: ValueKey('packing-loose-$id'),
            borderRadius: BorderRadius.circular(12),
            onTap: _locked ? null : () => _selectFruit(id),
            child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: _selected == id ? const Color(0xffffe5a1) : null,
                    borderRadius: BorderRadius.circular(12),
                    border: _selected == id
                        ? Border.all(color: _teal, width: 2)
                        : null),
                child: const Center(child: BananaToken())),
          ),
        ),
      );

  Widget _basket(int index) => DragTarget<int>(
        key: ValueKey('group-basket-$index'),
        onWillAccept: (fruit) =>
            !_locked && fruit != null && _loose.contains(fruit),
        onAccept: (fruit) => _place(index, fruit),
        builder: (context, candidates, rejected) => InkWell(
          key: ValueKey('packing-basket-tap-$index'),
          borderRadius: BorderRadius.circular(22),
          onTap: _locked || _selected == null ? null : () => _place(index),
          child: MissionBasket(
            key: index == 0 ? _firstReceiverKey : null,
            complete: _baskets[index].length == _each,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    const Icon(Icons.shopping_basket_outlined,
                        color: _teal, size: 28),
                    const SizedBox(width: 8),
                    Text('${index + 1}',
                        style: const TextStyle(color: _ink, fontSize: 18)),
                    const Spacer(),
                    _number('group-count-$index', _baskets[index].length),
                  ]),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color:
                            candidates.isEmpty ? null : const Color(0xffffe5a1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final fruit in _baskets[index])
                            Semantics(
                                label: widget.english
                                    ? 'Return banana'
                                    : 'Muuzii deebisi',
                                child: InkWell(
                                    key:
                                        ValueKey('packing-fruit-$index-$fruit'),
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: _locked
                                        ? null
                                        : () => _remove(index, fruit),
                                    child: const SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Center(child: BananaToken())))),
                          for (var slot = _baskets[index].length;
                              slot < _each;
                              slot++)
                            Semantics(
                                label: widget.english
                                    ? 'Put banana here'
                                    : 'Muuzii as kaa’i',
                                child: InkWell(
                                    key: ValueKey('packing-slot-$index-$slot'),
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: _locked || _loose.isEmpty
                                        ? null
                                        : () => _place(index),
                                    child: const SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Center(
                                            child: BananaToken(ghost: true))))),
                        ]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            key: ValueKey('group-remove-$index'),
                            tooltip: widget.english
                                ? 'Return one banana'
                                : 'Muuzii tokko deebisi',
                            constraints: const BoxConstraints(
                                minWidth: 48, minHeight: 48),
                            onPressed: _locked || _baskets[index].isEmpty
                                ? null
                                : () => _remove(index),
                            icon: const Icon(Icons.remove_rounded),
                            color: _teal),
                        IconButton(
                            key: ValueKey('group-add-$index'),
                            tooltip: widget.english
                                ? 'Add one banana'
                                : 'Muuzii tokko ida’i',
                            constraints: const BoxConstraints(
                                minWidth: 48, minHeight: 48),
                            onPressed: _locked || _loose.isEmpty
                                ? null
                                : () => _place(index),
                            icon: const Icon(Icons.add_rounded),
                            color: _teal),
                      ]),
                ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            MissionPerson(happy: _correct && !_demoing),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
                    widget.english
                        ? '$_groups baskets. $_each bananas in each.'
                        : 'Garee $_groups; muuzii $_each garee hunda keessatti.',
                    key: const ValueKey('packing-goal'),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _ink))),
          ]),
          const SizedBox(height: 12),
          Text(
              widget.english
                  ? 'Tap a banana then a basket, or hold and drag.'
                  : 'Muuzii tuqii garee keessa kaa’i.',
              style: const TextStyle(color: _ink, fontSize: 15)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
                child: OutlinedButton.icon(
                    key: const ValueKey('packing-demo'),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(48, 48)),
                    onPressed: _locked ? null : () => _prepareExample(),
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    label: Text(widget.english ? 'Example' : 'Fakkeenya'))),
            const SizedBox(width: 8),
            IconButton(
                key: const ValueKey('packing-reset'),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                tooltip: widget.english ? 'Start again' : 'Jalqabatti deebi’i',
                onPressed: _locked ? null : _reset,
                icon: const Icon(Icons.replay_rounded),
                color: _teal),
          ]),
          const SizedBox(height: 12),
          Container(
            key: const ValueKey('packing-supply'),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xfff2f6ee),
                borderRadius: BorderRadius.circular(18)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const BananaToken(size: 24, ghost: true),
                const SizedBox(width: 8),
                _number('packing-supply-count', _loose.length),
              ]),
              const SizedBox(height: 4),
              Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var fruit = 0; fruit < _supplySize; fruit++)
                      if (_loose.contains(fruit))
                        _looseFruit(fruit)
                      else
                        SizedBox(
                            key: ValueKey('packing-vacancy-$fruit'),
                            width: 48,
                            height: 48),
                  ]),
            ]),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < _groups; index++) ...[
            _basket(index),
            const SizedBox(height: 12),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.shopping_basket_outlined, color: _teal),
            const SizedBox(width: 8),
            _number('groups-total', _total),
          ]),
          if (_demoing)
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                    widget.english
                        ? 'Example — your baskets will return.'
                        : 'Fakkeenya; gareewwan kee ni deebi’u.',
                    key: const ValueKey('packing-demo-status'),
                    style: const TextStyle(fontSize: 14, color: _teal))),
          if (_correct && !_demoing)
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text('$_groups × $_each = $_total',
                    key: const ValueKey('packing-equation'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _teal))),
          if (widget.showHint)
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: _teal),
                  const SizedBox(width: 8),
                  Flexible(
                      child: Wrap(spacing: 4, runSpacing: 4, children: [
                    for (var i = 0; i < _each; i++)
                      const BananaToken(size: 28, ghost: true)
                  ])),
                ])),
        ],
      );
}
