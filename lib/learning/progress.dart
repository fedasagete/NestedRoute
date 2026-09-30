import 'dart:convert';

import 'progress_backend_native.dart'
    if (dart.library.html) 'progress_backend_web.dart' as platform;

abstract class ProgressBackend {
  Future<String?> read();
  Future<void> write(String data);
}

class ScenarioProgress {
  const ScenarioProgress(
      {this.construction = false,
      this.independent = false,
      this.assisted = false,
      this.attempts = 0});
  final bool construction;
  final bool independent;
  final bool assisted;
  final int attempts;

  Map<String, Object> toJson() => {
        'construction': construction,
        'independent': independent,
        'assisted': assisted,
        'attempts': attempts
      };
}

class ProgressState {
  final Map<String, ScenarioProgress> _entries = {};
  int get practiceCount => _entries.values.where((e) => e.construction).length;
  int get masteredCount => _entries.values.where((e) => e.independent).length;
  int get stars => masteredCount;
  ScenarioProgress entry(String id) => _entries[id] ?? const ScenarioProgress();
  Iterable<String> get masteredIds =>
      _entries.keys.where((id) => entry(id).independent);

  void recordConstruction(String id, {required bool assisted}) {
    final old = entry(id);
    _entries[id] = ScenarioProgress(
        construction: true,
        independent: old.independent,
        assisted: old.assisted || assisted,
        attempts: old.attempts);
  }

  void recordTransfer(String id,
      {required bool correct, required bool assisted}) {
    final old = entry(id);
    _entries[id] = ScenarioProgress(
        construction: old.construction,
        independent: old.independent || (correct && !assisted),
        assisted: old.assisted || assisted,
        attempts: old.attempts + 1);
  }

  String encode() => jsonEncode({
        'version': 1,
        'entries': _entries.map((key, value) => MapEntry(key, value.toJson()))
      });

  static ProgressState decode(String raw) {
    final state = ProgressState();
    try {
      final json = jsonDecode(raw);
      if (json is! Map || json['version'] != 1 || json['entries'] is! Map) {
        return state;
      }
      for (final item in (json['entries'] as Map).entries) {
        final value = item.value;
        if (item.key is! String ||
            (item.key as String).isEmpty ||
            value is! Map) continue;
        final attempts = value['attempts'];
        if (attempts is! int ||
            attempts < 0 ||
            value['construction'] is! bool ||
            value['independent'] is! bool ||
            value['assisted'] is! bool) continue;
        state._entries[item.key as String] = ScenarioProgress(
            construction: value['construction'] as bool,
            independent: value['independent'] as bool,
            assisted: value['assisted'] as bool,
            attempts: attempts);
      }
    } on FormatException {
      // A truncated record cannot make the learner unable to open the app.
    }
    return state;
  }
}

class ProgressStore {
  ProgressStore({ProgressBackend? backend})
      : backend = backend ?? platform.createBackend();
  final ProgressBackend backend;
  Future<void> _queue = Future<void>.value();

  Future<ProgressState> load() async {
    final raw = await backend.read();
    return raw == null ? ProgressState() : ProgressState.decode(raw);
  }

  Future<void> save(ProgressState state) {
    // Capture the value at call time, then preserve write ordering.
    final snapshot = state.encode();
    final write = _queue.then((_) => backend.write(snapshot));
    _queue = write.catchError((Object _) {});
    return write;
  }
}

class MemoryProgressBackend implements ProgressBackend {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    value = data;
  }
}
