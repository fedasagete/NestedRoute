import 'package:flutter/material.dart';

import 'lesson_instruction.dart';

/// A visible, short instruction at a time, beside the learner's real board.
class LessonGuide extends StatefulWidget {
  const LessonGuide(
      {super.key,
      required this.steps,
      required this.english,
      required this.color,
      this.title});
  final List<LessonInstruction> steps;
  final bool english;
  final Color color;
  final String? title;

  @override
  State<LessonGuide> createState() => _LessonGuideState();
}

class _LessonGuideState extends State<LessonGuide> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) return const SizedBox.shrink();
    final instruction = widget.steps[step];
    return Container(
      key: const ValueKey('lesson-guide'),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.color.withOpacity(.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          IconButton(
              key: const ValueKey('guide-previous'),
              tooltip:
                  widget.english ? 'Previous instruction' : 'Tartiiba darbe',
              onPressed: step == 0 ? null : () => setState(() => step--),
              icon: const Icon(Icons.arrow_back_rounded)),
          Expanded(
              child: Text(
                  '${widget.title ?? (widget.english ? 'How to play' : 'Akkaataa taphachuu')}\n${step + 1} / ${widget.steps.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: widget.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w800))),
          IconButton(
              key: const ValueKey('guide-next'),
              tooltip:
                  widget.english ? 'Next instruction' : 'Tartiiba itti aanu',
              onPressed: step + 1 == widget.steps.length
                  ? null
                  : () => setState(() => step++),
              icon: const Icon(Icons.arrow_forward_rounded)),
        ]),
        const SizedBox(height: 6),
        Text(widget.english ? instruction.english : instruction.oromo,
            key: ValueKey('guide-step-$step'),
            style: const TextStyle(fontSize: 18, height: 1.35)),
        const SizedBox(height: 8),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(instruction.visual,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22, height: 1.3, fontWeight: FontWeight.w800))),
      ]),
    );
  }
}
