import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

import '../utils/SizeConstant.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CustomToast extends StatefulWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration duration;
  final bool isError;

  const CustomToast({super.key, required this.message, this.backgroundColor, this.textColor, this.duration = const Duration(seconds: 2), this.isError = true});

  @override
  // ignore: library_private_types_in_public_api
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
    Future.delayed(widget.duration - const Duration(milliseconds: 600), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: IntrinsicWidth(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(10)),
            decoration: BoxDecoration(color: widget.backgroundColor ?? color.appColor, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.isError == true) Icon(Icons.warning_rounded, color: color.white, size: 25.0),
                if (widget.isError == false) CircleAvatar(radius: MySize.getScaledSizeHeight(10), backgroundColor: color.white, child: Icon(Icons.check, size: MySize.getScaledSizeHeight(14))),
                08.0.wSpace(),
                Expanded(
                  child: Text(
                    widget.message,
                    maxLines: 3,
                    style: TextStyle(color: widget.textColor ?? color.white, fontSize: MySize.getScaledSizeHeight(12), fontFamily: "SemiBold"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 10.0),
          ),
        ),
      ),
    );
  }
}

showCustomToast({required String message, Color? backgroundColor, Color? txtColor, bool isError = true}) {
  final overlayState = navigatorKey.currentState?.overlay;

  if (overlayState == null) {
    print("⚠️ Overlay not available. Cannot show toast.");
    return;
  }

  OverlayEntry overlayEntry = OverlayEntry(
    builder:
        (context) => Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: MySize.getScaledSizeHeight(80), right: MySize.getScaledSizeWidth(16), left: MySize.getScaledSizeWidth(16)),
            child: CustomToast(message: message, backgroundColor: backgroundColor, isError: isError, textColor: txtColor),
          ),
        ),
  );

  overlayState.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    try {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    } catch (e) {
      print("⚠️ Error while removing overlayEntry: $e");
    }
  });
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black}) : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 7.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(width: dashWidth, height: dashHeight, child: DecoratedBox(decoration: BoxDecoration(color: color)));
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
