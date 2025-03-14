import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/extentions/string_ext.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/utils/message_handler.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class DeepLinkUtils {
  static final DeepLinkUtils _singleton = DeepLinkUtils._internal();

  factory DeepLinkUtils() {
    return _singleton;
  }

  DeepLinkUtils._internal();

  Future<void> init() async {
    //Terminated State
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      print(initialLink.toString());
      String? link = initialLink.link.toString();
      // String? signature = initialLink.asMap().toString();
      // String downloadLink  = '$link&signature=$signature';
    String downloadLink = '$link';

      print('ZZZZZZZZ downloadLink $downloadLink');
      if (downloadLink.isNotNullAndEmpty) {
        MessageHandler().register(KEY_HOME_CONTROLLER_INITTIAL, (p0) {
          Get.find<HomeController>().handleDeepLink(downloadLink);
          MessageHandler().unregister(KEY_HOME_CONTROLLER_INITTIAL);
        });
      }
    }

    initDynamicLinks();
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  //Background / Foreground State#
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print('MMMMMMMMMMM data ${dynamicLinkData.link.queryParameters}');

      String? link = dynamicLinkData.link.toString();
      // String? signature = dynamicLinkData.asMap().toString();
      // print(signature);
      // String downloadLink  = '$link&signature=$signature';
      String downloadLink  = '$link';
      print('ZZZZZZZZ downloadLink $downloadLink');
      if (downloadLink.isNotNullAndEmpty) {
        if (downloadLink.isNotNullAndEmpty) {
          AppFunc.setTimeout(() {
            Get.find<HomeController>().handleDeepLink(downloadLink);
          }, 300);
        }
      }
    }).onError((error) {
      print(error.message);
    });
  }
}
