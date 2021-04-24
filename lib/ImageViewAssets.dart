import 'package:flutter/material.dart';

Widget imageViewAsset({
  EdgeInsetsGeometry margin = const EdgeInsets.all(0),
  EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  @required String imagePath,
  double imageWidth = null,
  double imageHeight = null,
  BoxFit fit = BoxFit.none,
  Alignment alignment,
}) {
  return Container(
    margin: margin,
    alignment: alignment,
    padding: padding,
    child: Image.asset(
      imagePath,
      width: imageWidth,
      height: imageHeight,
      fit: fit,
    ),
  );
}
