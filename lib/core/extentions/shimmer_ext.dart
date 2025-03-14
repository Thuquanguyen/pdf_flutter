import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Color shimmerBaseColor = Colors.grey.shade300;
Color shimmerHighlightColor = Colors.grey.shade400;

extension ShimmerText on Text {
  Widget withShimmer({
    bool visible = false,
    required int expectedCharacterCount,
    int randomizeRange = 0,
    Color? baseColor,
    Color? highlightColor,
    Color? backgroundColor,
  }) {
    if (!visible) return this;

    int charCount = expectedCharacterCount;

    if (randomizeRange != 0) {
      if (randomizeRange.isNegative) {
        throw 'randomizeRange must be greater than 0!';
      }
      if (randomizeRange > expectedCharacterCount - 1) {
        throw 'randomizeRange must be smaller than expectedCharacterCount!';
      }
      int n = Random().nextInt(randomizeRange * 2);
      if (n > randomizeRange) charCount += (n - randomizeRange);
      if (n < randomizeRange) charCount -= n;
    }
    String sampleText = '';
    for (int i = 0; i <= charCount; i++) {
      sampleText += '  ';
    }
    return Shimmer.fromColors(
      baseColor: baseColor ?? shimmerBaseColor,
      highlightColor: highlightColor ?? shimmerHighlightColor,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Text(
            sampleText,
            style: style,
          ),
          Container(
            height: 10,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              sampleText,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}

extension ShimmerContainer on Container {
  Widget withShimmer({
    bool visible = false,
    Color? baseColor,
    Color? highlightColor,
    Color? backgroundColor,
  }) {
    if (!visible) return this;

    return Shimmer.fromColors(
      baseColor: baseColor ?? shimmerBaseColor,
      highlightColor: highlightColor ?? shimmerHighlightColor,
      child: this,
    );
  }
}