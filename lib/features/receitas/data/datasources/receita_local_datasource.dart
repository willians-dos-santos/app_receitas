import 'package:app_receitas/features/receitas/data/datasources/i_receita_local_datasource.dart';
import 'package:app_receitas/features/receitas/data/models/receita_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReceitaLocalDataSource implements IReceitaLocalDataSource {
  final Box<ReceitaModel> box;
  ReceitaLocalDataSource(this.box);

  Stream<List<ReceitaModel>> getTodas() async* {
    // yield inicial
    yield box.values.toList();
    // yield para cada mudança na box
    yield* box.watch().map((event) => box.values.toList());
  }

  Future<void> salvar(ReceitaModel model) => box.put(model.id, model);
  Future<void> deletar(String id) => box.delete(id);
}
