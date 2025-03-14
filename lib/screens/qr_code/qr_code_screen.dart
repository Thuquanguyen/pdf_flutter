import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/api_service/api_provider.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/qr_code/model/qr_model.dart';
import 'package:booklibrary/screens/qr_code/qr_code_controller.dart';
import 'package:booklibrary/utils/message_handler.dart';
import 'package:booklibrary/widgets/app_container.dart';
import 'package:booklibrary/widgets/item_pdf_shimmer.dart';
import 'package:booklibrary/widgets/item_pdf_vertical.dart';
import 'package:booklibrary/widgets/lazy_widget.dart';
import 'package:booklibrary/widgets/state_builder.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScreen extends StatefulWidget {
  static String routeName = '/QrCodeScreen';

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String _deviceId = '';
  String _signature = '';
  String key = 'f{]772FG{TyC9N)B';
  int index = 0;
  final deviceInfoPlugin = DeviceInfoPlugin();
  final StateHandler _stateHandler = StateHandler(QrCodeScreen.routeName);
  late final ApiProviderRepositoryImpl apiProvider;
  final QrCodeController qrCodeController = QrCodeController();
  Timer? interval;

  @override
  void reassemble() {
    super.reassemble();
    interval ??= AppFunc.setInterval(() {
      if (controller == null) return;
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
      AppFunc.clearInterval(interval!);
      interval = null;
    }, 500);
  }

  @override
  void initState() {
    // TODO: implement initState
    reassemble();
    getDeviceInfo();
    apiProvider = ApiProviderRepositoryImpl();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.stopCamera();
    controller?.dispose();
    super.dispose();
  }

  void callApi(String url, String uuid, String signature) async {
    var params = {
      "app_uuid": _deviceId,
      "signature": _signature,
    };

    print('QR Screen call API params ${params.toString()}');

    showBottomSheet();
    await apiProvider.postRequest(url, data: params).then((value) {
      final data = QrModel.fromJson(jsonDecode(value.toString()));
      print("DATA SCAN = ${data.toString()}");
      qrCodeController.qrData.value = data;
      if (data.success != null) {
        controller?.pauseCamera();
        String shortTitle = data.title ?? '';
        print("shortTitle.length lenght = ${shortTitle.length}");
        shortTitle =
            shortTitle.length > 100 ? shortTitle.substring(0, 100) : shortTitle;
        print("shortTitle = $shortTitle");
        print("shortTitle.length lenght2 = ${shortTitle.length}");
        PdfFileModel pdfFile = PdfFileModel(
            name: shortTitle,
            sortPath: '',
            path: '',
            code: data.code,
            size: (data.size ?? 0).toDouble() / (1024 * 1024),
            status: StatusDownload.waiting,
            isDownload: true);
        qrCodeController.setPdfFile(pdfFile);
      } else {
        Navigator.pop(context);
        final alert = AlertDialog(
          title: Text(I18n().errorStr.tr),
          content: Text(I18n().expiredStr.tr),
          actions: [
            TextButton(
              child: Text(
                I18n().okStr.tr,
                style: AppThemes()
                    .general()
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 16.h),
              ),
              onPressed: () {
                index = 0;
                controller?.resumeCamera();
                Navigator.pop(Get.context!);
              },
            ),
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    });
  }

  void getDeviceInfo() async {
    if (_deviceId.isNotEmpty) return;
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    if (Platform.isIOS) {
      if (deviceInfo.toMap()['identifierForVendor'] != null) {
        _deviceId = deviceInfo.toMap()['identifierForVendor'];
        _signature = generateMd5('$_deviceId$key');
        _stateHandler.refresh();
      }
    } else if (Platform.isAndroid) {
      if (deviceInfo.toMap()['androidId'] != null) {
        _deviceId = deviceInfo.toMap()['androidId'];
        _signature = generateMd5('$_deviceId$key');
        _stateHandler.refresh();
      }
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrCodeController>(
        builder: (qrController) => AppContainer(
              title: I18n().qrScanStr.tr,
              colorTitle: Colors.white,
              appBarType: AppBarType.OVERLAY,
              colorBack: Colors.white,
              onBack: () {
                controller?.pauseCamera();
                AppFunc.setTimeout(() {
                  Get.back();
                }, 300);
              },
              child: Container(
                color: Colors.black,
                child: LazyWidget(
                  child: _buildQrView(context),
                  delay: 350,
                ),
              ),
            ));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Future<void> _processQRCodeData(BuildContext context, String data) async {
    String keyQR = 'https://';
    print('_processQRCodeData $data');
    if (index == 0) {
      callApi(data, _deviceId, _signature);
      index += 1;
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    if (this.controller == null) {
      setState(() {
        this.controller = controller;
      });
      controller.scannedDataStream.listen((scanData) {
        this.controller?.pauseCamera();
        AppFunc.setTimeout(() {
          _processQRCodeData(context, scanData.code ?? '');
        }, 300);
      });
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  showBottomSheet() {
    Get.bottomSheet(
      Obx(() => SizedBox(
            height: 350,
            child: Column(
              children: <Widget>[
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width - 40,
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
                          color: context.theme.backgroundColor,
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
                            color: context.theme.backgroundColor,
                          ),
                          alignment: Alignment.center,
                          child:
                              qrCodeController.pdfFileModel.value.code == null
                                  ? itemPdfShimmer()
                                  : itemPdfVertical(
                                      qrCodeController.pdfFileModel.value,
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
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (qrCodeController.pdfFileModel.value.code != null) {
                        Navigator.pop(context);
                        MessageHandler().notify(KEY_ADD_DOWNLOAD,
                            data: qrCodeController.qrData.value);
                        try {
                          controller?.stopCamera();
                        } catch (e) {
                          print(e);
                        }
                        AppFunc.setTimeout(() {
                          Get.back();
                        }, 300);
                      }
                    },
                    child: Text(
                      I18n().downloadStr.tr,
                      style: AppThemes()
                          .general()
                          .textTheme
                          .headline1
                          ?.copyWith(
                              fontSize: 16.h,
                              fontWeight: FontWeight.bold,
                              color: qrCodeController.pdfFileModel.value.code ==
                                      null
                                  ? Colors.blueGrey
                                  : Colors.red),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          qrCodeController.pdfFileModel.value.code == null
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
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // resume camera
                      index = 0;
                      controller?.resumeCamera();
                      Navigator.pop(context);
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
              ],
            ),
          )),
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
    );
  }
}
