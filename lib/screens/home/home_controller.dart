import 'dart:convert';
import 'dart:io';

import 'package:booklibrary/widgets/dialog_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/api_service/api_provider.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/detail/detail_screen.dart';
import 'package:booklibrary/screens/main/main_controller.dart';
import 'package:booklibrary/screens/multile_file_selected/multile_file_selected_screen.dart';
import 'package:booklibrary/screens/qr_code/model/qr_model.dart';
import 'package:booklibrary/screens/selected_controller.dart';
import 'package:booklibrary/utils/message_handler.dart' as messageHandler;
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/item_pdf_shimmer.dart';
import '../../widgets/item_pdf_vertical.dart';

class HomeController extends SelectedController {
  RxBool isDownloading = false.obs;
  RxInt progressValue = 0.obs;
  RxBool isLoading = false.obs;

  RxBool isFirstLoading = true.obs;
  RxBool isShowMargin = true.obs;
  RxBool isShowQR = true.obs;
  static const platform = MethodChannel('com.digitalcontent.onepdf/main');

  @override
  Future<void> onInit() async {
    super.onInit();
    checkShowQR();
    messageHandler.MessageHandler()
        .register(KEY_ADD_DOWNLOAD, handleDataDownload);
    AppController().initController<HomeController>(this);

    callChanel();
    await loadData();

    messageHandler.MessageHandler().notify(KEY_HOME_CONTROLLER_INITTIAL);
  }

  void closeQRScan() {
    isShowQR.value = false;
  }

  void checkShowQR() {
    final box = GetStorage();
    int? qrCount = box.read(AppConfig.SHOW_QR) ?? 0;
    print("qrCount = $qrCount");
    if (qrCount < 3) {
      box.write(AppConfig.SHOW_QR, qrCount += 1);
    } else {
      isShowQR.value = false;
    }
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'openDetail1Lib':
        if ((call.arguments is String) &&
            (call.arguments as String).isNotEmpty) {
          _handleActionDetail(call.arguments);
        }
        return Future.value('called from platform!');
      default:
        throw MissingPluginException();
    }
  }

  callChanel() async {
    platform.setMethodCallHandler(_platformCallHandler);
    await platform.invokeMethod('goToHome');
  }

  void removeFirstLoading() {
    isFirstLoading.value = false;
  }

  void _handleActionDetail(String path) async {
    String fileChecksum = '';
    fileChecksum = await AppFunc.generateMd5(path);
    PdfFileModel pdfFileModel = getModel(fileChecksum);
    if (pdfFileModel.path?.isNotEmpty == true) {
      _gotoDetailScreen(pdfFileModel);
    }
  }

  PdfFileModel getModel(String md5) {
    List<PdfFileModel> _listFile = PdfManager().pdfList;
    for (int i = 0; i < _listFile.length; i++) {
      if (_listFile[i].md5 == md5) {
        return _listFile[i];
      }
    }
    return PdfFileModel();
  }

  Future<void> _gotoDetailScreen(PdfFileModel pdfFileModel) async {
    //Lưu vào db recent
    messageHandler.MessageHandler().notify(RELOAD_DETAIL, data: pdfFileModel);
    await Get.toNamed(
      DetailScreen.routeName,
      arguments: pdfFileModel,
    );
  }

  void updatePdfFile(List<PdfFileModel> dataList) {
    List<PdfFileModel> newList = [];
    newList.addAll(pdfList);

    for (var a in pdfList) {
      for (var b in dataList) {
        if (a.path == b.path) {
          a.isFavorite = b.isFavorite;
          a.currentPage = b.currentPage;
          a.progress = b.progress;
          break;
        }
      }
    }
    setData(newList);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageHandler.MessageHandler().unregister(KEY_ADD_DOWNLOAD);
    super.dispose();
  }

  Future<Directory> getFolderPath(String folderName) async {
    Directory? _directory;
    //Get this App Document Directory
    if (Platform.isAndroid) {
      _directory = Directory('/storage/emulated/0/Download');
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }
    // App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_directory.path}/$folderName');
    return _appDocDirFolder;
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    Directory _appDocDirFolder = await getFolderPath(folderName);

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  bool checkFileExit(String path) {
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      return true;
    }
    return false;
  }

  void downloadFunction({PdfFileModel? pdfModel, QrModel? qrModel}) async {
    var dio = Dio();
    createFolderInAppDocDir('1pdf').then((tempDir) {
      String tmpName = pdfModel?.name ?? '';
      tmpName = tmpName.replaceAll(':', '').replaceAll(
            '&',
            ''.replaceAll('~', '').replaceAll('?', ''),
          );
      String savePath = tempDir + "/$tmpName.pdf";
      downloadFile(
          dio, qrModel?.downloadUrl ?? '', savePath, pdfModel?.name ?? '',
          pdfModel: pdfModel, sortPath: tempDir);
    });
  }

  Future downloadFile(Dio dio, String urlPath, String savePath, String fileName,
      {PdfFileModel? pdfModel, String? sortPath}) async {
    if (isDownloading.value) {
      return;
    }
    try {
      isDownloading.value = true;
      await dio.download(urlPath, savePath,
          onReceiveProgress: (rec, total) async {
        if (total != -1) {
          int progress = (((rec / total) * 100).toInt());
          progressValue.value = progress;
          pdfModel?.status = StatusDownload.downloading;
          refresh();
          if (progress >= 100) {
            pdfModel?.status = StatusDownload.success;
            pdfModel?.path = savePath;
            pdfModel?.sortPath = sortPath ?? '';
            pdfModel?.isDownload = false;
            String fileChecksum = '';
            fileChecksum = await AppFunc.generateMd5(savePath);
            pdfModel?.md5 = fileChecksum;
            // progressValue.value = 0;
            isDownloading.value = false;
            resumeDownload();
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void resumeDownload({PdfFileModel? pdfModel}) {
    var dio = Dio();
    for (var element in pdfList) {
      if (element.status == StatusDownload.waiting) {
        createFolderInAppDocDir('1pdf').then(
          (tempDir) {
            String tmpName = pdfModel?.name ?? '';
            tmpName = tmpName.replaceAll(':', '').replaceAll(
                  '&',
                  ''.replaceAll('~', '').replaceAll('?', ''),
                );
            String savePath = tempDir + "/$tmpName.pdf";

            downloadFile(
                dio, element.downloadUrl ?? '', savePath, element.name ?? '',
                pdfModel: element, sortPath: tempDir);
          },
        );
        return;
      }
    }
  }

  void handleDataDownload(dynamic data) {
    if (data is QrModel) {
      for (int i = 0; i < pdfList.length; i++) {
        if ((pdfList[i].code ?? '').contains(data.code ?? '')) {
          return;
        }
      }
      String shortTitle = data.title ?? '';
      print("shortTitle.length lenght = ${shortTitle.length}");
      shortTitle =
          shortTitle.length > 50 ? shortTitle.substring(0, 50) : shortTitle;
      PdfFileModel pdfFile = PdfFileModel(
          name: shortTitle,
          sortPath: '',
          path: '',
          code: data.code,
          downloadUrl: data.downloadUrl,
          size: (data.size ?? 0).toDouble() / (1024 * 1024),
          status: StatusDownload.waiting,
          fullTitle: data.title,
          isDownload: true);
      isShowMargin.value = false;
      insertPdfView(pdfFile);
      if (!(isDownloading.value)) {
        downloadFunction(pdfModel: pdfFile, qrModel: data);
      }
      refresh();
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          Transform.scale(
              scale: 0.7,
              child: const CircularProgressIndicator(color: Colors.black)),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(I18n().searchNewFileStr.tr)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  reloadData() async {
    showLoaderDialog(Get.context!);
    AppFunc.setTimeout(() async {
      if (Platform.isAndroid) {
        await PdfManager().getAllPdf(waitLoadFromDevice: true);
      } else {
        await PdfManager().get1LibFile();
      }
      loadData();
      Navigator.of(Get.context!).pop();
    }, 1000);
  }

  void setPageType() {
    AppController().find<MainController>()?.setPageType(PageType.home);
  }

  Future<void> loadData() async {
    List<PdfFileModel> favoriteList =
        await LocalDbManager().getFavoritePdfList();
    List<PdfFileModel> recentList = await LocalDbManager().getRecentPdfList();
    AppController().find<MainController>()?.getTotalFile();

    List<PdfFileModel> data = [];
    data.addAll(PdfManager().pdfList);
    if (data.isNotEmpty) {
      isShowMargin.value = false;
    }
    for (PdfFileModel e in data) {
      for (PdfFileModel f in recentList) {
        if (e.path == f.path) {
          e.progress = f.progress;
          e.currentPage = f.currentPage;
          continue;
        }
      }
      for (PdfFileModel f in favoriteList) {
        if (e.path == f.path) {
          e.isFavorite = true;
          continue;
        }
      }
    }

    removeFirstLoading();

    setSortType(sortBy, sortByType, dataList: data);
  }

  /**
   * handle deeplink dowload
   */
  String _deviceId = '';
  String _signature = '';
  String key = 'f{]772FG{TyC9N)B';

  final deviceInfoPlugin = DeviceInfoPlugin();

  ApiProviderRepositoryImpl apiProvider = ApiProviderRepositoryImpl();

  Rx<PdfFileModel> pdfFileModel = PdfFileModel().obs;

  Rx<QrModel> qrData = QrModel().obs;

  void setPdfFile(PdfFileModel pdfFile) {
    pdfFileModel.value = pdfFile;
    refresh();
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future getDeviceInfo() async {
    if (_deviceId.isNotEmpty) return;
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    if (Platform.isIOS) {
      if (deviceInfo.toMap()['identifierForVendor'] != null) {
        _deviceId = deviceInfo.toMap()['identifierForVendor'];
        _signature = generateMd5('$_deviceId$key');
      }
    } else if (Platform.isAndroid) {
      if (deviceInfo.toMap()['androidId'] != null) {
        _deviceId = deviceInfo.toMap()['androidId'];
        _signature = generateMd5('$_deviceId$key');
      }
    }

    return;
  }

  void handleDeepLink(String url) async {
    print('handleDeepLink $url');

    await getDeviceInfo();

    var params = {
      "app_uuid": _deviceId,
      "signature": _signature,
    };

    print('DEEPLINK cal API params ${params.toString()}');

    showBottomSheet();
    try {
      await apiProvider.postRequest(url, data: params).then(
        (value) {
          final data = QrModel.fromJson(
            jsonDecode(
              value.toString(),
            ),
          );
          qrData.value = data;
          if (data.success != null) {
            String shortTitle = data.title ?? '';
            shortTitle = shortTitle.length > 100
                ? shortTitle.substring(0, 100)
                : shortTitle;
            PdfFileModel pdfFile = PdfFileModel(
                name: shortTitle,
                sortPath: '',
                path: '',
                code: data.code,
                size: (data.size ?? 0).toDouble() / (1024 * 1024),
                status: StatusDownload.waiting,
                isDownload: true);
            setPdfFile(pdfFile);
          } else {
            BuildContext? mContext = Get.context;
            if (mContext != null) {
              Navigator.of(mContext).pop();
            }
            AppFunc.showError(I18n().expiredStr.tr);
          }
        },
      );
    } catch (e) {
      BuildContext? mContext = Get.context;
      if (mContext != null) {
        Navigator.of(mContext).pop();
      }
      showSnackBarAction(message: 'Thất bại, Có lỗi xảy ra !');
    }
  }

  showBottomSheet() {
    Get.dialog(
      Obx(
        () => Container(
          height: Get.height,
          width: Get.width,
          color: Colors.black.withOpacity(0.5),
          // height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Container(
                height: 180,
                width: Get.size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      // padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Get.context?.theme.backgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        I18n().pleaseConfirmStr.tr,
                        style: AppThemes()
                            .general()
                            .textTheme
                            .headline1
                            ?.copyWith(
                                fontSize: 16.h, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Get.context?.theme.backgroundColor,
                        ),
                        alignment: Alignment.center,
                        child: pdfFileModel.value.code == null
                            ? itemPdfShimmer()
                            : itemPdfVertical(
                                pdfFileModel.value,
                                isPreview: true,
                                value: 0,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.size.width - 40,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (pdfFileModel.value.code != null) {
                      Get.back();
                      messageHandler.MessageHandler()
                          .notify(KEY_ADD_DOWNLOAD, data: qrData.value);
                      AppFunc.setTimeout(() {
                        Get.back();
                      }, 300);
                    }
                  },
                  child: Text(
                    I18n().downloadStr.tr,
                    style: AppThemes().general().textTheme.headline1?.copyWith(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                        color: pdfFileModel.value.code == null
                            ? Colors.blueGrey
                            : Colors.red),
                  ),
                  style: ButtonStyle(
                    backgroundColor: pdfFileModel.value.code == null
                        ? MaterialStateProperty.all(Colors.grey)
                        : MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: Get.size.width - 40,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // resume camera
                    BuildContext? mContext = Get.context;
                    if (mContext != null) {
                      Navigator.of(mContext).pop();
                    }
                  },
                  child: Text(
                    I18n().cancelStr.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.transparent,
    );
  }
}
