import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/receita.dart';
import '../repositories/i_receita_repository.dart';

class SalvarReceitaUseCase implements UseCase<void, SalvarReceitaParams> {
  final IReceitaRepository repository;

  SalvarReceitaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SalvarReceitaParams params) async {
    try {
      await repository.salvarReceita(params.receita);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(mensagem: 'Falha ao salvar a receita.'));
    }
  }
}

class SalvarReceitaParams extends Equatable {
  final Receita receita;

  const SalvarReceitaParams({required this.receita});

  @override
  List<Object> get props => [receita];
}
