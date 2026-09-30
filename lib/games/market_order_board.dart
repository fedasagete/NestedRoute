import 'dart:async';

import 'package:flutter/material.dart';

import '../learning/scenarios.dart';
import 'mission_art.dart';

/// A small order is constructed from a conserved supply of real fruit.
class MarketOrderBoard extends StatefulWidget {
  const MarketOrderBoard({
    super.key,
    required this.scenario,
    required this.onResult,
    this.showHint = false,
    this.english = false,
    this.onHelpUsed,
    this.onAction,
    this.demonstrateOnStart = false,
  });

  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;
  final bool english;
  final VoidCallback? onHelpUsed;
  final VoidCallback? onAction;
  final bool demonstrateOnStart;

  @override
  State<MarketOrderBoard> createState() => _MarketOrderBoardState();
}

class _MarketOrderBoardState extends State<MarketOrderBoard> {
  final List<int> _moved = [];
  final GlobalKey _receivingBasket = GlobalKey();
  List<int>? _beforeDemo;
  Timer? _demoTimer;
  bool _demonstrating = false;
  bool _preparingDemo = false;
  int _introGeneration = 0;

  int get _start => widget.scenario.values['start']!;
  int get _supply => widget.scenario.values['delta']!;
  int get _target => _start + _supply;
  int get _count => _start + _moved.length;
  bool get _helpBusy => _preparingDemo || _demonstrating;
  bool get _correct => _count == _target && !_helpBusy;
  List<int> get _available => [
        for (var index = 0; index < _supply; index++)
          if (!_moved.contains(index)) index,
      ];

  String _copy(String oromo, String english) =>
      widget.english ? english : oromo;

  @override
  void initState() {
    super.initState();
    _scheduleIntro();
  }

  void _scheduleIntro() {
    if (!widget.demonstrateOnStart) return;
    final generation = _introGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          generation != _introGeneration ||
          !widget.demonstrateOnStart) return;
      _prepareDemo(automatic: true);
    });
  }

  Future<void> _prepareDemo({bool automatic = false}) async {
    final generation = _introGeneration;
    if (!mounted ||
        generation != _introGeneration ||
        _helpBusy ||
        _available.isEmpty) return;
    final receiver = _receivingBasket.currentContext;
    if (receiver == null) return;
    setState(() => _preparingDemo = true);
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 200);
    await Scrollable.ensureVisible(
      receiver,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      duration: duration,
    );
    if (!mounted || generation != _introGeneration) return;
    // End alignment only reveals a receiver below the viewport. Watch may be
    // reached after scrolling past it, so also reveal a clipped upper edge.
    await Scrollable.ensureVisible(
      receiver,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      duration: duration,
    );
    if (!mounted || generation != _introGeneration) return;
    setState(() => _preparingDemo = false);
    if (automatic && !widget.demonstrateOnStart) return;
    _demonstrate();
  }

  void _scheduleResetResult() {
    final generation = _introGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _introGeneration) return;
      widget.onResult(false);
    });
  }

  @override
  void didUpdateWidget(covariant MarketOrderBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      _introGeneration++;
      _demoTimer?.cancel();
      _demoTimer = null;
      _beforeDemo = null;
      _demonstrating = false;
      _preparingDemo = false;
      _moved.clear();
      _scheduleResetResult();
      _scheduleIntro();
    }
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    super.dispose();
  }

  void _add(int index) {
    if (_helpBusy || !_available.contains(index)) return;
    setState(() => _moved.add(index));
    widget.onAction?.call();
    widget.onResult(_correct);
  }

  void _addNext() {
    final available = _available;
    if (_helpBusy || available.isEmpty) return;
    _add(available.first);
  }

  void _undo() {
    if (_helpBusy || _moved.isEmpty) return;
    setState(() => _moved.removeLast());
    widget.onAction?.call();
    widget.onResult(_correct);
  }

  void _demonstrate() {
    if (_helpBusy || _available.isEmpty) return;
    final index = _available.first;
    final sourceId = widget.scenario.id;
    widget.onHelpUsed?.call();
    if (!mounted) return;
    setState(() {
      _beforeDemo = List<int>.of(_moved);
      _demonstrating = true;
      _moved.add(index);
    });
    widget.onResult(false);
    // Reduced motion still leaves time to inspect the demonstrated move.
    _demoTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted || widget.scenario.id != sourceId) return;
      setState(() {
        _moved
          ..clear()
          ..addAll(_beforeDemo!);
        _beforeDemo = null;
        _demonstrating = false;
        _demoTimer = null;
      });
      widget.onResult(_correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final available = _available;
    const ink = Color(0xff513c2c);
    const green = Color(0xff477e65);
    final text = Theme.of(context).textTheme;
    final countStyle = DefaultTextStyle.of(context)
        .style
        .merge(text.headlineSmall)
        .copyWith(color: ink, fontWeight: FontWeight.w800);
    final countMeasure = TextPainter(
      text: TextSpan(text: '$_target', style: countStyle),
      textDirection: Directionality.of(context),
      textScaleFactor: MediaQuery.textScaleFactorOf(context),
    )..layout();
    return Container(
      key: const ValueKey('market-order-board'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfffff8e9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffead8b8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MissionPerson(size: 64, happy: _correct),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _copy('Muuzii $_target naaf kenni.',
                        'Bring me $_target bananas.'),
                    style: text.titleMedium?.copyWith(
                      color: ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(_copy('Muuzii', 'Basket'),
                    style: text.titleMedium?.copyWith(color: ink)),
              ),
              Semantics(
                liveRegion: true,
                label: _copy('Muuzii walitti qabame: $_count',
                    'Bananas in the basket: $_count'),
                child: Container(
                  key: const ValueKey('line-current'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: _correct
                        ? const Color(0xffdcecc5)
                        : const Color(0xffffe3a3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SizedBox(
                    width: countMeasure.width,
                    child: Text('$_count',
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: countStyle),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DragTarget<int>(
            key: const ValueKey('market-cart-drop'),
            onWillAccept: (index) => !_helpBusy && available.contains(index),
            onAccept: _add,
            builder: (context, candidates, rejected) => MissionBasket(
              key: _receivingBasket,
              complete: _correct || candidates.isNotEmpty,
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  runSpacing: 6,
                  children: [
                    for (var slot = 0; slot < _target; slot++)
                      SizedBox(
                        key: ValueKey(slot < _count
                            ? 'market-cart-fruit-$slot'
                            : 'market-cart-slot-$slot'),
                        width: 40,
                        height: 40,
                        child: slot < _count
                            ? TweenAnimationBuilder<double>(
                                key: ValueKey('filled-$slot'),
                                tween: Tween(
                                    begin: slot < _start ? 1 : .45, end: 1),
                                duration: reducedMotion
                                    ? Duration.zero
                                    : const Duration(milliseconds: 260),
                                curve: Curves.easeOutBack,
                                builder: (context, scale, child) =>
                                    Transform.scale(scale: scale, child: child),
                                child: const BananaToken(size: 40),
                              )
                            : DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xffd1b58e)),
                                ),
                                child: const BananaToken(size: 40, ghost: true),
                              ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Icon(
            _helpBusy ? Icons.touch_app_rounded : Icons.arrow_upward_rounded,
            color: green,
            size: 30,
          ),
          Text(
            _preparingDemo
                ? _copy('Ilaali.', 'Watch.')
                : _demonstrating
                    ? _copy('Tokko dabalame. Ilaali!', 'One more. Watch!')
                    : _correct
                        ? _copy('Ajajni guutame!', 'Order ready!')
                        : _copy('Muuzii tuqi.', 'Tap a banana.'),
            textAlign: TextAlign.center,
            style: text.titleMedium
                ?.copyWith(color: ink, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xfff5e3c4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var index = 0; index < _supply; index++)
                  SizedBox(
                    key: ValueKey('market-pile-slot-$index'),
                    width: 52,
                    height: 52,
                    child: available.contains(index)
                        ? _pileFruit(index,
                            highlighted: widget.showHint &&
                                available.isNotEmpty &&
                                index == available.first)
                        : const ExcludeSemantics(
                            child: Center(
                              child: BananaToken(size: 44, ghost: true),
                            ),
                          ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const ValueKey('line-left'),
                  onPressed: _moved.isEmpty || _helpBusy ? null : _undo,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    foregroundColor: ink,
                  ),
                  child: const Text('−1', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  key: const ValueKey('line-right'),
                  onPressed: available.isEmpty || _helpBusy ? null : _addNext,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    backgroundColor: green,
                  ),
                  child: const Text('+1', style: TextStyle(fontSize: 22)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            key: const ValueKey('market-demo'),
            onPressed:
                _helpBusy || available.isEmpty ? null : () => _prepareDemo(),
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              foregroundColor: green,
            ),
            icon: const Icon(Icons.play_circle_outline_rounded),
            label: Text(_copy('Na ilaali', 'Watch one move'),
                textAlign: TextAlign.center),
          ),
          // Success can grow the scene below the learner's fixed controls.
          if (_correct) ...[
            const SizedBox(height: 10),
            _deliveryBanner(),
          ],
        ],
      ),
    );
  }

  Widget _deliveryBanner() => Container(
        key: const ValueKey('market-delivered'),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffdcecc5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xff477e65)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                _copy('Galatoomi! Muuzii $_target.',
                    'Thank you! $_target bananas.'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: const Color(0xff513c2c))),
          ),
        ]),
      );

  Widget _pileFruit(int index, {required bool highlighted}) {
    final label = _copy('Muuzii tokko dabali', 'Add one banana');
    final fruit = SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: highlighted ? const Color(0xffffd35b) : const Color(0xfffff8e9),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _helpBusy ? null : () => _add(index),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: BananaToken(size: 44),
          ),
        ),
      ),
    );
    return Semantics(
      label: label,
      button: true,
      child: Draggable<int>(
        key: ValueKey('market-pile-fruit-$index'),
        data: index,
        maxSimultaneousDrags: _helpBusy ? 0 : 1,
        feedback: const Material(
            color: Colors.transparent, child: BananaToken(size: 52)),
        childWhenDragging: const SizedBox(
            width: 52, height: 52, child: BananaToken(size: 44, ghost: true)),
        child: fruit,
      ),
    );
  }
}
