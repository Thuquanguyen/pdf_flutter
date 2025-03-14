// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfFileModelAdapter extends TypeAdapter<PdfFileModel> {
  @override
  final int typeId = 0;

  @override
  PdfFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfFileModel(
      name: fields[0] as String?,
      sortPath: fields[1] as String?,
      path: fields[2] as String?,
      size: fields[3] as double?,
      displayDate: fields[4] as String?,
      modifyDate: fields[5] as DateTime?,
      viewedDate: fields[6] as DateTime?,
      progress: fields[7] as double?,
    )
      ..currentPage = fields[8] as int?
      ..md5 = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, PdfFileModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.sortPath)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.displayDate)
      ..writeByte(5)
      ..write(obj.modifyDate)
      ..writeByte(6)
      ..write(obj.viewedDate)
      ..writeByte(7)
      ..write(obj.progress)
      ..writeByte(8)
      ..write(obj.currentPage)
      ..writeByte(9)
      ..write(obj.md5);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
