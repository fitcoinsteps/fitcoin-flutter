import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app_widget.dart';
import 'core/config/flavor.dart';
import 'core/config/app_config.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromFlavor(flavor);

  // Initialize Logger
  final logger = Logger(
    level: config.debugMode ? Level.debug : Level.info,
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
  await Hive.openBox('bookings_cache');
  await Hive.openBox('cache_box');
  logger.i('✅ Hive initialized');

  // ✅ FIX: Don't force const if AppWidget doesn't have a const constructor
  final appWidget = AppWidget();

  // Initialize Sentry (only in production/staging)
  if (config.sentryDsn.isNotEmpty) {
    logger.i('🔧 Initializing Sentry...');
    await SentryFlutter.init(
          (options) {
        options.dsn = config.sentryDsn;
        options.environment = flavor.stringValue;
        options.tracesSampleRate = flavor == Flavor.production ? 0.1 : 0.0;
        options.debug = config.debugMode;
      },
      appRunner: () => runApp(
        ProviderScope(
          child: appWidget,
        ),
      ),
    );
  } else {
    // Run without Sentry
    runApp(
      ProviderScope(
        child: appWidget,
      ),
    );
  }
}