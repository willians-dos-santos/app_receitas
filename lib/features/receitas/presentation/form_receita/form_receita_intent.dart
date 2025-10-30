import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class FormReceitaIntent extends Equatable {
  const FormReceitaIntent();
  @override
  List<Object?> get props => [];
}

class SelecionarImagemIntent extends FormReceitaIntent {
  final ImageSource source;
  const SelecionarImagemIntent(this.source);

  @override
  List<Object> get props => [source];
}

class SalvarReceitaIntent extends FormReceitaIntent {
  final Receita receita;
  const SalvarReceitaIntent(this.receita);

  @override
  List<Object?> get props => [receita];
}
