import 'dart:convert';

import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  const MyCircleAvatar({
    Key? key,
    this.name = '',
    required this.size,
    this.borderWidth = 0,
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.color = Colors.green,
    this.image = '',
    this.onTap,
  }) : super(key: key);

  final String name;
  final double size;
  final double borderWidth;
  final Color borderColor;
  final Color color;
  final Function? onTap;
  final Color backgroundColor;
  final String image;

  String getLetterAvatar(String name) {
    final tmp = name.trim().split(' ');
    if (tmp.length >= 2) {
      String tmp1 = tmp[0];
      String tmp2 = tmp[tmp.length - 1];
      return '${tmp1[0]}${tmp2[0]}'.toUpperCase();
    } else if (name.length > 1) {
      return '${name[0]}${name[1]}'.toUpperCase();
    } else {
      return name.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = size;
    double r1 = size / 2;
    double r2 = size / 2 - borderWidth;

    return Container(
      width: w,
      height: w,
      decoration: BoxDecoration(border: Border.all(width: borderWidth, color: borderColor), borderRadius: BorderRadius.all(Radius.circular(r1))),
      child: Container(
        child: Touchable(onTap: () {
          onTap?.call();
        },
        child: buildCircleAvatar(context, r2, backgroundColor, color)),
        decoration: const BoxDecoration(shape: BoxShape.circle),
      ),
    );
  }

  Widget getImageBase64(String image) {
    var _imageBase64 = image;
    const Base64Codec base64 = Base64Codec();
    var bytes = base64.decode(_imageBase64);
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
  }

  CircleAvatar buildCircleAvatar(BuildContext context, double r, Color backgroundColor, Color color) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: r,
      child: (image.isNotEmpty
          ? ClipOval(
              child:
                  image.startsWith('http') ? ImageHelper.loadFromUrl(image, fit: BoxFit.cover) : ImageHelper.loadFromAsset(image, fit: BoxFit.cover),
            )
          : Text(
              getLetterAvatar(name),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'sans-serif', color: color, fontWeight: FontWeight.w500, fontSize: r * 0.8),
            )),
    );
  }
}
