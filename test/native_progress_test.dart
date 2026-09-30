import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/progress_backend_native.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('herrega/progress');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('native read returns an absent app-private record as null', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });

    final backend = NativeProgressBackend();
    expect(await backend.read(), isNull);
    expect(calls.single.method, 'read');
    expect(calls.single.arguments, isNull);
  });

  test('native platform boundary saves and loads encoded learner progress',
      () async {
    String? stored;
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      switch (call.method) {
        case 'read':
          return stored;
        case 'write':
          expect(call.arguments, isA<String>());
          stored = call.arguments as String;
          return null;
        default:
          throw MissingPluginException();
      }
    });

    final store = ProgressStore(backend: NativeProgressBackend());
    final original = ProgressState()
      ..recordConstruction('numberLine-001', assisted: false)
      ..recordTransfer('numberLine-001', correct: true, assisted: false)
      ..recordConstruction('sharing-010', assisted: true);
    await store.save(original);
    final restored = await store.load();

    expect(calls, ['write', 'read']);
    expect(stored, original.encode());
    expect(restored.masteredCount, 1);
    expect(restored.practiceCount, 2);
    expect(restored.entry('numberLine-001').attempts, 1);
    expect(restored.entry('sharing-010').assisted, isTrue);
    expect(restored.entry('sharing-010').independent, isFalse);
  });

  test('native write waits for platform persistence acknowledgement', () async {
    final acknowledgement = Completer<Object?>();
    messenger.setMockMethodCallHandler(channel, (call) {
      expect(call.method, 'write');
      expect(call.arguments, '{"version":1,"entries":{}}');
      return acknowledgement.future;
    });

    var completed = false;
    final write = NativeProgressBackend().write('{"version":1,"entries":{}}')
      ..then((_) {
        completed = true;
      });
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);
    acknowledgement.complete(null);
    await write;
    expect(completed, isTrue);
  });

  test('native write surfaces a failed platform commit', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(
          code: 'WRITE_FAILED', message: 'Progress could not be saved.');
    });

    await expectLater(
        NativeProgressBackend().write('record'),
        throwsA(
          isA<PlatformException>()
              .having((error) => error.code, 'code', 'WRITE_FAILED'),
        ));
  });
}
