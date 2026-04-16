import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';


String deviceId = '';
var deviceToken;

final box = GetStorage();

shareAppLink({required String linkUrl, String? subject}) async {
  Share.share(
    linkUrl,
    subject: subject ?? '',
  );
}

class CommonLoader extends StatelessWidget {
  final double size;
  final Color color;

  const CommonLoader({
    Key? key,
    this.size = 20.0,
    this.color = const Color(0xff293FE3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(color: color, size: size);
  }
}

