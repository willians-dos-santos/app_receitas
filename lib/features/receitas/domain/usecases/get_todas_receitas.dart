import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:app_receitas/features/receitas/domain/repositories/i_receita_repository.dart';

class GetTodasReceitasUseCase {
  final IReceitaRepository repository;
  GetTodasReceitasUseCase(this.repository);

  Stream<List<Receita>> call() => repository.getTodasReceitas();
}
