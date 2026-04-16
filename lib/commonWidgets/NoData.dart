import 'package:flutter/material.dart';
import 'noDataFound.dart';

export 'noDataFound.dart' show buildNoDataWidget;

// Alias for convenience
Widget NoData({double? height, double? width, String? text}) {
  return buildNoDataWidget(height: height, text: text);
}

