import 'package:app_receitas/features/receitas/data/datasources/i_receita_llm_datasource.dart';

import '../../domain/entities/receita.dart';
import '../../domain/repositories/i_receita_repository.dart';
import '../datasources/i_receita_local_datasource.dart';
import '../models/receita_model.dart';

class ReceitaRepositoryImpl implements IReceitaRepository {
  final IReceitaLocalDataSource localDataSource;
  final IReceitaLLMDatasource llmDataSource;


  ReceitaRepositoryImpl({
    required this.localDataSource,
    required this.llmDataSource,
  });

  @override
  Stream<List<Receita>> getTodasReceitas() {
    final streamDeModels = localDataSource.getTodas();

    return streamDeModels.map((listaDeModels) {
      return listaDeModels.map((model) => model.toDomain()).toList();
    });
  }

  @override
  Future<void> salvarReceita(Receita receita) {
    final model = ReceitaModel.fromDomain(receita);

    return localDataSource.salvar(model);
  }

  @override
  Future<void> deletarReceita(String id) {
    return localDataSource.deletar(id);
  }
  
  @override
  Future<Receita?> gerarReceitaIA(String prompt, {String? caminhoImagem}) async {
    final map = await llmDataSource.gerarReceita(prompt, caminhoImagem: caminhoImagem);
    
    if (map == null) return null;

    
    return Receita(
      id: '', 
      titulo: map['titulo'] ?? 'Sem título',
      tempoPreparo: map['tempoPreparo'] ?? '',      
      ingredientes: (map['ingredientes'] as List?)?.join('\n') ?? '',
      modoPreparo: (map['modoPreparo'] as List?)?.join('\n\n') ?? '',
      caminhoImagem: null,
    );
  }
}
