import 'package:equatable/equatable.dart';

/// Classe base abstrata para Falhas.
abstract class Failure extends Equatable {
  final String mensagem;

  const Failure(this.mensagem);

  @override
  List<Object> get props => [mensagem];
}

/// Falha geral para erros de banco de dados local (Cache).
class CacheFailure extends Failure {
  const CacheFailure({String mensagem = 'Erro ao acessar dados locais.'})
      : super(mensagem);
}

/// Falha para erros inesperados.
class UnknownFailure extends Failure {
  const UnknownFailure({String mensagem = 'Ocorreu um erro inesperado.'})
      : super(mensagem);
}

class ServerFailure extends Failure {
  const ServerFailure({String mensagem = 'Erro de comunicação com o servidor.'})
      : super(mensagem);
}

class NonFoodFailure extends Failure {
  const NonFoodFailure({String mensagem = 'Isto não parece ser comestível! 🧐'})
      : super(mensagem);
}