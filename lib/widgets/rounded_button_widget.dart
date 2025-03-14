import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double? radiusButton;
  final int delay;
  final bool requestHideKeyboard;
  final Color? backgroundButton;
  final FontWeight? fontWeight;
  final Function onPress;
  final LinearGradient? gradient;
  final bool isShowLoading;

  const RoundedButtonWidget({
    Key? key,
    required this.title,
    this.width,
    this.height,
    this.radiusButton,
    this.delay = 100,
    this.requestHideKeyboard = false,
    this.backgroundButton = const Color.fromRGBO(0, 183, 79, 1.0),
    this.fontWeight = FontWeight.normal,
    this.gradient,
    this.isShowLoading = false,
    required this.onPress,
  }) : super(key: key);

  Widget renderButton(BuildContext context) {
    var radius = radiusButton ?? 0;
    var _height = height ?? 48;
    if (radius <= 0) {
      radius = _height / 2;
    }
    return ElevatedButton(
      style: gradient != null
          ? ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onSurface: Colors.transparent,
              shadowColor: Colors.transparent,
              animationDuration: const Duration(milliseconds: 400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ))
          : ButtonStyle(
              overlayColor: MaterialStateProperty.all(Color(0xFF3B4BA2)),
              backgroundColor: MaterialStateProperty.all(backgroundButton),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              )),
      child: Container(
          height: _height,
          alignment: Alignment.center,
          width: width,
          child: isShowLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(title, style: TextStyle(color: Colors.white, fontSize: 16, height: 1.3, fontWeight: fontWeight))),
      onPressed: () {
        if (requestHideKeyboard) {
          FocusScope.of(Get.context!).unfocus();
        }
        // if (delay > 0) {
        //   AppFunc.setTimeout(onPress, delay);
        // } else {
        onPress();
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var radius = radiusButton ?? 0;
    if (height != null && radius <= 0) {
      radius = height! / 2;
    }
    if (gradient != null) {
      return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0)],
              borderRadius: BorderRadius.circular(radius),
              gradient: gradient!),
          child: renderButton(context));
    } else {
      return renderButton(context);
    }
  }
}
