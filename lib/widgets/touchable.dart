import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:flutter/material.dart';

class Touchable extends StatelessWidget {
  final Function() onTap;
  final Function()? onLongPress;
  final Function(TapDownDetails)? onTapDown;
  final Widget child;
  final bool rippleAnimation;
  final bool enableFeedback;
  final Color? rippleColor;
  final bool? clearTimeOut;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const Touchable(
      {Key? key,
      required this.onTap,
      required this.child,
      this.onTapDown,
      this.enableFeedback = false,
      this.rippleAnimation = false,
      this.padding,
      this.margin,
      this.rippleColor,
      this.onLongPress,
      this.clearTimeOut})
      : super(key: key);

  void _onTap() {
    if (clearTimeOut == true) {
      onTap.call();
    } else {
      AppFunc.setTimeout(onTap, 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rippleAnimation) {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
          primary: rippleColor ?? Colors.lightBlueAccent,
          elevation: 0,
          enableFeedback: enableFeedback,
          backgroundColor: Colors.transparent,
          textStyle: AppThemes().general().textTheme.button,
          splashFactory: InkRipple.splashFactory,
          // animationDuration: const Duration(milliseconds: 100),
        ),
        onPressed: _onTap,
        onLongPress: onLongPress,
        child: Container(
          color: Colors.transparent,
          padding: padding,
          margin: margin,
          child: child,
        ),
      );
    } else {
      return GestureDetector(
          onTap: _onTap,
          onTapDown: onTapDown,
          child: Container(
            padding: padding,
            margin: margin,
            color: Colors.transparent,
            child: child,
          ));
    }
  }
}
