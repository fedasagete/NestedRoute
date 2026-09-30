import 'package:flutter/material.dart';
import '../games/area_grid_board.dart';

class InequalityLab extends StatefulWidget {
  const InequalityLab(
      {super.key, required this.onResult, this.showHint = false});
  final ValueChanged<bool> onResult;
  final bool showHint;
  @override
  State<InequalityLab> createState() => _InequalityLabState();
}

class _InequalityLabState extends State<InequalityLab> {
  bool _negative = false;
  int _boundary = 0;
  bool? _right;
  bool? _open;
  bool _zero = false;
  bool _minusFour = false;
  int get _factor => _negative ? -2 : 2;
  bool get _correct =>
      _negative &&
      _boundary == -3 &&
      _right == true &&
      _open == true &&
      _zero &&
      _minusFour;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onResult(false);
    });
  }

  void _change(VoidCallback change) {
    setState(() {
      change();
      _zero = false;
      _minusFour = false;
    });
    widget.onResult(_correct);
  }

  void _verify(bool zero) {
    setState(() {
      if (zero) {
        _zero = true;
      } else {
        _minusFour = true;
      }
    });
    widget.onResult(_correct);
  }

  void _reset() => _change(() {
        _negative = false;
        _boundary = 0;
        _right = null;
        _open = null;
      });

  @override
  Widget build(BuildContext context) => GeometryBoardFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Expanded(child: Text('−2x < 6', style: geometryHeading)),
              IconButton(
                  key: const ValueKey('inequality-reset'),
                  tooltip: 'Reset inequality',
                  onPressed: _reset,
                  icon: const Icon(Icons.replay_rounded, color: geometryTeal)),
            ]),
            OutlinedButton.icon(
                key: const ValueKey('inequality-reflect'),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    backgroundColor:
                        _negative ? const Color(0xFFDDEFE5) : Colors.white,
                    foregroundColor: geometryTeal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () => _change(() => _negative = !_negative),
                icon: const Icon(Icons.flip_rounded),
                label: const Text('× (−2)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
            const SizedBox(height: 8),
            Semantics(
              label: 'Multiplication by $_factor maps each upper number '
                  'to its lower number. The target lower region is less than 6.',
              child: SizedBox(
                key: const ValueKey('inequality-number-lines'),
                height: 174,
                child: CustomPaint(
                    painter: _InequalityPainter(
                        factor: _factor,
                        boundary: _boundary,
                        right: _right,
                        open: _open)),
              ),
            ),
            GeometryStepper(
                keyPrefix: 'inequality-boundary',
                label: 'Boundary',
                icon: Icons.place_outlined,
                value: _boundary,
                onMinus:
                    _boundary > -6 ? () => _change(() => _boundary--) : null,
                onPlus:
                    _boundary < 6 ? () => _change(() => _boundary++) : null),
            Text('$_factor × ($_boundary) = ${_factor * _boundary}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: geometryTeal,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Text('${_factor * _boundary} ÷ ($_factor) = $_boundary',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: geometryTeal,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _choice('inequality-left', 'x < $_boundary',
                      _right == false, () => _change(() => _right = false))),
              const SizedBox(width: 8),
              Expanded(
                  child: _choice('inequality-right', 'x > $_boundary',
                      _right == true, () => _change(() => _right = true))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child: Semantics(
                      label: 'Open boundary, exclude equality',
                      child: _choice('inequality-open', '○', _open == true,
                          () => _change(() => _open = true),
                          icon: Icons.radio_button_unchecked_rounded))),
              const SizedBox(width: 8),
              Expanded(
                  child: Semantics(
                      label: 'Closed boundary, include equality',
                      child: _choice('inequality-closed', '●', _open == false,
                          () => _change(() => _open = false),
                          icon: Icons.circle_rounded))),
            ]),
            if (_boundary == -3) ...[
              const SizedBox(height: 8),
              const Text('6 < 6  ✗',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: geometryCoral)),
            ],
            const SizedBox(height: 12),
            _sample('inequality-sample-zero', 'x = 0', '0 < 6  ✓', _zero, true),
            const SizedBox(height: 8),
            _sample('inequality-sample-minus-four', 'x = −4', '8 < 6  ✗',
                _minusFour, false),
            if (_correct) ...[
              const SizedBox(height: 12),
              const GeometryBadge(
                  text: 'x > −3',
                  icon: Icons.check_circle_rounded,
                  color: geometryTeal),
            ],
            if (widget.showHint) ...[
              const SizedBox(height: 12),
              const GeometryHint(
                  key: ValueKey('inequality-hint'),
                  text: '−4 < 0   → ×(−2) →   8 > 0'),
            ],
          ],
        ),
      );

  Widget _choice(String key, String text, bool selected, VoidCallback action,
          {IconData? icon}) =>
      OutlinedButton(
        key: ValueKey(key),
        onPressed: action,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          backgroundColor: selected ? const Color(0xFFDDEFE5) : Colors.white,
          foregroundColor: geometryTeal,
          side: BorderSide(
              color: selected ? geometryTeal : const Color(0xFFBDCDC4),
              width: selected ? 2 : 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: icon == null
            ? Text(text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
            : Icon(icon, size: 26),
      );

  Widget _sample(
          String key, String input, String result, bool checked, bool zero) =>
      OutlinedButton(
        key: ValueKey(key),
        onPressed: _negative ? () => _verify(zero) : null,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.all(12),
          foregroundColor: geometryTeal,
          backgroundColor: checked ? const Color(0xFFFFF0CD) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(children: [
          Text(input,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          if (checked) ...[
            const SizedBox(height: 6),
            Text(result,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: zero ? geometryTeal : geometryCoral)),
          ],
        ]),
      );
}

class _InequalityPainter extends CustomPainter {
  const _InequalityPainter(
      {required this.factor,
      required this.boundary,
      required this.right,
      required this.open});
  final int factor;
  final int boundary;
  final bool? right;
  final bool? open;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 12.0;
    final span = size.width - 24;
    double x(num value) => left + (value + 6) / 12 * span;
    double y(num value) => left + (value + 12) / 24 * span;
    const upper = 30.0;
    const lower = 130.0;
    final axis = Paint()
      ..color = const Color(0xFF526B61)
      ..strokeWidth = 2;
    if (right != null) {
      final start = right! ? x(boundary) : left;
      final end = right! ? left + span : x(boundary);
      canvas.drawLine(
          Offset(start, upper),
          Offset(end, upper),
          Paint()
            ..color = geometryTeal.withOpacity(.28)
            ..strokeWidth = 12);
    }
    canvas.drawLine(
        const Offset(left, lower),
        Offset(y(6), lower),
        Paint()
          ..color = geometryCoral.withOpacity(.3)
          ..strokeWidth = 12);
    canvas.drawLine(
        const Offset(left, upper), Offset(left + span, upper), axis);
    canvas.drawLine(
        const Offset(left, lower), Offset(left + span, lower), axis);
    for (final tick in [-6, -3, 0, 3, 6]) {
      canvas.drawLine(
          Offset(x(tick), upper - 4), Offset(x(tick), upper + 4), axis);
      _label(canvas, '$tick', Offset(x(tick), upper - 15), 12);
    }
    for (final tick in [-12, -6, 0, 6, 12]) {
      canvas.drawLine(
          Offset(y(tick), lower - 4), Offset(y(tick), lower + 4), axis);
      _label(canvas, '$tick', Offset(y(tick), lower + 17), 12);
    }
    for (final sample in [-4, 0, 3]) {
      final start = Offset(x(sample), upper + 8);
      final end = Offset(y(sample * factor), lower - 9);
      final arrow = Paint()
        ..color = (sample == -4 ? geometryCoral : geometryTeal).withOpacity(.6)
        ..strokeWidth = 1.8;
      canvas.drawLine(start, end, arrow);
      final direction = (end - start) / (end - start).distance;
      final normal = Offset(-direction.dy, direction.dx);
      canvas.drawLine(end, end - direction * 8 + normal * 4, arrow);
      canvas.drawLine(end, end - direction * 8 - normal * 4, arrow);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(size.width / 2, 80), width: 58, height: 28),
            const Radius.circular(8)),
        Paint()..color = const Color(0xFFF6FAF6));
    _label(canvas, '× $factor', Offset(size.width / 2, 80), 16);
    final marker = Offset(x(boundary), upper);
    canvas.drawCircle(marker, 6,
        Paint()..color = open == false ? geometryTeal : Colors.white);
    canvas.drawCircle(
        marker,
        6,
        Paint()
          ..color = geometryTeal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4);
    final target = Offset(y(6), lower);
    canvas.drawCircle(target, 6, Paint()..color = Colors.white);
    canvas.drawCircle(
        target,
        6,
        Paint()
          ..color = geometryCoral
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4);
    final mapped = Offset(y(boundary * factor), lower);
    canvas.drawCircle(
        mapped,
        9,
        Paint()
          ..color = geometryGold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  void _label(Canvas canvas, String value, Offset center, double fontSize) {
    final text = TextPainter(
        text: TextSpan(
            text: value,
            style: TextStyle(
                color: const Color(0xFF29473D),
                fontSize: fontSize,
                fontWeight: FontWeight.w800)),
        textDirection: TextDirection.ltr)
      ..layout();
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
  }

  @override
  bool shouldRepaint(covariant _InequalityPainter oldDelegate) =>
      oldDelegate.factor != factor ||
      oldDelegate.boundary != boundary ||
      oldDelegate.right != right ||
      oldDelegate.open != open;
}
