import 'package:flutter/material.dart';

/// Signed-chip removal model for Grade 7, printed page 42.
class SignedProductsLab extends StatefulWidget {
  const SignedProductsLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<SignedProductsLab> createState() => _SignedProductsLabState();
}

class _SignedProductsLabState extends State<SignedProductsLab> {
  static const _green = Color(0xFF247A67);
  int _pairs = 0;
  int _removed = 0;
  bool get _correct => _pairs == 6 && _removed == 3;

  void _addPair() {
    if (_pairs == 6) return;
    setState(() => _pairs++);
    widget.onResult(false);
  }

  void _removeDebt() {
    if (_pairs != 6 || _removed == 3) return;
    setState(() => _removed++);
    widget.onResult(_correct);
  }

  void _restoreDebt() {
    if (_removed == 0) return;
    setState(() => _removed--);
    widget.onResult(false);
  }

  void _reset() {
    setState(() {
      _pairs = 0;
      _removed = 0;
    });
    widget.onResult(false);
  }

  Widget _chip({required bool positive, required bool present}) {
    final color = positive ? _green : const Color(0xFFBB665B);
    return Container(
        width: 43,
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: present ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
                color: color.withOpacity(present ? 1 : 0.24), width: 2)),
        child: present
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(positive ? '+1' : '−1',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18)))
            : Icon(positive ? Icons.add_rounded : Icons.remove_rounded,
                size: 20, color: color.withOpacity(0.2)));
  }

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Baay’isuu',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _green, fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 12),
        const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('−3 × (−2) = ?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
        const SizedBox(height: 20),
        Center(
            child: Container(
                key: const ValueKey('signed-products-net'),
                width: 100,
                height: 82,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: _correct ? _green : const Color(0xFFFFE1A5),
                    borderRadius: BorderRadius.circular(26)),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_removed == 0 ? '0' : '+${_removed * 2}',
                        style: TextStyle(
                            color: _correct
                                ? Colors.white
                                : const Color(0xFF443928),
                            fontSize: 38,
                            fontWeight: FontWeight.w800))))),
        const SizedBox(height: 18),
        LayoutBuilder(
            builder: (context, constraints) =>
                Wrap(spacing: 10, runSpacing: 10, children: [
                  for (var i = 0; i < 6; i++)
                    Container(
                        key: ValueKey('signed-products-pair-$i'),
                        width: (constraints.maxWidth - 10) / 2,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF1F6EE),
                            borderRadius: BorderRadius.circular(18)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _chip(positive: true, present: i < _pairs),
                              const SizedBox(width: 8),
                              _chip(
                                  positive: false,
                                  present: i < _pairs && i >= _removed * 2),
                            ])),
                ])),
        const SizedBox(height: 16),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$_pairs × 0     |     $_removed / 3',
                key: const ValueKey('signed-products-progress'),
                style: const TextStyle(
                    color: _green, fontSize: 20, fontWeight: FontWeight.w700))),
        const SizedBox(height: 16),
        OutlinedButton(
            key: const ValueKey('signed-products-add-pair'),
            onPressed: _pairs < 6 ? _addPair : null,
            style: OutlinedButton.styleFrom(
                foregroundColor: _green,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('(+1) + (−1)',
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 12),
        ElevatedButton(
            key: const ValueKey('signed-products-remove'),
            onPressed: _pairs == 6 && _removed < 3 ? _removeDebt : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 56),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('− (−2)',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w800)))),
        if (_correct) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('signed-products-formula'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE2F0E5),
                  borderRadius: BorderRadius.circular(18)),
              child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('−3 × (−2) = +6',
                      style: TextStyle(
                          color: _green,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)))),
        ],
        if (widget.showHint) ...[
          const SizedBox(height: 16),
          Container(
              key: const ValueKey('signed-products-hint'),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D8),
                  borderRadius: BorderRadius.circular(18)),
              child: const Column(children: [
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('(+1) + (−1) = 0',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w700))),
                SizedBox(height: 10),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('0 − (−2) = +2',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w700))),
              ])),
        ],
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
              key: const ValueKey('signed-products-restore'),
              tooltip: '↶',
              onPressed: _removed > 0 ? _restoreDebt : null,
              icon: const Icon(Icons.undo_rounded),
              color: _green),
          IconButton(
              key: const ValueKey('signed-products-reset'),
              tooltip: '↻',
              onPressed: _reset,
              icon: const Icon(Icons.replay_rounded),
              color: _green),
        ]),
      ]);
}
