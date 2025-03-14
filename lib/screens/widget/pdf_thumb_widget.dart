import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfThumbWidget extends StatefulWidget {
  const PdfThumbWidget({Key? key, required this.pdfPath}) : super(key: key);

  final String pdfPath;

  @override
  State<PdfThumbWidget> createState() => _PdfThumbWidgetState();

  static Future<void> buildAllThumb(List<PdfFileModel> files) async {
    for (var element in files) {
      print(element.path);
      String path = await buildThumb(element.path ?? '');
    }
  }

  static Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static Future<String> buildThumb(String pdfPath) async {
    if (pdfPath.isEmpty) return '';
    Directory tempDir = await getTemporaryDirectory();
    String path = tempDir.path +
        '/' +
        md5.convert(utf8.encode(pdfPath)).toString() +
        '.png'; //save to cache dir
    if (!File(path).existsSync()) {
      Uint8List unit8list = Uint8List.fromList(File(pdfPath).readAsBytesSync());
      var page = await Printing.raster(unit8list, pages: [0], dpi: 72).first;
      var data = await page.toImage();
      ByteData? byteDataThumb =
          await data.toByteData(format: ImageByteFormat.png);
      if (byteDataThumb != null) {
        await writeToFile(byteDataThumb, path);
      }
    }
    return path;
  }
}

class _PdfThumbWidgetState extends State<PdfThumbWidget> {
  String thumbPath = '';
  bool isActive = false;
  StreamSubscription? loadThumb;

  @override
  void initState() {
    // TODO: implement initState
    isActive = true;
    if (widget.pdfPath.isNotEmpty) {
      loadThumb = AppFunc.setTimeout(() {
        buildThumb();
      }, 300);
    }
    super.initState();
  }

  @override
  void dispose() {
    isActive = false;
    if (loadThumb != null) {
      AppFunc.clearTimeout(loadThumb!);
    }
    super.dispose();
  }

  Future<void> buildThumb() async {
    String path = await PdfThumbWidget.buildThumb(widget.pdfPath);
    if (File(path).existsSync() && isActive == true) {
      setState(() {
        thumbPath = path;
      });
    }
  }

  String getImageThumb() {
    if (widget.pdfPath.contains('/1pdf') == true) {
      return AppAssets.pdf1libThumb;
    }
    return AppAssets.pdfThumb;
  }

  Widget renderThumb() {
    if (thumbPath.isEmpty) {
      return ImageHelper.loadFromAsset(
        getImageThumb(),
        fit: BoxFit.cover,
        radius: 8
      );
    } else {
      return Stack(children: [
        ImageHelper.loadFromFile(path: thumbPath,fit: BoxFit.cover,radius: 8),
        if (widget.pdfPath.contains('/1pdf') == true)
        ImageHelper.loadFromAsset(AppAssets.tag1lib,fit: BoxFit.cover,radius: 8),
      ],);
    }
  }

  @override
  Widget build(BuildContext context) {
    return renderThumb();
  }
}
