import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../learning/scenarios.dart';
import 'mission_art.dart';

/// Tangible equal sharing for the small, exact-division picnic scenarios.
class PicnicSharingBoard extends StatefulWidget {
  const PicnicSharingBoard(
      {super.key,
      required this.scenario,
      required this.onResult,
      this.showHint = false,
      this.english = false,
      this.demonstrateOnStart = false,
      this.onHelpUsed,
      this.onAction});
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint, english, demonstrateOnStart;
  final VoidCallback? onHelpUsed, onAction;
  @override
  State<PicnicSharingBoard> createState() => _PicnicSharingBoardState();
}

class _PicnicSharingBoardState extends State<PicnicSharingBoard> {
  static const _teal = Color(0xFF247A67);
  static const _coral = Color(0xFFC36B4B);
  late List<int> _shares;
  late List<GlobalKey> _receiverKeys;
  Timer? _demoTimer;
  bool _demoing = false;
  int _entryVersion = 0;
  int get _total => widget.scenario.values['total']!;
  int get _people => widget.scenario.values['people']!;
  int get _each => _total ~/ _people;
  int get _remaining => _total - _shares.fold(0, (sum, count) => sum + count);
  bool get _correct =>
      _remaining == 0 && _shares.every((count) => count == _each);
  bool get _unequal => _shares.any((count) => count != _shares.first);

  @override
  void initState() {
    super.initState();
    _shares = List.filled(_people, 0);
    _receiverKeys = List.generate(_people, (_) => GlobalKey());
    _scheduleEntry();
  }

  void _scheduleEntry({bool allowDemo = true}) {
    final version = ++_entryVersion;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || version != _entryVersion || _demoing) return;
      if (allowDemo && widget.demonstrateOnStart) {
        _demonstrate(singleMove: true);
      } else {
        widget.onResult(false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PicnicSharingBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id ||
        oldWidget.scenario.values['total'] != _total ||
        oldWidget.scenario.values['people'] != _people) {
      _demoTimer?.cancel();
      _demoing = false;
      _shares = List.filled(_people, 0);
      _receiverKeys = List.generate(_people, (_) => GlobalKey());
      _scheduleEntry(allowDemo: oldWidget.scenario.id != widget.scenario.id);
    }
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    super.dispose();
  }

  void _move(int friend, int amount) {
    if (_demoing ||
        amount > 0 && _remaining == 0 ||
        amount < 0 && _shares[friend] == 0) return;
    setState(() => _shares[friend] += amount);
    widget.onAction?.call();
    widget.onResult(_correct);
  }

  void _reset() {
    if (_demoing) return;
    _demoTimer?.cancel();
    setState(() => _shares = List.filled(_people, 0));
    widget.onResult(false);
  }

  bool _currentDemo(int version) =>
      mounted && version == _entryVersion && _demoing;

  Future<bool> _scrollReceiver(int friend, int version,
      ScrollPositionAlignmentPolicy policy, Duration duration) {
    if (!_currentDemo(version)) return Future.value(false);
    final receiver = _receiverKeys[friend].currentContext;
    if (receiver == null) return Future.value(false);
    return Scrollable.ensureVisible(receiver,
            alignment: 1, alignmentPolicy: policy, duration: duration)
        .then((_) => _currentDemo(version));
  }

  Future<bool> _showReceiver(int friend, int version) async {
    if (!_currentDemo(version)) return false;
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 200);
    if (!await _scrollReceiver(friend, version,
        ScrollPositionAlignmentPolicy.keepVisibleAtEnd, duration)) return false;
    // keepVisibleAtEnd reveals cards below the viewport. Its complementary
    // policy is needed when Watch was pressed below an earlier receiving card.
    return _scrollReceiver(friend, version,
        ScrollPositionAlignmentPolicy.keepVisibleAtStart, duration);
  }

  Future<void> _demonstrate({bool singleMove = false}) async {
    if (_demoing) return;
    final version = _entryVersion;
    final learnerShares = List<int>.of(_shares);
    widget.onHelpUsed?.call();
    setState(() {
      _demoing = true;
      _shares = List.filled(_people, 0);
    });
    widget.onResult(false);
    // Let the help callback's hint layout settle, then show the actual receiving
    // plate and count before the teacher moves its first banana.
    await WidgetsBinding.instance.endOfFrame;
    if (!_currentDemo(version) || !await _showReceiver(0, version)) return;
    var moved = 0;
    final moves = singleMove ? 1 : _total;
    // Discrete steps remain readable with reduced motion. MissionBasket also
    // disables its decorative animation when disableAnimations is set.
    void nextStep() {
      if (!_currentDemo(version)) return;
      _demoTimer = Timer(const Duration(milliseconds: 500), () async {
        if (!_currentDemo(version)) return;
        if (moved < moves) {
          final friend = moved % _people;
          if (!await _showReceiver(friend, version)) return;
          setState(() => _shares[friend]++);
          moved++;
          await WidgetsBinding.instance.endOfFrame;
          if (!_currentDemo(version) || !await _showReceiver(friend, version)) {
            return;
          }
          nextStep();
          return;
        }
        _demoTimer = null;
        setState(() {
          _shares = learnerShares;
          _demoing = false;
        });
        widget.onResult(_correct);
      });
    }

    nextStep();
  }

  Widget _fruit(int friend, int index) => SizedBox(
        width: 48,
        height: 48,
        child: IconButton(
          key: ValueKey('picnic-fruit-$friend-$index'),
          tooltip: widget.english ? 'Return one banana' : 'Muuzii deebisi',
          onPressed: _demoing ? null : () => _move(friend, -1),
          padding: EdgeInsets.zero,
          icon: const BananaToken(),
        ),
      );

  Widget _supplyFruit(int index) => Draggable<int>(
        key: ValueKey('picnic-supply-$index'),
        data: 1,
        maxSimultaneousDrags: _demoing ? 0 : 1,
        feedback: const Material(
            color: Colors.transparent,
            child: SizedBox(
                width: 48,
                height: 48,
                child: Center(child: BananaToken(size: 40)))),
        childWhenDragging: const SizedBox(width: 48, height: 48),
        child: Semantics(
            label: widget.english ? 'Drag a banana to a plate' : 'Muuzii',
            child: const SizedBox(
                width: 48, height: 48, child: Center(child: BananaToken()))),
      );

  Widget _friend(int friend) {
    final count = _shares[friend];
    final fair = count == _each;
    return DragTarget<int>(
      onWillAccept: (banana) => !_demoing && _remaining > 0 && banana == 1,
      onAccept: (_) => _move(friend, 1),
      builder: (context, candidates, rejected) => KeyedSubtree(
        key: _receiverKeys[friend],
        child: Container(
          key: ValueKey('picnic-friend-$friend'),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: fair ? const Color(0xFFE6F3DE) : const Color(0xFFFFF6E7),
              border: Border.all(
                  color: candidates.isNotEmpty || fair
                      ? _teal
                      : count > _each
                          ? _coral
                          : const Color(0xFFE4CAA4),
                  width: 2),
              borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              MissionPerson(
                  key: ValueKey('picnic-person-$friend'),
                  size: 56,
                  happy: fair,
                  color: const [
                    Color(0xFF477E75),
                    Color(0xFF927BB3),
                    Color(0xFF5D91B0),
                    Color(0xFFBA7645)
                  ][friend % 4]),
              const SizedBox(width: 8),
              Flexible(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('$count',
                          key: ValueKey('share-count-$friend'),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: _teal)))),
            ]),
            const SizedBox(height: 8),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              child: InkWell(
                key: ValueKey('picnic-plate-$friend'),
                borderRadius: BorderRadius.circular(26),
                onTap:
                    !_demoing && _remaining > 0 ? () => _move(friend, 1) : null,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 100),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFD5DED4), width: 2),
                      borderRadius: BorderRadius.circular(26)),
                  child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (var i = 0; i < count; i++) _fruit(friend, i),
                        if (widget.showHint && count < _each)
                          for (var i = count; i < _each; i++)
                            const SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(child: BananaToken(ghost: true))),
                      ]),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                      key: ValueKey('share-remove-$friend'),
                      tooltip: '−1',
                      onPressed: !_demoing && count > 0
                          ? () => _move(friend, -1)
                          : null,
                      icon: const Icon(Icons.remove_rounded),
                      color: _teal)),
              SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                      key: ValueKey('share-add-$friend'),
                      tooltip: '+1',
                      onPressed: !_demoing && _remaining > 0
                          ? () => _move(friend, 1)
                          : null,
                      icon: const Icon(Icons.add_rounded),
                      color: _teal)),
            ]),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey('picnic-sharing-board'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: Text(
                    widget.english ? 'Share equally.' : 'Walqixa hirii.',
                    style: const TextStyle(
                        color: _teal,
                        fontSize: 21,
                        fontWeight: FontWeight.w800))),
            SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                    key: const ValueKey('picnic-reset'),
                    tooltip:
                        widget.english ? 'Empty the plates' : 'Irra deebi’i',
                    onPressed: _demoing ? null : _reset,
                    icon: const Icon(Icons.replay_rounded))),
          ]),
          const SizedBox(height: 8),
          Text(
              widget.english
                  ? 'Tap a plate to give one. Tap its banana to return it.'
                  : 'Saanii tuqi: +1. Muuzii tuqi: ↩.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF5C7167))),
          const SizedBox(height: 14),
          MissionBasket(
              complete: !_demoing && _correct,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.shopping_basket_outlined,
                      color: Color(0xFF936222)),
                  const SizedBox(width: 12),
                  Text('$_remaining',
                      key: const ValueKey('supply-count'),
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800)),
                ]),
                // Keep every original slot: losing a fruit must not move the
                // plates or their drop targets upward at a Wrap row boundary.
                Wrap(
                    key: const ValueKey('picnic-supply-tray'),
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (var i = 0; i < _total; i++)
                        if (i < _remaining)
                          _supplyFruit(i)
                        else
                          SizedBox(
                              key: ValueKey('picnic-vacant-supply-$i'),
                              width: 48,
                              height: 48),
                    ]),
              ])),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Icon(Icons.arrow_downward_rounded, color: _teal)),
          LayoutBuilder(builder: (context, constraints) {
            final columns =
                constraints.maxWidth >= 256 ? math.min(2, _people) : 1;
            final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: const Color(0xFFF1E5D2),
                  borderRadius: BorderRadius.circular(20)),
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                for (var i = 0; i < _people; i++)
                  SizedBox(width: width, child: _friend(i)),
              ]),
            );
          }),
          if (_unequal)
            const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(Icons.balance_rounded,
                    key: ValueKey('picnic-unequal'), color: _coral)),
          if (!_demoing && _correct)
            const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(Icons.check_circle_rounded,
                    key: ValueKey('picnic-complete'), color: _teal, size: 36)),
          const SizedBox(height: 12),
          if (_demoing)
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                    widget.english ? 'Watch the bananas move.' : 'Fakkeenya',
                    key: const ValueKey('picnic-demo-running'),
                    textAlign: TextAlign.center)),
          OutlinedButton.icon(
              key: const ValueKey('picnic-demo'),
              onPressed: _demoing ? null : _demonstrate,
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 52)),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: Text(widget.english ? 'Watch sharing' : 'Fakkeenya')),
        ],
      );
}
