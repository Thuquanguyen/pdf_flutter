import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_dimens.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

Widget renderDialogTextButton(
    {required BuildContext context,
    required String title,
    Function? onTap,
    Color? color,
    bool dismiss = true}) {
  return Touchable(
    onTap: () {
      if (dismiss) {
        Navigator.of(context).pop();
      }
      if (onTap != null) {
        onTap.call();
      }
    },
    child: Container(
      color: Colors.transparent,
      height: AppDimens.getInScreenSize(55),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: color != null
            ? AppThemes().general().textTheme.bodyText1?.copyWith(color: color)
            : AppThemes().general().textTheme.bodyText1,
      ),
    ),
  );
}

void showSnackBarAction({String? message, String? title}) {
  Get.snackbar(
    title ?? '',
    message ?? '',
    colorText: Colors.white,
    backgroundColor: const Color(0xff536A92),
    snackPosition: SnackPosition.TOP,
  );
}

Future<dynamic> showAppConfirm(context, title,
    {String? description, Function? onTap}) {
  return showAppDialog(context, title,
      description: description,
      button1:
          renderDialogTextButton(context: context, title: I18n().cancelStr.tr),
      button2: renderDialogTextButton(
          context: context, title: I18n().okStr.tr, onTap: onTap));
}

Future<dynamic> showAppDialog(
  BuildContext context,
  String title, {
  String? description,
  Widget? button1,
  Widget? button2,
  Widget? customBody,
  bool animation = false,
  bool barrierDismissible = true,
  Function? onClose,
  Function? onTapOk,
  String? okTitle,
}) {
  if (!animation) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (BuildContext buildContext) {
        return dialogBuilder(context, title,
            description: description,
            customBody: customBody,
            button1: button1,
            button2: button2,
            onClose: onClose,
            onTapOk: onTapOk,
            okTitle: okTitle);
      },
    );
  }

  return showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: barrierDismissible,
    useRootNavigator: true,
    barrierLabel: 'custom popup',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return dialogBuilder(context, title,
          description: description,
          customBody: customBody,
          button1: button1,
          button2: button2,
          onClose: onClose,
          onTapOk: onTapOk,
          okTitle: okTitle);
    },
    transitionBuilder: (_, anim, __, child) {
      return customTransition(anim, child);
    },
  );
}

AnimatedWidget customTransition(Animation<double> anim, Widget child) {
  // style: slide from bottom
  return SlideTransition(
    position:
        Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
    child: child,
  );
}

Dialog dialogBuilder(
  BuildContext context,
  String title, {
  String? description,
  Widget? button1,
  Widget? button2,
  Widget? customBody,
  Function? onClose,
  Function? onTapOk,
  String? okTitle,
}) {
  Widget? _customBody = customBody;
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), side: BorderSide.none),
    //this right here
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: AppDimens.getInScreenSize(106 / 2)),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle, color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, 5),
                  blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: AppDimens.getInScreenSize(24),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title,
                    style: AppThemes().general().textTheme.headline1?.copyWith(
                        color: Colors.black87, fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: AppDimens.getInScreenSize(8),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _customBody ??
                    Html(
                      data:
                          '<div style="color:#00132F; text-align: center; font-size: 16pt; line-height: 19.5pt">$description</div>',
                    ),
              ),
              SizedBox(
                height: AppDimens.getInScreenSize(16),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: AppDimens.getInScreenSize(55),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: AppDimens.getInScreenSize(0.5),
                        color: const Color.fromRGBO(186, 205, 223, 1.0)),
                  ),
                ),
                child: Row(
                  children: [
                    button1 != null
                        ? Expanded(child: button1)
                        : const SizedBox(
                            width: 0,
                          ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: button1 != null && button2 != null
                                  ? AppDimens.getInScreenSize(0.25)
                                  : 0,
                              color: const Color.fromRGBO(186, 205, 223, 1.0))),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    button2 != null
                        ? Expanded(child: button2)
                        : const SizedBox(
                            width: 0,
                          ),
                    if (button1 == null && button2 == null)
                      Expanded(
                          child: renderDialogTextButton(
                              context: context,
                              title: I18n().okStr.tr,
                              onTap: onTapOk))
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
