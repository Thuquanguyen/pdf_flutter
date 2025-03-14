import 'dart:io';

import 'package:booklibrary/core/extentions/shimmer_ext.dart';
import 'package:booklibrary/widgets/cache_image_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

// ignore: avoid_classes_with_only_static_members
class ImageHelper {
  static final picker = ImagePicker();

  static const double widthIcon = 18;
  static const double heightIcon = 18;

  static Widget loadFromUrl(
    String imageURL, {
    double? width,
    double? height,
    double? radius,
    BoxFit fit = BoxFit.contain,
    bool cached = true,
    Color? tintColor,
    Alignment? alignment,
  }) {
    String _imageURL = imageURL;
    if (!cached) {
      return Container(
        width: width,
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        child: Image.asset(
          _imageURL,
          width: width,
          height: height,
          fit: fit,
          color: tintColor,
          alignment: alignment ?? Alignment.center,
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageURL,
        width: width,
        height: height,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: shimmerBaseColor,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
        ).withShimmer(visible: true),
        imageBuilder: (context, imageProvider) => Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 0),
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
        errorWidget: (BuildContext context, String url, dynamic error) =>
            const Center(
          child: Icon(Icons.error),
        ),
      );
    }
  }

  static Widget loadFromAsset(
    String imageFilePath, {
    String? defaultImage,
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
    Color? tintColor,
    Alignment? alignment,
  }) {
    if (imageFilePath.toLowerCase().endsWith('svg')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: SvgPicture.asset(
          imageFilePath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: tintColor,
          alignment: alignment ?? Alignment.center,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.asset(
          imageFilePath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: tintColor,
          alignment: alignment ?? Alignment.center,
        ),
      );
    }
  }

  static Widget loadIconFromAsset(
    String imageFilePath, {
    double? width = 18,
    double? height = 18,
    double? radius,
    BoxFit? fit,
    Color? tintColor,
    Alignment? alignment,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image.asset(
        imageFilePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: tintColor,
        alignment: alignment ?? Alignment.center,
      ),
    );
  }

  static Future<Widget> loadFromCamera({
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return const SizedBox();
    } else {
      final File _image = File(pickedFile.path);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.file(
          _image,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        ),
      );
    }
  }

  static Future<Widget> loadFromPhotos({
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return const SizedBox();
    } else {
      final File _image = File(pickedFile.path);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.file(
          _image,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        ),
      );
    }
  }

  static Widget loadFromFile({
    required String path,
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) {
    final File _image = File(path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image.file(
        _image,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      ),
    );
  }

  static Widget loadFromFile1({
    required String path,
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) {
    final File _image = File(path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image(
        image: CacheImageProvider(
          path,
          _image.readAsBytesSync(),
        ) ,
      ),
    );
  }
}
