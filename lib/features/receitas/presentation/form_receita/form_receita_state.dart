import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

enum FormStatus { ocioso, carregando, salvoComSucesso, sucesso, erro }

class FormReceitaState extends Equatable {
  final FormStatus status;
  final File? imagemSelecionada;
  final String? mensagemErro;
  final Receita? receitaGerada;

  const FormReceitaState({
    this.status = FormStatus.ocioso,
    this.imagemSelecionada,
    this.mensagemErro,
    this.receitaGerada,
  });

  factory FormReceitaState.initial() {
    return const FormReceitaState();
  }

  FormReceitaState copyWith({
    FormStatus? status,
    File? imagemSelecionada,
    String? mensagemErro,
    Receita? receitaGerada,
  }) {
    return FormReceitaState(
      status: status ?? this.status,

      imagemSelecionada: imagemSelecionada ?? this.imagemSelecionada,
      mensagemErro: mensagemErro ?? this.mensagemErro,
      receitaGerada: receitaGerada ?? this.receitaGerada,
    );
  }

  @override
  List<Object?> get props => [status, imagemSelecionada, mensagemErro, receitaGerada];
}
