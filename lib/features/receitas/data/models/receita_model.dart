import 'package:hive/hive.dart';
import '../../domain/entities/receita.dart';

part 'receita_model.g.dart'; 

/// Este é o Modelo de Dados, adaptado para o Hive.
/// Ele estende HiveObject para ter os métodos de persistência.
@HiveType(typeId: 0) 
class ReceitaModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final String ingredientes;

  @HiveField(3)
  final String modoPreparo;

  @HiveField(4)
  final String? caminhoImagem;

  @HiveField(5) 
  final String tempoPreparo;

  ReceitaModel({
    required this.id,
    required this.titulo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.tempoPreparo,
    this.caminhoImagem,
  });

  /// Converte este Modelo de Dados (Hive) para uma Entidade de Domínio.
  Receita toDomain() {
    return Receita(
      id: id,
      titulo: titulo,
      ingredientes: ingredientes,
      modoPreparo: modoPreparo,
      tempoPreparo: tempoPreparo,
      caminhoImagem: caminhoImagem,
    );
  }

  /// Converte uma Entidade de Domínio para este Modelo de Dados (Hive).
  factory ReceitaModel.fromDomain(Receita entity) {
    return ReceitaModel(
      id: entity.id,
      titulo: entity.titulo,
      ingredientes: entity.ingredientes,
      modoPreparo: entity.modoPreparo,
      tempoPreparo: entity.tempoPreparo,
      caminhoImagem: entity.caminhoImagem,
    );
  }
}

