import 'package:app_receitas/features/receitas/data/datasources/gemini_datasource.dart';
import 'package:app_receitas/features/receitas/data/datasources/i_receita_llm_datasource.dart';
import 'package:app_receitas/features/receitas/domain/usecases/gerar_receita_ia.dart';
import 'package:app_receitas/features/receitas/presentation/form_receita/form_receita_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../features/receitas/data/datasources/i_receita_local_datasource.dart';
import '../features/receitas/data/datasources/receita_local_datasource.dart';
import '../features/receitas/data/models/receita_model.dart';
import '../features/receitas/data/repositories/receita_repository_impl.dart';
import '../features/receitas/domain/repositories/i_receita_repository.dart';
import '../features/receitas/domain/usecases/deletar_receita.dart';
import '../features/receitas/domain/usecases/get_todas_receitas.dart';
import '../features/receitas/domain/usecases/salvar_receita.dart';
import '../features/receitas/presentation/lista_receitas/lista_receitas_viewmodel.dart';

// Instância global do GetIt
final getIt = GetIt.instance;

Future<void> setupDI() async {
  final receitaBox = await Hive.openBox<ReceitaModel>('receitas');
  getIt.registerSingleton<Box<ReceitaModel>>(receitaBox);

  getIt.registerLazySingleton<IReceitaLLMDatasource>(
    () => GeminiDatasource(),
  );

  getIt.registerLazySingleton<GetTodasReceitasUseCase>(
    () => GetTodasReceitasUseCase(getIt<IReceitaRepository>()),
  );
  getIt.registerLazySingleton<SalvarReceitaUseCase>(
    () => SalvarReceitaUseCase(getIt<IReceitaRepository>()),
  );
  getIt.registerLazySingleton<DeletarReceitaUseCase>(
    () => DeletarReceitaUseCase(getIt<IReceitaRepository>()),
  );
  getIt.registerLazySingleton<GerarReceitaIAUseCase>(
    () => GerarReceitaIAUseCase(getIt<IReceitaRepository>()),
  );

  getIt.registerLazySingleton<IReceitaRepository>(
    () => ReceitaRepositoryImpl(
      localDataSource: getIt<IReceitaLocalDataSource>(),
      llmDataSource: getIt<IReceitaLLMDatasource>(),
    ),
  );

  getIt.registerLazySingleton<IReceitaLocalDataSource>(
    () => ReceitaLocalDataSource(getIt<Box<ReceitaModel>>()),
  );

  getIt.registerFactory<ListaReceitasViewModel>(
    () => ListaReceitasViewModel(
      getTodasReceitas: getIt(),
      deletarReceita: getIt(),
    ),
  );

  getIt.registerFactory<FormReceitaViewModel>(
    () => FormReceitaViewModel(
      salvarReceitaUseCase: getIt(),
      gerarReceitaIAUseCase: getIt(),
      receitaInicial: null
    ),
  );
}
