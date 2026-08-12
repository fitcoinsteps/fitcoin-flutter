import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app_widget.dart';
import 'core/config/flavor.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = Logger(
    level: Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  logger.i('🚀 Starting Fitcoin in ${flavor.stringValue.toUpperCase()} mode');

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('user_data');
  logger.i('✅ Hive initialized');

  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}