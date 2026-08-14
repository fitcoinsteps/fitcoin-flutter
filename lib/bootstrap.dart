import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor.dart';
import 'core/cache/cache_service.dart';
import 'app_widget.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(flavor);

  await CacheService.init();

  runApp(const ProviderScope(child: AppWidget()));
}
