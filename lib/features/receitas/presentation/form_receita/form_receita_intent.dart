import 'dart:io';

import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:equatable/equatable.dart';

enum FonteImagem { camera, galeria }

abstract class FormReceitaIntent extends Equatable {
  const FormReceitaIntent();
  @override
  List<Object?> get props => [];
}

class ImagemSelecionadaIntent extends FormReceitaIntent {
  final File? imagem;
  const ImagemSelecionadaIntent(this.imagem);

  @override
  List<Object?> get props => [imagem];
}

class SalvarReceitaIntent extends FormReceitaIntent {
  final Receita receita;
  const SalvarReceitaIntent(this.receita);

  @override
  List<Object?> get props => [receita];
}
