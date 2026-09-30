import 'package:flutter/material.dart';
import '../games/number_line_board.dart';
import '../games/market_order_board.dart';
import '../games/packing_mission_board.dart';
import '../games/picnic_sharing_board.dart';
import '../games/mission_art.dart';
import '../games/equal_groups_board.dart';
import '../games/sharing_board.dart';
import '../games/fraction_tiles_board.dart';
import '../games/balance_board.dart';
import '../games/area_grid_board.dart';
import '../games/angle_builder_board.dart';
import '../games/similarity_board.dart';
import '../games/volume_board.dart';
import '../games/probability_board.dart';
import '../games/sets_board.dart';
import '../games/data_board.dart';
import '../labs/fraction_division_lab.dart';
import '../labs/signed_products_lab.dart';
import '../labs/ratio_lab.dart';
import '../labs/pythagoras_lab.dart';
import '../labs/circle_angles_lab.dart';
import '../labs/inequality_lab.dart';
import '../labs/square_root_lab.dart';
import '../labs/congruence_lab.dart';
import '../labs/english_numbers_lab.dart';
import 'discoveries.dart';
import 'lesson_copy.dart';
import 'progress.dart';
import 'scenarios.dart';
import 'recommendations.dart';
import 'lesson_guide.dart';
import 'lesson_instruction.dart';
import 'board_instructions.dart';
import 'discovery_instructions.dart';
import 'prerequisites.dart';
import 'worked_solutions.dart';
import 'mission_instructions.dart';

class HerregaApp extends StatelessWidget {
  const HerregaApp({super.key, this.store, this.catalogue});
  final ProgressStore? store;
  final List<LearningScenario>? catalogue;
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Herrega',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff296b65)),
            scaffoldBackgroundColor: const Color(0xfff6f5ef),
            filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)))),
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)))),
        home: _LearningHome(
            store: store ?? ProgressStore(),
            catalogue: catalogue ?? buildScenarios()),
      );
}

class _LearningHome extends StatefulWidget {
  const _LearningHome({required this.store, required this.catalogue});
  final ProgressStore store;
  final List<LearningScenario> catalogue;
  @override
  State<_LearningHome> createState() => _LearningHomeState();
}

class _LearningHomeState extends State<_LearningHome> {
  ProgressState progress = ProgressState();
  bool loading = true, storageError = false, english = false;
  bool cooperative = false;
  int teamTurn = 0;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      progress = await widget.store.load();
    } catch (_) {
      storageError = true;
    }
    if (mounted) setState(() => loading = false);
  }

  Future<bool> save() async {
    try {
      await widget.store.save(progress);
      return true;
    } catch (_) {
      if (mounted) setState(() => storageError = true);
      return false;
    }
  }

  LearningScenario get recommended {
    return recommendScenario(widget.catalogue, progress,
        cooperative: cooperative, includePractice: true)!;
  }

  Future<void> open(LearningScenario scenario,
      {bool returningToActivity = false, bool replace = false}) async {
    final basics = <LearningScenario>[];
    for (final kind in basicsFor(scenario)) {
      final foundation = widget.catalogue
          .where((s) => s.kind == kind && s.level == 1)
          .toList();
      final next = recommendScenario(foundation, progress);
      if (next != null) basics.add(next);
    }
    final route = MaterialPageRoute<void>(
        builder: (_) => _LessonScreen(
            scenario: scenario,
            progress: progress,
            onSave: save,
            english: english,
            storageError: storageError,
            basics: basics,
            onOpenBasics: (s) => open(s, returningToActivity: true),
            returningToActivity: returningToActivity,
            cooperative: cooperative,
            initialTurn: teamTurn,
            onTurnChanged: (turn) => teamTurn = turn,
            onNext: () => open(recommended, replace: true)));
    if (replace) {
      await Navigator.of(context).pushReplacement<void, void>(route);
    } else {
      await Navigator.of(context).push<void>(route);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (widget.catalogue.isEmpty) {
      return const Scaffold(body: Center(child: Text('Herrega')));
    }
    final next = recommended;
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child:
                        ListView(padding: const EdgeInsets.all(22), children: [
                      Row(children: [
                        const CircleAvatar(
                            backgroundColor: Color(0xffdceaca),
                            foregroundColor: Color(0xff254b42),
                            child: Icon(Icons.auto_awesome_rounded)),
                        const SizedBox(width: 10),
                        const Expanded(
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text('Herrega',
                                    style: TextStyle(
                                        fontSize: 29,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xff234840))))),
                        Text('★ ${progress.stars}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                            key: const ValueKey('language-toggle'),
                            tooltip: 'Afaan Oromoo / English',
                            onPressed: () => setState(() => english = !english),
                            icon: const Icon(Icons.translate_rounded)),
                      ]),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: _modeButton(false)),
                        const SizedBox(width: 8),
                        Expanded(child: _modeButton(true)),
                      ]),
                      const SizedBox(height: 14),
                      Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xff244f4b),
                                Color(0xff39756a)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Icon(Icons.offline_bolt_rounded,
                                      color: Color(0xffd9eca8), size: 22),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          english
                                              ? 'LEARN BY DOING'
                                              : 'TAPHADHU • BARADHU',
                                          style: const TextStyle(
                                              color: Color(0xffd9eca8),
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.2))),
                                ]),
                                const SizedBox(height: 17),
                                Row(children: [
                                  Expanded(
                                      child: Text(
                                          english
                                              ? 'Make it happen.'
                                              : 'Taphadhu.\nBaradhu.',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      360
                                                  ? 26
                                                  : 31,
                                              height: 1.18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900))),
                                  const MissionPerson(
                                      size: 74,
                                      happy: true,
                                      color: Color(0xffd5b05d)),
                                ]),
                                const SizedBox(height: 18),
                                Text(_missionName(next, english),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 18)),
                                const SizedBox(height: 12),
                                SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                        key:
                                            const ValueKey('recommended-start'),
                                        style: FilledButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xffd6e8ac),
                                            foregroundColor:
                                                const Color(0xff234840)),
                                        onPressed: () => open(next),
                                        icon: const Icon(
                                            Icons.play_arrow_rounded),
                                        label: Text(
                                            english ? 'Play next' : 'Jalqabi',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)))),
                              ])),
                      const SizedBox(height: 22),
                      Row(children: [
                        Expanded(
                            child: _stat(
                                '✓',
                                progress.practiceCount,
                                english
                                    ? 'Goals completed'
                                    : 'Tapha xumurame')),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _stat('★', progress.masteredCount,
                                english ? 'Solved alone' : 'Ofii furame')),
                      ]),
                      if (storageError) _storageWarning(),
                      const SizedBox(height: 18),
                      Text(english ? 'Pick a mission' : 'Tapha filadhu',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      for (final kind in [
                        GameKind.numberLine,
                        GameKind.equalGroups,
                        GameKind.sharing
                      ])
                        if (widget.catalogue.any((s) => s.kind == kind))
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _missionCard(kind)),
                      const SizedBox(height: 8),
                      _discoveryCard(discoveryActivities.firstWhere(
                          (a) => a.scenario.id == 'discovery-englishNumbers')),
                      const SizedBox(height: 26),
                      Text(
                          english
                              ? 'Explore the learning path'
                              : 'Barnoota filadhu',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff254b46))),
                      const SizedBox(height: 14),
                      LayoutBuilder(builder: (context, constraints) {
                        final columns = constraints.maxWidth > 550 ? 3 : 2;
                        final width =
                            (constraints.maxWidth - (columns - 1) * 12) /
                                columns;
                        return Wrap(spacing: 12, runSpacing: 12, children: [
                          for (final kind in GameKind.values)
                            if (widget.catalogue.any((s) => s.kind == kind))
                              SizedBox(width: width, child: _topicCard(kind)),
                        ]);
                      }),
                      const SizedBox(height: 28),
                      Text(
                          english
                              ? 'Discover a harder idea'
                              : 'Hubannoo haaraa',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff254b46))),
                      const SizedBox(height: 14),
                      for (final activity in discoveryActivities.where(
                          (a) => a.scenario.id != 'discovery-englishNumbers'))
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _discoveryCard(activity)),
                      const SizedBox(height: 28),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                size: 16, color: Color(0xff698580)),
                            const SizedBox(width: 6),
                            Flexible(
                                child: Text(
                                    english
                                        ? 'Offline • progress stays on this device'
                                        : 'Offline • 💾',
                                    style: const TextStyle(
                                        color: Color(0xff698580)))),
                          ]),
                      const SizedBox(height: 18),
                    ])))));
  }

  Widget _stat(String symbol, int value, String label) => Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$symbol $value',
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Color(0xff326b61))),
        Text(label, style: const TextStyle(color: Color(0xff738c86))),
      ]));

  Widget _modeButton(bool friends) => OutlinedButton.icon(
      key: ValueKey(friends ? 'mode-friends' : 'mode-solo'),
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          backgroundColor:
              cooperative == friends ? const Color(0xffdceaca) : Colors.white),
      onPressed: () => setState(() => cooperative = friends),
      icon: Icon(friends ? Icons.people_alt_rounded : Icons.person_rounded),
      label: Text(english
          ? (friends ? 'Together' : 'Solo')
          : (friends ? 'Waliin' : 'Kophaa')));

  Widget _missionCard(GameKind kind) {
    final choices = widget.catalogue.where((s) => s.kind == kind).toList();
    final chosen = recommendScenario(choices, progress, includePractice: true)!;
    return Material(
        color: const Color(0xfffff9ec),
        borderRadius: BorderRadius.circular(22),
        child: Semantics(
            button: true,
            child: InkWell(
                key: ValueKey('mission-${kind.name}'),
                borderRadius: BorderRadius.circular(22),
                onTap: () => open(chosen),
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(children: [
                      const MissionPerson(size: 46, happy: true),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(_missionName(chosen, english),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800))),
                      const Icon(Icons.play_arrow_rounded,
                          color: Color(0xff477e65)),
                    ])))));
  }

  Widget _discoveryCard(DiscoveryActivity activity) => Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
          key: ValueKey(activity.scenario.id),
          onTap: () => open(activity.scenario),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
              padding: const EdgeInsets.all(17),
              child: Row(children: [
                Icon(activity.icon, color: activity.color, size: 34),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(english ? activity.english : activity.oromo,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17)),
                      const SizedBox(height: 5),
                      Text(
                          activity.scenario.sourceGrade == null
                              ? (english ? 'First words' : 'Bu’uura')
                              : 'Kutaa ${activity.scenario.sourceGrade} • ${activity.scenario.sourcePage}',
                          style: const TextStyle(
                              color: Color(0xff71877e), fontSize: 12)),
                    ])),
                Icon(
                    progress.entry(activity.scenario.id).independent
                        ? Icons.stars_rounded
                        : Icons.arrow_forward_rounded,
                    color: activity.color),
              ]))));

  Widget _topicCard(GameKind kind) {
    final topic = topics[kind]!;
    final choices = widget.catalogue.where((s) => s.kind == kind).toList();
    final done = choices.where((s) => progress.entry(s.id).independent).length;
    final chosen = choices.firstWhere((s) => !progress.entry(s.id).independent,
        orElse: () => choices.first);
    return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
            key: ValueKey('topic-${kind.name}'),
            onTap: () => open(chosen),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              color: topic.color.withOpacity(.12),
                              borderRadius: BorderRadius.circular(14)),
                          child:
                              Icon(topic.icon, color: topic.color, size: 27)),
                      const SizedBox(height: 16),
                      Text(english ? topic.english : topic.oromo,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                          value: done / choices.length,
                          minHeight: 4,
                          color: topic.color,
                          backgroundColor: const Color(0xffeef1ec)),
                      const SizedBox(height: 8),
                      Text('$done / ${choices.length}',
                          style: const TextStyle(
                              color: Color(0xff71877e), fontSize: 12)),
                    ]))));
  }
}

bool _isTangible(LearningScenario s) {
  if (discoveryFor(s.id) != null) return false;
  final v = s.values;
  switch (s.kind) {
    case GameKind.numberLine:
      return v['start']! >= 0 &&
          v['delta']! > 0 &&
          v['start']! + v['delta']! <= 12;
    case GameKind.equalGroups:
      return v['groups']! <= 4 && v['each']! <= 5;
    case GameKind.sharing:
      return v['people']! <= 4 &&
          v['total']! <= 20 &&
          v['total']! ~/ v['people']! <= 5;
    default:
      return false;
  }
}

String _missionName(LearningScenario s, bool english) {
  if (!_isTangible(s)) {
    return english ? topics[s.kind]!.english : topics[s.kind]!.oromo;
  }
  switch (s.kind) {
    case GameKind.numberLine:
      return english ? 'Fill the banana order' : 'Ajaja muuzii guuti';
    case GameKind.equalGroups:
      return english ? 'Pack matching baskets' : 'Garee walqixa guuti';
    case GameKind.sharing:
      return english ? 'Share the picnic' : 'Nyaata walqixa hirii';
    default:
      return english ? topics[s.kind]!.english : topics[s.kind]!.oromo;
  }
}

Widget _storageWarning() => const Padding(
    key: ValueKey('storage-warning'),
    padding: EdgeInsets.all(12),
    child: Row(children: [
      Icon(Icons.warning_amber_rounded, color: Colors.orange),
      SizedBox(width: 8),
      Flexible(child: Text('💾 ⚠  Progress is not saved on this device.'))
    ]));

class _LessonScreen extends StatefulWidget {
  const _LessonScreen(
      {required this.scenario,
      required this.progress,
      required this.onSave,
      required this.english,
      required this.storageError,
      required this.basics,
      required this.onOpenBasics,
      required this.returningToActivity,
      required this.cooperative,
      required this.initialTurn,
      required this.onTurnChanged,
      required this.onNext});
  final LearningScenario scenario;
  final ProgressState progress;
  final Future<bool> Function() onSave;
  final bool english, storageError;
  final bool returningToActivity;
  final List<LearningScenario> basics;
  final ValueChanged<LearningScenario> onOpenBasics;
  final bool cooperative;
  final int initialTurn;
  final ValueChanged<int> onTurnChanged;
  final VoidCallback onNext;
  @override
  State<_LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<_LessonScreen> {
  late LearningScenario scenario;
  int phase = 0;
  bool correct = false,
      constructionHelp = false,
      transferHelp = false,
      wrong = false;
  bool busy = false;
  late bool english, storageError;
  String? direction;
  late int teamTurn;
  final guideAnchor = GlobalKey();
  final boardAnchor = GlobalKey();
  final input = TextEditingController();
  @override
  void initState() {
    super.initState();
    scenario = widget.scenario;
    english = widget.english;
    storageError = widget.storageError;
    teamTurn = widget.initialTurn;
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  void result(bool value) {
    if (mounted && correct != value) setState(() => correct = value);
  }

  void passTurn() {
    if (!widget.cooperative) return;
    setState(() => teamTurn = 1 - teamTurn);
    widget.onTurnChanged(teamTurn);
  }

  void _showSteps(List<LessonInstruction> steps, {bool solution = false}) {
    if (solution) help();
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      key: ValueKey(solution
                          ? 'worked-solution'
                          : 'optional-instructions'),
                      child: LessonGuide(
                          steps: steps,
                          english: english,
                          title: solution
                              ? (english ? 'Solution' : 'Furmaata')
                              : null,
                          color: topicFor(scenario).color)),
                  const SizedBox(height: 8),
                  TextButton(
                      key: ValueKey(
                          solution ? 'solution-close' : 'instructions-close'),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(english ? 'Back to play' : 'Deebi’i')),
                ]))));
  }

  void help() => setState(() {
        if (phase == 0) {
          constructionHelp = true;
        } else {
          transferHelp = true;
        }
      });
  Future<void> proceed({required int expectedPhase}) async {
    if (busy ||
        phase != expectedPhase ||
        phase > 1 ||
        phase == 0 && !correct ||
        widget.cooperative && expectedPhase == 1) {
      return;
    }
    if (phase == 0) {
      setState(() => busy = true);
      widget.progress.recordConstruction(scenario.id,
          assisted: constructionHelp || widget.cooperative);
      final saved = await widget.onSave();
      if (!mounted) return;
      storageError = storageError || !saved;
    }
    if (mounted) {
      setState(() {
        phase++;
        busy = false;
      });
    }
  }

  Future<void> check() async {
    if (busy || phase != 2) return;
    final answer = int.tryParse(input.text.trim());
    if (answer == null) {
      setState(() => wrong = true);
      return;
    }
    final requiredDirection = discoveryFor(scenario.id)?.transferDirection;
    final success = answer == scenario.transferAnswer &&
        (requiredDirection == null || direction == requiredDirection);
    setState(() => busy = true);
    widget.progress.recordTransfer(scenario.id,
        correct: success, assisted: transferHelp || widget.cooperative);
    final saved = await widget.onSave();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    setState(() {
      storageError = storageError || !saved;
      busy = false;
      wrong = !success;
      if (success) phase = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topic = topicFor(scenario);
    final tangible = _isTangible(scenario);
    final List<LessonInstruction> instructions =
        discoveryFor(scenario.id) == null
            ? (tangible
                ? missionInstructions(scenario)
                : boardInstructions(scenario))
            : discoveryInstructions(scenario.id);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xfff6f5ef),
            title: Text(english ? topic.english : topic.oromo,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            actions: [
              IconButton(
                  tooltip: 'Afaan Oromoo / English',
                  onPressed: () => setState(() => english = !english),
                  icon: const Icon(Icons.translate_rounded))
            ]),
        bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  if (storageError) _storageWarning(),
                  Row(children: [
                    if (phase == 0) ...[
                      IconButton(
                          tooltip:
                              english ? 'Show the instructions' : 'Tartiiba',
                          onPressed: () {
                            if (tangible) {
                              _showSteps(instructions
                                  .take(instructions.length - 1)
                                  .toList());
                              return;
                            }
                            final target = guideAnchor.currentContext;
                            if (target != null) {
                              Scrollable.ensureVisible(target,
                                  duration: const Duration(milliseconds: 200));
                            }
                          },
                          icon: const Icon(Icons.menu_book_rounded)),
                      const SizedBox(width: 8),
                    ],
                    if (phase == 0 || phase == 2) ...[
                      IconButton(
                          key: const ValueKey('lesson-help'),
                          tooltip: english ? 'Show a clue' : 'Gargaarsa',
                          onPressed: busy ? null : help,
                          icon: const Icon(Icons.lightbulb_outline_rounded)),
                      const SizedBox(width: 12),
                    ],
                    Expanded(child: _primaryAction()),
                  ]),
                ]))),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(children: [
                                for (var i = 0; i < (phase < 2 ? 2 : 4); i++)
                                  Expanded(
                                      child: Container(
                                          height: 5,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          decoration: BoxDecoration(
                                              color: i <= phase
                                                  ? topic.color
                                                  : const Color(0xffe2e8df),
                                              borderRadius:
                                                  BorderRadius.circular(5))))
                              ]),
                              const SizedBox(height: 12),
                              if (widget.cooperative && phase == 0) ...[
                                _teamRibbon(),
                                const SizedBox(height: 10),
                              ],
                              Text(
                                  english
                                      ? [
                                          'YOUR GOAL',
                                          'WHAT YOU DISCOVERED',
                                          'TRY A NEW CHALLENGE',
                                          'WELL DONE'
                                        ][phase]
                                      : [
                                          'KAAYYOO',
                                          'HUBANNOO',
                                          'SHAKALI',
                                          'BAREEDA'
                                        ][phase],
                                  style: TextStyle(
                                      color: topic.color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5)),
                              const SizedBox(height: 10),
                              if (phase == 0) ...[
                                if (!tangible) ...[
                                  Text(goalMath(scenario),
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900)),
                                  if (english)
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(scenario.goal)),
                                  const SizedBox(height: 20),
                                  Container(
                                      key: guideAnchor,
                                      child: LessonGuide(
                                          key: ValueKey('guide-${scenario.id}'),
                                          steps: instructions
                                              .take(instructions.isNotEmpty
                                                  ? instructions.length - 1
                                                  : 0)
                                              .toList(),
                                          english: english,
                                          color: topic.color)),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                          key: const ValueKey('guide-play'),
                                          onPressed: () {
                                            final target =
                                                boardAnchor.currentContext;
                                            if (target != null) {
                                              Scrollable.ensureVisible(target,
                                                  alignment: .05,
                                                  duration: const Duration(
                                                      milliseconds: 200));
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.arrow_downward_rounded),
                                          label: Text(english
                                              ? 'Try this step'
                                              : 'Taphadhu'))),
                                ],
                                if (widget.basics.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                      english
                                          ? 'Practise a simpler idea first'
                                          : 'Bu’uura shaakali',
                                      style: TextStyle(
                                          color: topic.color,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  for (final basic in widget.basics)
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: OutlinedButton.icon(
                                            key: ValueKey(
                                                'basics-${basic.kind.name}'),
                                            onPressed: () =>
                                                widget.onOpenBasics(basic),
                                            icon: const Icon(
                                                Icons.school_outlined),
                                            label: Text(english
                                                ? topics[basic.kind]!.english
                                                : topics[basic.kind]!.oromo))),
                                ],
                                const SizedBox(height: 12),
                                Container(
                                    key: boardAnchor,
                                    child: _panel(_board(), topic.color)),
                                const SizedBox(height: 16),
                                Icon(
                                    correct
                                        ? Icons.check_circle_rounded
                                        : Icons.touch_app_rounded,
                                    color: correct
                                        ? const Color(0xff418b61)
                                        : const Color(0xff9daca7),
                                    size: 30),
                              ],
                              if (phase == 1) ...[
                                const SizedBox(height: 10),
                                _panel(
                                    Column(
                                        key: const ValueKey('definition-card'),
                                        children: [
                                          Icon(topic.icon,
                                              color: topic.color, size: 58),
                                          const SizedBox(height: 20),
                                          if (instructions.isNotEmpty) ...[
                                            Text(
                                                english
                                                    ? instructions.last.english
                                                    : instructions.last.oromo,
                                                key: const ValueKey(
                                                    'plain-language-definition'),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 19, height: 1.5)),
                                            const SizedBox(height: 16),
                                          ],
                                          Text(definitionMath(scenario),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  height: 1.6,
                                                  fontWeight: FontWeight.w900)),
                                          if (english)
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Text(
                                                    scenario.explanation,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        height: 1.5))),
                                        ]),
                                    topic.color),
                                const SizedBox(height: 18),
                                if (!tangible || english) _englishWord(topic),
                                if (!widget.cooperative) ...[
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                      key: const ValueKey('lesson-continue'),
                                      onPressed: busy
                                          ? null
                                          : () => proceed(expectedPhase: 1),
                                      icon: const Icon(Icons.extension_rounded),
                                      label: Text(english
                                          ? 'Try a new number'
                                          : 'Lakkoofsa haaraa yaali')),
                                ],
                              ],
                              if (phase == 2) ...[
                                const SizedBox(height: 12),
                                _panel(
                                    Column(children: [
                                      const Icon(Icons.extension_rounded,
                                          color: Color(0xffd19445), size: 48),
                                      const SizedBox(height: 18),
                                      Text(transferMath(scenario),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 26,
                                              height: 1.5,
                                              fontWeight: FontWeight.w900)),
                                      if (english)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child:
                                                Text(scenario.transferPrompt)),
                                      const SizedBox(height: 22),
                                      if (discoveryFor(scenario.id)
                                              ?.transferDirection !=
                                          null)
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16),
                                            child: Row(children: [
                                              for (final sign in ['<', '>'])
                                                Expanded(
                                                    child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: OutlinedButton(
                                                      key: ValueKey(sign == '<'
                                                          ? 'transfer-direction-less'
                                                          : 'transfer-direction-greater'),
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor:
                                                              direction == sign
                                                                  ? topic.color
                                                                      .withOpacity(
                                                                          .16)
                                                                  : null),
                                                      onPressed: busy
                                                          ? null
                                                          : () => setState(() {
                                                                direction =
                                                                    sign;
                                                                wrong = false;
                                                              }),
                                                      child: Text(sign,
                                                          style: const TextStyle(
                                                              fontSize: 32,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900))),
                                                )),
                                            ])),
                                      TextField(
                                          key: const ValueKey('transfer-input'),
                                          controller: input,
                                          enabled: !busy,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(signed: true),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w800),
                                          decoration: InputDecoration(
                                              hintText: '?',
                                              errorText: wrong
                                                  ? (english
                                                      ? 'Try another way. You can do it.'
                                                      : 'Irra deebi’ii yaali.')
                                                  : null),
                                          onSubmitted: (_) => check()),
                                      if (transferHelp)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Text(
                                                '${discoveryFor(scenario.id)?.transferDirection ?? '='} ${scenario.transferAnswer}',
                                                style: const TextStyle(
                                                    fontSize: 26,
                                                    color: Color(0xff4c8c72)))),
                                      const SizedBox(height: 8),
                                      TextButton.icon(
                                          key: const ValueKey('solution-open'),
                                          onPressed: busy
                                              ? null
                                              : () => _showSteps(
                                                  workedSolution(scenario),
                                                  solution: true),
                                          icon: const Icon(Icons
                                              .play_circle_outline_rounded),
                                          label: Text(english
                                              ? 'Show the solution'
                                              : 'Furmaata')),
                                    ]),
                                    topic.color),
                              ],
                              if (phase == 3) ...[
                                const SizedBox(height: 20),
                                _panel(
                                    Column(
                                        key: const ValueKey('completion-card'),
                                        children: [
                                          Icon(
                                              transferHelp
                                                  ? Icons.favorite_rounded
                                                  : Icons.stars_rounded,
                                              color: const Color(0xffdaa33e),
                                              size: 92),
                                          const SizedBox(height: 18),
                                          Text(
                                              english
                                                  ? (transferHelp
                                                      ? 'Good practice!'
                                                      : 'You solved it!')
                                                  : 'Bareeda!',
                                              style: const TextStyle(
                                                  fontSize: 31,
                                                  fontWeight: FontWeight.w900)),
                                          const SizedBox(height: 12),
                                          Text(
                                              transferMath(scenario)
                                                  .replaceAll(
                                                      '⋯', direction ?? '')
                                                  .replaceAll('?',
                                                      '${scenario.transferAnswer}'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 22, height: 1.5)),
                                          const SizedBox(height: 12),
                                          Text(transferHelp ? '↻' : '★',
                                              style: const TextStyle(
                                                  fontSize: 33,
                                                  color: Color(0xffbf903b))),
                                        ]),
                                    topic.color),
                              ],
                              const SizedBox(height: 24),
                              Text(
                                  scenario.sourceGrade == null
                                      ? (english
                                          ? 'Foundation skill'
                                          : 'Bu’uura')
                                      : 'Kutaa ${scenario.sourceGrade} • ${scenario.sourcePage}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xff87988e), fontSize: 12)),
                            ]))))));
  }

  Widget _primaryAction() {
    if (phase == 1) {
      return FilledButton.icon(
          key: ValueKey(widget.cooperative ? 'team-next' : 'mission-next'),
          onPressed: busy
              ? null
              : (widget.returningToActivity
                  ? () => Navigator.of(context).pop()
                  : widget.onNext),
          icon: Icon(widget.returningToActivity
              ? Icons.arrow_back_rounded
              : Icons.play_arrow_rounded),
          label: Text(widget.returningToActivity
              ? (english ? 'Back to this activity' : 'Deebi’i')
              : (english ? 'Next mission' : 'Tapha itti aanu')));
    }
    if (phase == 3) {
      return FilledButton.icon(
          key: const ValueKey('lesson-home'),
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(widget.returningToActivity
              ? Icons.arrow_back_rounded
              : Icons.home_rounded),
          label: Text(english
              ? (widget.returningToActivity
                  ? 'Back to this activity'
                  : 'Learning path')
              : 'Deebi’i'));
    }
    if (phase == 2) {
      return FilledButton.icon(
          key: const ValueKey('transfer-check'),
          onPressed: busy ? null : check,
          icon: const Icon(Icons.check_rounded),
          label: Text(english ? 'Check' : 'Mirkaneessi'));
    }
    return FilledButton.icon(
        key: const ValueKey('lesson-continue'),
        onPressed: !busy && correct ? () => proceed(expectedPhase: 0) : null,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(english
            ? (phase == 0 ? 'See the idea' : 'Try it yourself')
            : (phase == 0 ? 'Itti fufi' : 'Yaali')));
  }

  Widget _panel(Widget child, Color color) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: color.withOpacity(.12))),
      child: child);

  Widget _englishWord(TopicCopy topic) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xffe9edde),
          borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        const Icon(Icons.translate_rounded, color: Color(0xff6a8166)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('English',
              style: TextStyle(fontSize: 11, color: Color(0xff738370))),
          Text(topic.english,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(topic.oromo, style: const TextStyle(color: Color(0xff738370))),
        ]))
      ]));

  Widget _teamRibbon() => Container(
      key: const ValueKey('team-progress'),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xffe6ecdd),
          borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        for (var player = 0; player < 2; player++)
          Expanded(
              child: Container(
                  key: player == teamTurn
                      ? ValueKey('team-turn-${player + 1}')
                      : null,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: player == teamTurn ? Colors.white : null,
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(children: [
                    MissionPerson(
                        size: 34,
                        happy: player == teamTurn,
                        color: player == 0
                            ? const Color(0xff477e75)
                            : const Color(0xffba713e)),
                    Text('${english ? 'Friend' : 'Hiriyyaa'} ${player + 1}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ]))),
        IconButton(
            key: const ValueKey('team-pass-turn'),
            tooltip: english ? 'Pass the turn' : 'Wal jijjiiraa',
            onPressed: passTurn,
            icon: const Icon(Icons.swap_horiz_rounded)),
      ]));

  Widget _board() {
    final key = ValueKey(scenario.id);
    switch (scenario.id) {
      case 'discovery-fractionDivision':
        return FractionDivisionLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-signedProducts':
        return SignedProductsLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-ratio':
        return RatioLab(key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-pythagoras':
        return PythagorasLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-circleAngles':
        return CircleAnglesLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-inequality':
        return InequalityLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-squareRoot':
        return SquareRootLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-congruence':
        return CongruenceLab(
            key: key, onResult: result, showHint: constructionHelp);
      case 'discovery-englishNumbers':
        return EnglishNumbersLab(
            key: key, onResult: result, showHint: constructionHelp);
    }
    switch (scenario.kind) {
      case GameKind.numberLine:
        if (_isTangible(scenario)) {
          return MarketOrderBoard(
              key: key,
              scenario: scenario,
              onResult: result,
              showHint: constructionHelp,
              english: english,
              onHelpUsed: help,
              onAction: passTurn,
              demonstrateOnStart:
                  !widget.progress.entry(scenario.id).construction);
        }
        return NumberLineBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.equalGroups:
        if (_isTangible(scenario)) {
          return PackingMissionBoard(
              key: key,
              scenario: scenario,
              onResult: result,
              showHint: constructionHelp,
              english: english,
              onHelpUsed: help,
              onAction: passTurn,
              demonstrateOnStart:
                  !widget.progress.entry(scenario.id).construction);
        }
        return EqualGroupsBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.sharing:
        if (_isTangible(scenario)) {
          return PicnicSharingBoard(
              key: key,
              scenario: scenario,
              onResult: result,
              showHint: constructionHelp,
              english: english,
              onHelpUsed: help,
              onAction: passTurn,
              demonstrateOnStart:
                  !widget.progress.entry(scenario.id).construction);
        }
        return SharingBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.fractionTiles:
        return FractionTilesBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.balance:
        return BalanceBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.areaGrid:
        return AreaGridBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.angleBuilder:
        return AngleBuilderBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.similarity:
        return SimilarityBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.volume:
        return VolumeBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.probability:
        return ProbabilityBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.sets:
        return SetsBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
      case GameKind.data:
        return DataBoard(
            key: key,
            scenario: scenario,
            onResult: result,
            showHint: constructionHelp);
    }
  }
}
