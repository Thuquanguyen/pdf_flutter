import 'dart:io';
import 'dart:typed_data';

import 'package:booklibrary/core/extentions/date_ext.dart';
import 'package:hive/hive.dart';

import '../core/app_assets.dart';
import '../core/app_functions.dart';

part 'pdf_file_model.g.dart';

enum StatusDownload { none, waiting, downloading, success }

@HiveType(typeId: 0)
class PdfFileModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? sortPath;

  @HiveField(2)
  String? path;

  @HiveField(3)
  double? size;

  @HiveField(4)
  String? displayDate;

  @HiveField(5)
  DateTime? modifyDate;

  @HiveField(6)
  DateTime? viewedDate;

  bool? isDownload;
  String? code;
  String? downloadUrl;
  StatusDownload status;

  @HiveField(7)
  double? progress;

  //Page đang đọc
  @HiveField(8)
  int? currentPage;

  @HiveField(9)
  String? md5;
  @HiveField(10)
  String? fullTitle;

  bool? isFavorite;

  bool? isSelected;

  String? passWord;

  double? getProgress() {
    if (progress?.isNaN == true || progress?.isInfinite == true) {
      return 0;
    }
    return progress;
  }

  int? getCurrentPage() {
    if (currentPage?.isNaN == true || currentPage?.isInfinite == true) {
      return 1;
    }
    return currentPage;
  }

  Future<ByteData?>? byteDataThumb;

  PdfFileModel(
      {this.name,
      this.sortPath,
      this.path,
      this.size,
      this.displayDate,
      this.modifyDate,
      this.viewedDate,
      this.code,
      this.downloadUrl,
      this.isDownload = false,
      this.status = StatusDownload.none,
      this.progress = 0,
      this.isFavorite,
      this.isSelected,
      this.md5,
      this.fullTitle,
      this.byteDataThumb});

  String getSize() {
    if (size != null) {
      return '${size!.toStringAsFixed(2)} MB';
    }
    return '';
  }

  static Future<PdfFileModel> getInfoFromFileSystemEntity(
      FileSystemEntity element) async {
    String? name = element.path.split("/").last;
    FileStat fileStat = element.statSync();

    String shortPath = element.path;
    shortPath = shortPath.replaceAll('storage/emulated/0', '');
    shortPath = shortPath.substring(
      0,
      shortPath.lastIndexOf('/'),
    );
    String fileChecksum = '';
    fileChecksum = await AppFunc.generateMd5(element.path);
    PdfFileModel fileModel = PdfFileModel(
        name: name,
        path: element.path,
        size: fileStat.size / (1024 * 1024),
        displayDate: fileStat.modified.getDateString(),
        sortPath: shortPath,
        viewedDate: fileStat.accessed,
        modifyDate: fileStat.changed,
        fullTitle: '',
        md5: fileChecksum);
    // try {
    //   fileModel.getThumb();
    // } catch (e) {
    //   print('file get thumb err $e');
    // }

    return fileModel;
  }

  String getImageThumb() {
    if (path?.contains('/1pdf') == true) {
      return AppAssets.pdf1libThumb;
    }
    return AppAssets.pdfThumb;
  }

  Future<ByteData?> getThumb() async {
    // Uint8List unit8list = Uint8List.fromList(File(path ?? '').readAsBytesSync());
    // print('unit8list = $unit8list');
    // var page = await Printing.raster(unit8list, pages: [0], dpi: 72).first;
    // var data = await page.toImage();
    // byteDataThumb = data.toByteData(format: ImageByteFormat.png);
    return null;
  }


}
