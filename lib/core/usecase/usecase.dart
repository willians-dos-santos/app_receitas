import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../failures/failures.dart';

/// Interface base para UseCases que retornam um [Future].
/// [Type] é o tipo de retorno em caso de sucesso.
/// [Params] é o tipo dos parâmetros de entrada.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Classe para UseCases que não precisam de parâmetros.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}