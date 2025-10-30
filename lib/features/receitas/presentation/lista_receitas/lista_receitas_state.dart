import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:equatable/equatable.dart';


// Enumeração para os diferentes status da UI
enum ListaStatus { inicial, carregando, sucesso, erro }

/// Representa o estado imutável da tela [ListaReceitasView].
class ListaReceitasState extends Equatable {
  final ListaStatus status;
  final List<Receita> receitas;
  final String? mensagemErro;

  const ListaReceitasState({
    this.status = ListaStatus.inicial,
    this.receitas = const [],
    this.mensagemErro,
  });

  /// Cria uma cópia do estado atual com os novos valores fornecidos.
  ListaReceitasState copyWith({
    ListaStatus? status,
    List<Receita>? receitas,
    String? mensagemErro,
  }) {
    return ListaReceitasState(
      status: status ?? this.status,
      receitas: receitas ?? this.receitas,
      mensagemErro: mensagemErro ?? this.mensagemErro,
    );
  }

  @override
  List<Object?> get props => [status, receitas, mensagemErro];
}