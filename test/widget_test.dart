import 'package:app_receitas/app/app_widget.dart';
import 'package:app_receitas/app/di_setup.dart';
import 'package:app_receitas/features/receitas/data/models/receita_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() {
  group('App Widget Smoke Test', () {
    setUpAll(() async {
      final testPath = '${Directory.current.path}/test/hive_test_storage';

      final dir = Directory(testPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
      await dir.create(recursive: true);

      Hive.init(testPath);

      Hive.registerAdapter(ReceitaModelAdapter());

      await setupDI();
    });

    tearDownAll(() async {
      await getIt.reset();

      await Hive.close();

      await Hive.deleteFromDisk();
    });

    testWidgets('Renderiza ListaReceitasView e encontra o título', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const AppWidget());

      await tester.pumpAndSettle();

      expect(find.text('Minhas Receitas'), findsOneWidget);

      expect(find.byIcon(Icons.add), findsOneWidget);

      expect(find.text('Nenhuma receita cadastrada ainda.\nToque no "+" para adicionar a primeira!'), findsOneWidget);
    });
  });
}
