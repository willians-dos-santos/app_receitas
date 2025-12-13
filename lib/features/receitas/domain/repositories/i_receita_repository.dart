import 'package:app_receitas/features/receitas/domain/entities/receita.dart';

abstract class IReceitaRepository {
  Stream<List<Receita>> getTodasReceitas();
  Future<void> salvarReceita(Receita receita);
  Future<void> deletarReceita(String id);
  Future<Receita?> gerarReceitaIA(String prompt, {String? caminhoImagem});
}


