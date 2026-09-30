import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../learning/scenarios.dart';

class AreaGridBoard extends StatefulWidget {
  const AreaGridBoard({
    super.key,
    required this.scenario,
    required this.onResult,
    this.showHint = false,
  });
  final LearningScenario scenario;
  final ValueChanged<bool> onResult;
  final bool showHint;

  @override
  State<AreaGridBoard> createState() => _AreaGridBoardState();
}

class _AreaGridBoardState extends State<AreaGridBoard> {
  final Set<int> _covered = {};
  int get _width => widget.scenario.values['width']!;
  int get _height => widget.scenario.values['height']!;

  @override
  void initState() {
    super.initState();
    _reportReset();
  }

  @override
  void didUpdateWidget(covariant AreaGridBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      _covered.clear();
      _reportReset();
    }
  }

  void _reportReset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _toggle(int index) {
    setState(() {
      if (!_covered.add(index)) _covered.remove(index);
    });
    widget.onResult(_covered.length == _width * _height);
  }

  @override
  Widget build(BuildContext context) {
    final complete = _covered.length == _width * _height;
    final next = complete
        ? null
        : List.generate(_width * _height, (i) => i)
            .firstWhere((i) => !_covered.contains(i));
    return GeometryBoardFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Icons.grid_view_rounded, color: geometryTeal),
            const SizedBox(width: 10),
            Expanded(child: Text('$_width × $_height', style: geometryHeading)),
            if (complete)
              const Icon(Icons.check_circle_rounded, color: geometryTeal),
          ]),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final side = math.max(
                48.0, math.min(56.0, (constraints.maxWidth - 20) / _width - 4));
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(color: geometryCoral, width: 4),
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFFFF0E8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        _height,
                        (row) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(_width, (column) {
                                final index = row * _width + column;
                                final selected = _covered.contains(index);
                                final suggested =
                                    widget.showHint && index == next;
                                return Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Semantics(
                                    label:
                                        'Unit square ${row + 1}, ${column + 1}',
                                    button: true,
                                    selected: selected,
                                    child: Material(
                                      color: selected
                                          ? geometryTeal
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        key: ValueKey('area-tile-$row-$column'),
                                        onTap: () => _toggle(index),
                                        borderRadius: BorderRadius.circular(8),
                                        child: AnimatedContainer(
                                          duration: MediaQuery.of(context)
                                                  .disableAnimations
                                              ? Duration.zero
                                              : const Duration(
                                                  milliseconds: 160),
                                          width: side,
                                          height: side,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: suggested
                                                    ? geometryGold
                                                    : geometryTeal
                                                        .withOpacity(.22),
                                                width: suggested ? 3 : 1),
                                          ),
                                          child: selected
                                              ? const Icon(Icons.check_rounded,
                                                  color: Colors.white, size: 26)
                                              : const Text('1',
                                                  style: TextStyle(
                                                      color: Color(0xFF8BAAA4),
                                                      fontSize: 17)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            GeometryBadge(
                key: const ValueKey('area-count'),
                text: 'Bal’ina · ${_covered.length}',
                icon: Icons.grid_view_rounded,
                color: geometryTeal),
            GeometryBadge(
                text: 'Naannawa · ${2 * (_width + _height)}',
                icon: Icons.crop_square_rounded,
                color: geometryCoral),
          ]),
          if (widget.showHint) ...[
            const SizedBox(height: 12),
            GeometryHint(
              key: const ValueKey('area-hint'),
              text: '1 □ + 1 □ + …   →   $_width × $_height □',
            ),
          ],
        ],
      ),
    );
  }
}

const geometryTeal = Color(0xFF147D73);
const geometryCoral = Color(0xFFE57554);
const geometryGold = Color(0xFFF4BB43);
const geometryHeading = TextStyle(
    fontSize: 23, fontWeight: FontWeight.w800, color: Color(0xFF193A35));

class GeometryBoardFrame extends StatelessWidget {
  const GeometryBoardFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6FAF6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDDE9E2)),
        ),
        child: child,
      );
}

class GeometryBadge extends StatelessWidget {
  const GeometryBadge(
      {super.key, required this.text, required this.icon, required this.color});
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: color.withOpacity(.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 7),
          Flexible(
              child: Text(text,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700))),
        ]),
      );
}

class GeometryHint extends StatelessWidget {
  const GeometryHint({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xFFFFF0CD),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.touch_app_rounded,
              color: Color(0xFF8A640B), size: 22),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF755207)))),
        ]),
      );
}

class GeometryStepper extends StatelessWidget {
  const GeometryStepper({
    super.key,
    required this.keyPrefix,
    required this.label,
    required this.icon,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.suffix = '',
  });
  final String keyPrefix;
  final String label;
  final IconData icon;
  final int value;
  final String suffix;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Icon(icon, color: geometryTeal, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Semantics(
              label: '$label $value$suffix',
              child: Text('$value$suffix', style: geometryHeading),
            ),
          ),
          _button('minus', Icons.remove_rounded, onMinus, 'Decrease $label'),
          const SizedBox(width: 8),
          _button('plus', Icons.add_rounded, onPlus, 'Increase $label'),
        ]),
      );

  Widget _button(String action, IconData icon, VoidCallback? callback,
          String tooltip) =>
      SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: callback == null
              ? const Color(0xFFE4EBE6)
              : const Color(0xFFDBEEE6),
          borderRadius: BorderRadius.circular(14),
          child: IconButton(
            key: ValueKey('$keyPrefix-$action'),
            tooltip: tooltip,
            icon: Icon(icon,
                color: callback == null ? Colors.grey : geometryTeal),
            onPressed: callback,
          ),
        ),
      );
}
