import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/SizeConstant.dart';

Widget diagonalShimmer({
  double? height,
  double? width,
  Widget? child,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
  BoxShape? shape,
  String? assetImage, // Add this parameter
}) {
  return Shimmer.fromColors(
    direction: ShimmerDirection.ltr,
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: margin,
      padding: padding,
      height: height ?? Get.height,
      width: width ?? Get.width,
      decoration: BoxDecoration(
        image: assetImage != null // Check if assetImage is provided
            ? DecorationImage(image: AssetImage(assetImage))
            : null, // Set to null if no assetImage is provided
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: const [0.3, 0.5, 0.7],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ??
            BorderRadius.circular(
              MySize.getScaledSizeHeight(14),
            ),
        shape: shape ?? BoxShape.rectangle,
      ),
      child: child,
    ),
  );
}
