import 'package:equatable/equatable.dart';

class Receita extends Equatable {
  final String id;
  final String titulo;
  final String ingredientes;
  final String modoPreparo;
  final String tempoPreparo;
  final String? caminhoImagem;

  const Receita({
    required this.id,
    required this.titulo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.tempoPreparo,
    this.caminhoImagem,
  });

  Receita copyWith({
    String? id,
    String? titulo,
    String? ingredientes,
    String? modoPreparo,
    String? tempoPreparo,
    String? caminhoImagem,
  }) {
    return Receita(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      ingredientes: ingredientes ?? this.ingredientes,
      modoPreparo: modoPreparo ?? this.modoPreparo,
      tempoPreparo: tempoPreparo ?? this.tempoPreparo,
      caminhoImagem: caminhoImagem ?? this.caminhoImagem,
    );
  }

  @override
  List<Object?> get props => [
    id,
    titulo,
    ingredientes,
    modoPreparo,
    tempoPreparo,
    caminhoImagem,
  ];
}
