import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/i_receita_repository.dart';

/// Caso de uso para deletar uma [Receita] usando seu ID.
class DeletarReceitaUseCase implements UseCase<void, DeletarReceitaParams> {
  final IReceitaRepository repository;

  DeletarReceitaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletarReceitaParams params) async {
    try {
      await repository.deletarReceita(params.id);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(mensagem: 'Falha ao deletar a receita.'));
    }
  }
}

/// Parâmetros necessários para deletar uma receita.
class DeletarReceitaParams extends Equatable {
  final String id;

  const DeletarReceitaParams({required this.id});

  @override
  List<Object> get props => [id];
}