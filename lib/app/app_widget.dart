import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di_setup.dart';

import '../features/receitas/presentation/lista_receitas/lista_receitas_viewmodel.dart';
import '../features/receitas/presentation/lista_receitas/lista_receitas_view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<ListaReceitasViewModel>(
      create: (_) => getIt<ListaReceitasViewModel>(),

      dispose: (_, viewModel) => viewModel.dispose(),

      child: MaterialApp(
        title: 'App de Receitas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            elevation: 1,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          cardTheme: CardThemeData(
            elevation: 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple[600],
          ),
        ),
        home: const ListaReceitasView(),
      ),
    );
  }
}
