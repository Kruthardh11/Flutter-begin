// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormModelAdapter extends TypeAdapter<FormModel> {
  @override
  final int typeId = 0;

  @override
  FormModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormModel(
      name: fields[0] as String,
      age: fields[3] as String,
      city: fields[2] as String,
      email: fields[1] as String,
      gender: fields[5] as String,
      favSport: (fields[6] as List).cast<dynamic>(),
      password: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FormModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.favSport);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
