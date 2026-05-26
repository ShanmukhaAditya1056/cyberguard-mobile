// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WifiResultAdapter extends TypeAdapter<WifiResult> {
  @override
  final int typeId = 9;

  @override
  WifiResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WifiResult(
      ssid: fields[0] as String,
      encryption: fields[1] as String,
      isPublic: fields[2] as bool,
      score: fields[3] as int,
      label: fields[4] as String,
      checks: (fields[5] as List).cast<WifiCheck>(),
      scannedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WifiResult obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.ssid)
      ..writeByte(1)
      ..write(obj.encryption)
      ..writeByte(2)
      ..write(obj.isPublic)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.label)
      ..writeByte(5)
      ..write(obj.checks)
      ..writeByte(6)
      ..write(obj.scannedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WifiResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WifiCheckAdapter extends TypeAdapter<WifiCheck> {
  @override
  final int typeId = 10;

  @override
  WifiCheck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WifiCheck(
      label: fields[0] as String,
      status: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WifiCheck obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WifiCheckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
