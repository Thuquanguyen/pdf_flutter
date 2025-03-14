import 'dart:async';
import 'dart:io';

import 'package:booklibrary/constants.dart';
import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/widget/pdf_thumb_widget.dart';
import 'package:booklibrary/utils/message_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PdfManager {
  static final PdfManager _singleton = PdfManager._internal();

  factory PdfManager() {
    return _singleton;
  }

  PdfManager._internal();

  List<PdfFileModel> pdfList = [];
  List<PdfFileModel> preLoadPdfList = [];

  Future<void> loadFromDeviceInBackground() async {
    if(Platform.isIOS){
      await get1LibFile();
    }else{
      await getAllPdfDevice();
    }
    Map<String, bool> mark = {};
    for (var element in pdfList) {
      String key = element.path ?? '';
      mark[key] = true;
    }
    int hasNewFile = 0;
    for (var element in preLoadPdfList) {
      String key = element.path ?? '';
      if (mark.containsKey(key) == false) {
        hasNewFile++;
        mark[key] = true;
        pdfList.add(element);
      }
    }
    print('has new files $hasNewFile');
  }

  Future<void> getAllPdf({bool waitLoadFromDevice = false}) async {
    await LocalDbManager().getAllPdfLocalDb();
    if (pdfList.isEmpty ) {
      await getAllPdfDevice();
      print("preLoadPdfList  = ${preLoadPdfList.length}");
      pdfList.addAll(preLoadPdfList);
    } else {
      MessageHandler().notify(START_SCAN,data: 1);
      for (var element in pdfList) {
        try {
          await PdfThumbWidget.buildThumb(element.path ?? '');
        } catch (e) {
          print('file get thumb err $e');
        }
      }
      if (waitLoadFromDevice) {
        await loadFromDeviceInBackground();
      } else {
        loadFromDeviceInBackground();
      }
    }
  }

  Future<void> getAllPdfFromLocal() async {
    await LocalDbManager().getAllPdfLocalDb();
  }

  Future<void> getAllPdfDevice() async {
    preLoadPdfList.clear();
    Permission _permission;
    if(Platform.isAndroid){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int? version = androidInfo.version.sdkInt ?? 30;
      if (version >= 30) {
        _permission = Permission.manageExternalStorage;
      } else {
        _permission = Permission.storage;
      }
    }else{
      _permission = Permission.storage;
    }
    if (await _permission.request().isGranted) {
      MessageHandler().notify(START_SCAN,data: 1);
      if(Platform.isAndroid){
        await getFileFromDirectory(Directory('storage/emulated/0'), 1);
      }else{
        await get1LibFile();
      }
      for (var element in preLoadPdfList) {
        print("ELEMENT = $element");
        LocalDbManager().totalRepository.addTotal(element);
      }
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [_permission].request();
      if (statuses[_permission] == PermissionStatus.granted) {
        await getAllPdfDevice();
      }
    }
  }

  Future<void> getFileFromDirectory(Directory dir, int depth) async {
    if (depth > 3) {
      return;
    }
    try {
      final List<FileSystemEntity> entities = await dir.list().toList();
      for (var element in entities) {
        if (FileSystemEntity.isFileSync(element.path) &&
            element.path.endsWith('.pdf')) {
          MessageHandler().notify(GET_PATH_FILE,data: element.path);
          preLoadPdfList
              .add(await PdfFileModel.getInfoFromFileSystemEntity(element));
        } else if (FileSystemEntity.isDirectorySync(element.path)) {
          if (element.path.contains('storage/emulated/0/Android/')) {
            continue;
          } else {
            await getFileFromDirectory(Directory(element.path), depth + 1);
          }
        }
      }
    } catch (e) {
      print('getFileFromDirectory exception $e');
    }
  }

  ///storage/emulated/0/Download
  Future<void> get1LibFile() async {
    Directory? _directory;
    _directory = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder =
    Directory('${_directory.path}/1pdf');
    if(_appDocDirFolder.existsSync()){
      final List<FileSystemEntity> entities = await _appDocDirFolder.list().toList();
      print("entities.length = ${entities.length}");
      for (var element in entities) {
        if (FileSystemEntity.isFileSync(element.path) && element.path.endsWith('.pdf')) {
          print("element = $element");
          preLoadPdfList.add(await PdfFileModel.getInfoFromFileSystemEntity(element));
        }
      }
    }
  }

  Future<void> checkPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int? version = androidInfo.version.sdkInt ?? 30;

    Permission _permission;

    if (version >= 30) {
      _permission = Permission.manageExternalStorage;
    } else {
      _permission = Permission.storage;
    }

    if (await _permission.request().isGranted) {
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [_permission].request();
    }
  }

  Future<void> renameFile(String newName, String path) async {
    File file = File(path);
    try {
      await file.rename(newName);
      return;
    } catch (e) {
      return;
    }
  }

  Future<void> deleteFile(
    PdfFileModel pdfFileModel,
  ) async {
    File file = File(pdfFileModel.path ?? '');
    try {
      await file.delete();
      LocalDbManager().removeRecent(pdfFileModel);
      LocalDbManager().removeFavorite(pdfFileModel);
      return;
    } catch (e) {
      return;
    }
  }

  void shareFile(String path) {
    Share.shareFiles(
      [path],
    );
  }
}
