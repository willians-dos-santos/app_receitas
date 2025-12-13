
abstract class IReceitaLLMDatasource {
  Future<Map<String, dynamic>?> gerarReceita(String comando, {String? caminhoImagem});

}