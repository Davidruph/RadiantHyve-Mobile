import 'package:get/get.dart';

class ClassroomDetailsController extends GetxController {

  var isLoading = false.obs;

  List studentsList = [
    {
      'name': 'Dianne Howard',
      'id': '396350',
      'parentsName': 'Esther Howard',
      'class': 'Class1',
    },
    {
      'name': 'Brooklyn Simmons',
      'id': '396350',
      'parentsName': 'Esther Howard',
      'class': 'Class1',
    },
    {
      'name': 'Henry Miles',
      'id': '396350',
      'parentsName': 'Esther Howard',
      'class': 'Class1',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      update();
    });
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
