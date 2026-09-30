// Selected only by the dart.library.html conditional import in progress.dart.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'progress.dart';

ProgressBackend createBackend() => WebProgressBackend();

class WebProgressBackend implements ProgressBackend {
  static const key = 'herrega.progress.v1';
  @override
  Future<String?> read() async => html.window.localStorage[key];
  @override
  Future<void> write(String data) async {
    html.window.localStorage[key] = data;
  }
}
