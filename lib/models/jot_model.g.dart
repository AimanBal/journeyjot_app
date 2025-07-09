// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JotModelAdapter extends TypeAdapter<JotModel> {
  @override
  final int typeId = 0;

  @override
  JotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JotModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      imagePath: fields[3] as String,
      dateTime: fields[4] as DateTime,
      userEmail: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JotModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.userEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
