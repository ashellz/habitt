// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagDataAdapter extends TypeAdapter<TagData> {
  @override
  final int typeId = 2;

  @override
  TagData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TagData(
      tag: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TagData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
