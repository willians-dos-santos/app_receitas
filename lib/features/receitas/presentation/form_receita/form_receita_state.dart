import 'package:equatable/equatable.dart';
import 'dart:io';

enum FormStatus { ocioso, carregando, salvoComSucesso, sucesso, erro }

class FormReceitaState extends Equatable {
  final FormStatus status;
  final File? imagemSelecionada;
  final String? mensagemErro;

  const FormReceitaState({
    this.status = FormStatus.ocioso,
    this.imagemSelecionada,
    this.mensagemErro,
  });

  factory FormReceitaState.initial() {
    return const FormReceitaState();
  }

  FormReceitaState copyWith({
    FormStatus? status,
    File? imagemSelecionada,
    String? mensagemErro,
  }) {
    return FormReceitaState(
      status: status ?? this.status,

      imagemSelecionada: imagemSelecionada ?? this.imagemSelecionada,
      mensagemErro: mensagemErro ?? this.mensagemErro,
    );
  }

  @override
  List<Object?> get props => [status, imagemSelecionada, mensagemErro];
}
