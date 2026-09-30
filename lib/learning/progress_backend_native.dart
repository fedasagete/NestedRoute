import 'package:flutter/services.dart';
import 'progress.dart';

ProgressBackend createBackend() => NativeProgressBackend();

class NativeProgressBackend implements ProgressBackend {
  static const channel = MethodChannel('herrega/progress');
  @override
  Future<String?> read() => channel.invokeMethod<String>('read');
  @override
  Future<void> write(String data) => channel.invokeMethod<void>('write', data);
}
