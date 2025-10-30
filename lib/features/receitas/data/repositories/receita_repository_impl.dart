import '../../domain/entities/receita.dart';
import '../../domain/repositories/i_receita_repository.dart';
import '../datasources/i_receita_local_datasource.dart';
import '../models/receita_model.dart';

class ReceitaRepositoryImpl implements IReceitaRepository {
  final IReceitaLocalDataSource localDataSource;

  ReceitaRepositoryImpl({required this.localDataSource});

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
}
