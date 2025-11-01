import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app_widget.dart';
import 'app/di_setup.dart';
import 'features/receitas/data/models/receita_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ReceitaModelAdapter());

  await setupDI();

  await getIt.allReady();

  runApp(const AppWidget());
}
