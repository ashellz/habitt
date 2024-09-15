// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historical_habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoricalHabitAdapter extends TypeAdapter<HistoricalHabit> {
  @override
  final int typeId = 3;

  @override
  HistoricalHabit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoricalHabit(
      date: fields[0] as DateTime,
      data: (fields[1] as List).cast<HistoricalHabitData>(),
    );
  }

  @override
  void write(BinaryWriter writer, HistoricalHabit obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoricalHabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoricalHabitDataAdapter extends TypeAdapter<HistoricalHabitData> {
  @override
  final int typeId = 4;

  @override
  HistoricalHabitData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoricalHabitData(
      name: fields[0] as String,
      completed: fields[1] as bool,
      icon: fields[2] as String,
      category: fields[3] as String,
      amount: fields[4] as int,
      amountCompleted: fields[5] as int,
      amountName: fields[6] as String,
      duration: fields[7] as int,
      durationCompleted: fields[8] as int,
      skipped: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HistoricalHabitData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.amountCompleted)
      ..writeByte(6)
      ..write(obj.amountName)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.durationCompleted)
      ..writeByte(9)
      ..write(obj.skipped);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoricalHabitDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
