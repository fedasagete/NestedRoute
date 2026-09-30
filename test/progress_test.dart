import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/progress.dart';

void main() {
  test('completed construction is practice, not independent mastery', () {
    final state = ProgressState();
    state.recordConstruction('numberLine-000', assisted: true);
    expect(state.practiceCount, 1);
    expect(state.masteredCount, 0);
    expect(state.entry('numberLine-000').assisted, isTrue);
  });

  test('independent transfer is rewarded once across replays', () {
    final state = ProgressState();
    state.recordTransfer('numberLine-000', correct: false, assisted: false);
    state.recordTransfer('numberLine-000', correct: true, assisted: false);
    state.recordTransfer('numberLine-000', correct: true, assisted: false);
    expect(state.masteredCount, 1);
    expect(state.stars, 1);
    expect(state.entry('numberLine-000').attempts, 3);
  });

  test('assisted correct answer does not count as independent mastery', () {
    final state = ProgressState();
    state.recordTransfer('fractions-001', correct: true, assisted: true);
    expect(state.masteredCount, 0);
    state.recordTransfer('fractions-001', correct: true, assisted: false);
    expect(state.masteredCount, 1);
  });

  test('round trip preserves practice, mastery and attempts', () {
    final state = ProgressState();
    state.recordConstruction('groups-001', assisted: false);
    state.recordTransfer('groups-001', correct: true, assisted: false);
    final restored = ProgressState.decode(state.encode());
    expect(restored.masteredCount, 1);
    expect(restored.practiceCount, 1);
    expect(restored.entry('groups-001').attempts, 1);
  });

  test('malformed or unsupported saved state recovers without crashing', () {
    for (final raw in [
      'oops',
      '[]',
      '{"version":99}',
      '{"version":1,"entries":{"a":{"attempts":-1},"b":42}}'
    ]) {
      final recovered = ProgressState.decode(raw);
      expect(recovered.masteredCount, 0);
      expect(recovered.stars, 0);
    }
  });

  test('queued saves keep newest progress even when earlier write is slow',
      () async {
    final backend = DelayedBackend();
    final store = ProgressStore(backend: backend);
    final state = ProgressState();
    final first = store.save(state);
    state.recordTransfer('a', correct: true, assisted: false);
    final second = store.save(state);
    await Future.wait([first, second]);
    expect(ProgressState.decode(backend.value!).masteredCount, 1);
    expect((await store.load()).masteredCount, 1);
  });

  test('save error surfaces but does not poison subsequent saves', () async {
    final backend = FailingOnceBackend();
    final store = ProgressStore(backend: backend);
    final state = ProgressState();
    await expectLater(store.save(state), throwsStateError);
    state.recordTransfer('a', correct: true, assisted: false);
    await store.save(state);
    expect((await store.load()).masteredCount, 1);
  });
}

class DelayedBackend implements ProgressBackend {
  String? value;
  int writes = 0;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    writes++;
    if (writes == 1) {
      await Future<void>.delayed(const Duration(milliseconds: 30));
    }
    value = data;
  }
}

class FailingOnceBackend implements ProgressBackend {
  String? value;
  bool fail = true;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    if (fail) {
      fail = false;
      throw StateError('storage full');
    }
    value = data;
  }
}
