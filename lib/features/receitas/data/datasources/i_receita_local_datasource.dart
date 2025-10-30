import '../models/receita_model.dart';

abstract class IReceitaLocalDataSource {
  Stream<List<ReceitaModel>> getTodas();

  Future<void> salvar(ReceitaModel model);

  Future<void> deletar(String id);
}
