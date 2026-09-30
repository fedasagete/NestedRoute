import 'package:flutter/material.dart';

/// Early printed-word recognition, limited to ONE, TWO, THREE and FOUR.
class EnglishNumbersLab extends StatefulWidget {
  const EnglishNumbersLab(
      {super.key, required this.onResult, this.showHint = false});

  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<EnglishNumbersLab> createState() => _EnglishNumbersLabState();
}

class _EnglishNumbersLabState extends State<EnglishNumbersLab> {
  static const _words = {1: 'ONE', 2: 'TWO', 3: 'THREE', 4: 'FOUR'};
  static const _wordOrder = [3, 1, 4, 2];
  static const _targetOrder = [2, 4, 1, 3];
  static const _green = Color(0xFF247A67);
  static const _ink = Color(0xFF263C35);
  static const _error = Color(0xFFB43D32);

  bool _studying = true;
  int? _selected;
  final Map<int, int> _placements = {};

  int get _correctCount =>
      _placements.entries.where((entry) => entry.key == entry.value).length;
  bool get _correct => !_studying && _correctCount == 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _next() {
    setState(() => _studying = false);
    widget.onResult(false);
  }

  void _select(int word) => setState(() => _selected = word);

  void _match(int target) {
    final word = _selected;
    if (word == null) return;
    setState(() {
      // A word has only one location, so a mistaken placement can be repaired.
      _placements.removeWhere((_, placedWord) => placedWord == word);
      _placements[target] = word;
      _selected = null;
    });
    widget.onResult(_correct);
  }

  void _reset() {
    setState(() {
      _studying = true;
      _selected = null;
      _placements.clear();
    });
    widget.onResult(false);
  }

  Widget _dots(int value, String prefix) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          for (var dot = 0; dot < value; dot++)
            Container(
              key: ValueKey('english-numbers-$prefix-$value-$dot'),
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: _ink,
                shape: BoxShape.circle,
              ),
            ),
        ],
      );

  Widget _referenceCard(int value, {bool hint = false}) => Container(
        key: ValueKey(hint
            ? 'english-numbers-reference-card-$value'
            : 'english-numbers-study-$value'),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$value',
                    style: const TextStyle(
                        color: _green,
                        fontSize: 26,
                        fontWeight: FontWeight.w800)),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(_words[value]!,
                      style: const TextStyle(
                          color: _ink,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _dots(value, hint ? 'reference-dot' : 'study-dot'),
          ],
        ),
      );

  Widget _wordCard(int value) {
    final selected = _selected == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        key: ValueKey('english-numbers-word-$value'),
        onPressed: () => _select(value),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 60),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          foregroundColor: _ink,
          backgroundColor: selected ? const Color(0xFFE2F0E5) : Colors.white,
          side: BorderSide(
              color: selected ? _green : const Color(0xFFC9D3CA),
              width: selected ? 3 : 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Semantics(
          selected: selected,
          child: Text(_words[value]!,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

  Widget _target(int value) {
    final word = _placements[value];
    final wrong = word != null && word != value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        key: ValueKey('english-numbers-target-$value'),
        onPressed: _selected == null ? null : () => _match(value),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 64),
          padding: const EdgeInsets.all(12),
          foregroundColor: _ink,
          disabledForegroundColor: _ink,
          backgroundColor: wrong
              ? const Color(0xFFFFEAE5)
              : word != null
                  ? const Color(0xFFE2F0E5)
                  : const Color(0xFFF3F6EE),
          side: BorderSide(
              color: wrong ? _error : const Color(0xFFC9D3CA), width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$value',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(width: 20),
                Flexible(child: _dots(value, 'target-dot')),
              ],
            ),
            if (word != null) ...[
              const SizedBox(height: 8),
              Text(_words[word]!,
                  style: TextStyle(
                      color: wrong ? _error : _green,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              Icon(
                wrong ? Icons.close_rounded : Icons.check_rounded,
                key: ValueKey(wrong
                    ? 'english-numbers-error-$value'
                    : 'english-numbers-correct-$value'),
                color: wrong ? _error : _green,
                semanticLabel: wrong ? 'Try again' : 'Correct match',
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: Text(_studying ? 'Gocha' : 'Gilgaala',
                style: const TextStyle(
                    color: _green, fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              key: const ValueKey('english-numbers-reset'),
              tooltip: 'Reset',
              onPressed: _reset,
              icon: const Icon(Icons.replay_rounded),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        if (_studying) ...[
          for (final value in _words.keys) _referenceCard(value),
          ElevatedButton(
            key: const ValueKey('english-numbers-next'),
            onPressed: _next,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(48, 56), backgroundColor: _green),
            child: const Icon(Icons.arrow_forward_rounded,
                size: 32, semanticLabel: 'Start matching'),
          ),
        ] else ...[
          for (final value in _wordOrder) _wordCard(value),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(Icons.arrow_downward_rounded, color: _green, size: 28),
          ),
          for (final value in _targetOrder) _target(value),
          Center(
            child: Text('$_correctCount / 4',
                key: const ValueKey('english-numbers-progress'),
                style: const TextStyle(
                    color: _green, fontSize: 24, fontWeight: FontWeight.w800)),
          ),
          if (_correct)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.check_circle_rounded,
                  key: ValueKey('english-numbers-complete'),
                  color: _green,
                  size: 40,
                  semanticLabel: 'All four matches correct'),
            ),
          if (widget.showHint)
            Column(
              key: const ValueKey('english-numbers-reference'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Center(child: Icon(Icons.lightbulb_outline_rounded)),
                const SizedBox(height: 8),
                for (final value in _words.keys)
                  _referenceCard(value, hint: true),
              ],
            ),
        ],
      ]);
}
