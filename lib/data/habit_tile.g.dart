// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_tile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitDataAdapter extends TypeAdapter<HabitData> {
  @override
  final int typeId = 1;

  @override
  HabitData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitData(
      name: fields[0] as String,
      completed: fields[1] as bool,
      icon: fields[2] as String,
      category: fields[3] as String,
      streak: fields[4] as int,
      amount: fields[5] as int,
      amountName: fields[6] as String,
      amountCompleted: fields[7] as int,
      duration: fields[8] as int,
      durationCompleted: fields[9] as int,
      skipped: fields[10] == null ? false : fields[10] as bool,
      tag: fields[11] == null ? "No tag" : fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HabitData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.streak)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.amountName)
      ..writeByte(7)
      ..write(obj.amountCompleted)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.durationCompleted)
      ..writeByte(10)
      ..write(obj.skipped)
      ..writeByte(11)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
