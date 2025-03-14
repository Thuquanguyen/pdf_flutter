import 'dart:async';
import 'dart:io';

import 'package:booklibrary/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'ignore_certificate_func.dart';

class AppFunc {
  static String getTimeNowString() {
    DateTime dateTime = DateTime.now();
    String date = DateFormat('dd-MM-yyyy').format(dateTime);
    return date;
  }

  static bool checkDateTime(String date) {
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(date);
    int value = DateTime.now().difference(tempDate).inDays;
    return value > 0 ? true : false;
  }

  static Timer setInterval(Function callback, int milliseconds) {
    return Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      callback();
    });
  }

  static void initHttpSslIgnore() {
    HttpOverrides.global = IgnoreCertificateErrorOverrides();
  }

  static void clearInterval(Timer subscription) {
    try {
      subscription.cancel();
    } catch (e) {
      print(e);
    }
  }

  int initWeakLock() {
    final box = GetStorage();
    int? tm = box.read(KEY_SETUP_WEAK_LOCK);
    if (tm == null) {
      box.write(KEY_SETUP_WEAK_LOCK, 0);
      return 0;
    } else if (tm == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  void changeWeakLock(int weakLock) {
    final box = GetStorage();
    if (weakLock == 0) {
      box.write(KEY_SETUP_WEAK_LOCK, 0);
    } else {
      box.write(KEY_SETUP_WEAK_LOCK, 1);
    }
  }

  static StreamSubscription setTimeout(Function callback, int milliseconds) {
    final future = Future.delayed(Duration(milliseconds: milliseconds));
    return future.asStream().listen((event) {}, onDone: () {
      callback();
    });
  }

  static void clearTimeout(StreamSubscription subscription) {
    try {
      subscription.cancel();
    } catch (e) {
      print(e.toString());
    }
  }

  static void hideKeyboard() {
    if (Get.context != null) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
  }

  static void showLoading() {
    EasyLoading.show();
  }

  static void hideLoading() {
    EasyLoading.dismiss();
  }

  static void showSuccess(String status) {
    EasyLoading.showSuccess(status,
        duration: const Duration(milliseconds: 1000));
  }


  static void showError(String status) {
    EasyLoading.showError(status,
        duration: const Duration(milliseconds: 1000));
  }
  static Future<String> generateMd5(String path) async {
    final fileStream = File(path).openRead();
    return (await md5.bind(fileStream).first).toString();
  }
}
