// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breach_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BreachResultAdapter extends TypeAdapter<BreachResult> {
  @override
  final int typeId = 4;

  @override
  BreachResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreachResult(
      found: fields[0] as bool,
      count: fields[1] as int,
      breaches: (fields[2] as List).cast<BreachItem>(),
      source: fields[3] as String,
      query: fields[4] as String,
      checkedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BreachResult obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.found)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.breaches)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.query)
      ..writeByte(5)
      ..write(obj.checkedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreachResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BreachItemAdapter extends TypeAdapter<BreachItem> {
  @override
  final int typeId = 5;

  @override
  BreachItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreachItem(
      site: fields[0] as String,
      date: fields[1] as String,
      accounts: fields[2] as String,
      types: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BreachItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.site)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.accounts)
      ..writeByte(3)
      ..write(obj.types);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreachItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BreachLogAdapter extends TypeAdapter<BreachLog> {
  @override
  final int typeId = 6;

  @override
  BreachLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreachLog(
      query: fields[0] as String,
      result: fields[1] as BreachResult,
      checkedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BreachLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.result)
      ..writeByte(2)
      ..write(obj.checkedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreachLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
