import 'package:get/get.dart';

class ParentsReminderController extends GetxController {

  var title ='';
  var body ='';

  @override
  void onInit() {
    if(Get.arguments != null){
      title =Get.arguments['title'];
      body =Get.arguments['body'];
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
