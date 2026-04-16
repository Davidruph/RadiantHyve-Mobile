import 'package:flutter/material.dart';
import '../utils/SizeConstant.dart';

extension CenteredSizedBox on double {
  SizedBox hSpace() {
    return SizedBox(height: MySize.getScaledSizeHeight(MySize.getScaledSizeHeight(this)));
  }

  SizedBox wSpace() {
    return SizedBox(width: MySize.getScaledSizeWidth(MySize.getScaledSizeWidth(this)));
  }
}
