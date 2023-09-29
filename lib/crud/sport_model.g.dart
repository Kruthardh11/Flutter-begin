// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SportModelAdapter extends TypeAdapter<SportModel> {
  @override
  final int typeId = 0;

  @override
  SportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SportModel(
      name: fields[0] as String,
      player: fields[1] as String,
      team: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SportModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.player)
      ..writeByte(2)
      ..write(obj.team);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
