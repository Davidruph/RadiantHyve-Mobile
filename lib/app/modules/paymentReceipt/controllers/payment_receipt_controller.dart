import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import '../../../../utils/api_custom_toast.dart';
import '../../../../utils/common_color.dart';
import '../../paidFeeDetails/model/ListStudentsInvoiceModel.dart';

class PaymentReceiptController extends GetxController {
  var isLoading = false.obs;
  var isPayment = false;
  var downloadDetails;
  ScreenshotController screenController = ScreenshotController();
  GlobalKey globalKey = GlobalKey();

  var isPdfContentLoading = false.obs;
  ListStudentsInvoiceData? listStudentsInvoiceData;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      listStudentsInvoiceData = Get.arguments['listStudentsInvoiceData'];
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  String getMonthString(int month) {
    const List<String> months = [
      "",
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    if (month < 1 || month > 12) return "";
    return months[month];
  }


  String convertDateFormat(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    return formattedDate;
  }
  Future<void> convertToPdf({required String imagePath}) async {
    isPdfContentLoading.value = true;
    try {
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String sanitizedFileName = path.basename(imagePath).replaceAll(RegExp(r'[^\w\s.-]'), '').replaceAll(' ', '_');
      final String pdfPath = '${directory.path}/payment_$sanitizedFileName.pdf';
      final File pdfFile = File(pdfPath);
      log('directory.path====>${directory.path}');

      // **Check if PDF already exists**
      if (await pdfFile.exists()) {
        isPdfContentLoading.value = false;
        toastyInfo.showToast(message: 'PDF already exists.', backgroundColor: color.primaryColor);
        return;
      }

      // Load the image file as bytes
      Uint8List? imageBytes = await screenController.capture(pixelRatio: 3.0);

      if (imageBytes == null) {
        throw Exception("Failed to capture invoice screenshot.");
      }

      // Create a PDF document
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      // Add image to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain)),
        ),
      );

      await pdfFile.writeAsBytes(await pdf.save());

      isPdfContentLoading.value = false;
      toastyInfo.showToast(message: 'Download successfully: $sanitizedFileName.pdf', backgroundColor: color.primaryColor);
      log('sanitizedFileName===>${sanitizedFileName}');
    } catch (e) {
      isPdfContentLoading.value = false;
      print("Error: $e");
    }
  }

  double screenWidth = MediaQuery.of(Get.context!).size.width;
}
