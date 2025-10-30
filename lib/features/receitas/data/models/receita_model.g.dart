// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receita_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceitaModelAdapter extends TypeAdapter<ReceitaModel> {
  @override
  final int typeId = 0;

  @override
  ReceitaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceitaModel(
      id: fields[0] as String,
      titulo: fields[1] as String,
      ingredientes: fields[2] as String,
      modoPreparo: fields[3] as String,
      tempoPreparo: fields[5] as String,
      caminhoImagem: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReceitaModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.ingredientes)
      ..writeByte(3)
      ..write(obj.modoPreparo)
      ..writeByte(4)
      ..write(obj.caminhoImagem)
      ..writeByte(5)
      ..write(obj.tempoPreparo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceitaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
