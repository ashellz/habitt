// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_data.dart';

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
      notifications: fields[12] == null ? [] : fields[12] as List,
      notes: fields[13] == null ? "" : fields[13] as String,
      longestStreak: fields[14] == null ? fields[4] as int : fields[14] as int,
      id: fields[15] == null ? 12345 : fields[15] as int,
      task: fields[16] == null ? false : fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HabitData obj) {
    writer
      ..writeByte(17)
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
      ..write(obj.tag)
      ..writeByte(12)
      ..write(obj.notifications)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.longestStreak)
      ..writeByte(15)
      ..write(obj.id)
      ..writeByte(16)
      ..write(obj.task);
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
