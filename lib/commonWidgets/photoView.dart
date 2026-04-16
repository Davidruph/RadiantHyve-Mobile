import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../utils/Img_Icon.dart';
import '../utils/SizeConstant.dart';
import 'common_widgets.dart';

class PhotoViewWidget extends StatelessWidget {
  final String? imgUrl;
  final flag;

  const PhotoViewWidget({super.key, this.imgUrl, this.flag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonWidget.appBar(
        backgroundColor: Colors.white,
        textColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset(icons.backIcon, scale: 3.5, color: Colors.black),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(16)),
            child: Center(
              child:
              flag == "asset"
                  ? PhotoView(backgroundDecoration: const BoxDecoration(color: Colors.white), imageProvider: AssetImage(imgUrl!))
                  : PhotoView(backgroundDecoration: const BoxDecoration(color: Colors.white), imageProvider: NetworkImage(imgUrl!)),
            ),
          ),
        ],
      ),
    );
  }
}
