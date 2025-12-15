import 'package:app_receitas/app/exceptions.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/receita.dart';
import '../repositories/i_receita_repository.dart';

class GerarReceitaIAParams {
  final String prompt;
  final String? caminhoImagem;
  GerarReceitaIAParams(this.prompt, {this.caminhoImagem});
}

class GerarReceitaIAUseCase implements UseCase<Receita?, GerarReceitaIAParams> {
  final IReceitaRepository repository;

  GerarReceitaIAUseCase(this.repository);

  @override
  Future<Either<Failure, Receita?>> call(GerarReceitaIAParams params) async {
    try {
      final receita = await repository.gerarReceitaIA(params.prompt, caminhoImagem: params.caminhoImagem);
      return Right(receita);
    }on NonFoodException {
      return const Left(NonFoodFailure()); 
    } 
    catch (e) {
      return Left(ServerFailure(mensagem: e.toString()));
    }
  }
}