import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'commonShimmer.dart';

class CachedImageContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final String? image;

  final placeHolder;
  final double circular;
  final BoxFit? fit;
  final double topCorner;
  final double bottomCorner;
  final flag;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  final Color? baseColor;
  final Color? highlightColor;

  const CachedImageContainer({
    super.key,
    this.height,
    this.width,
    this.image,
    this.circular = 0.0,
    required this.placeHolder,
    this.fit,
    this.topCorner = 0.0,
    this.bottomCorner = 0.0,
    this.flag,
    this.borderRadius,
    this.gradient,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topCorner),
          topRight: Radius.circular(topCorner),
          bottomLeft: Radius.circular(bottomCorner),
          bottomRight: Radius.circular(bottomCorner),
        ),
        child: CachedNetworkImage(
          width: width,
          height: height,
          fit: fit,
          imageUrl: image ?? '',
          placeholder:
              (context, url) => Container(
                child:
                    image != null
                        ? Center(child: SizedBox(child: diagonalShimmer(height: height, width: width, borderRadius: borderRadius)))
                        : Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(circular),
                            image: DecorationImage(fit: flag == 1 ? BoxFit.fitHeight : BoxFit.cover, image: AssetImage(placeHolder)),
                          ),
                        ),
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(circular)),
              ),
          errorWidget:
              (context, url, error) => Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circular),
                  image: DecorationImage(fit: flag == 1 ? BoxFit.fitHeight : BoxFit.cover, image: AssetImage(placeHolder)),
                ),
              ),
        ),
      ),
    );
  }
}
