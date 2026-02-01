
abstract class IReceitaLLMDatasource {
  Future<Map<String, dynamic>?> gerarReceita(String comando, {List<String>? filtros, String? caminhoImagem});

}