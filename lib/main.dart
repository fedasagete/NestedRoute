import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'learning/learning_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
        ['Roboto'], await rootBundle.loadString('assets/fonts/LICENSE.txt'));
  });
  runApp(const MyApp());
}

class MyApp extends HerregaApp {
  const MyApp({super.key});
}
