import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radianthyve_unified/commonWidgets/common_widgets.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

import '../../../../commonWidgets/commonPermissionHandler.dart';

class StudentEditProfileController extends GetxController {
  var errorImage = ''.obs;

  /// Full Name
  TextEditingController fullNameController = TextEditingController();
  var isSelect = 0.obs;
  var errorFullName = ''.obs;

  /// Parents Name
  TextEditingController parentsNameController = TextEditingController();
  var errorParentsName = ''.obs;

  /// Home Phone Number
  TextEditingController homePhoneNumberController = TextEditingController();
  String isoCode = 'US';
  String countryCode = '+1';
  var countryFlag = "🇺🇸";
  var maxLength = 10.obs;
  var errorHomePhoneNumber = ''.obs;
  var isValidmobileNo = 0.obs;
  var isphone = true.obs;

  /// Date of Birth
  TextEditingController dateOfBirthController = TextEditingController();
  DateTime? birthDate;
  var dateOfBirth = ''.obs;
  var errorDateOfBirth = ''.obs;

  /// Relation to child
  TextEditingController relationToChildController = TextEditingController();
  var errorRelationToChild = ''.obs;

  /// Medical Insurance Number
  TextEditingController medicalInsuranceNumberController = TextEditingController();
  var errorMedicalInsuranceNumber = ''.obs;

  /// Address
  TextEditingController addressController = TextEditingController();
  var errorAddress = ''.obs;

  var flag;
  var profile;

  var image = ''.obs;
  final ImagePicker mediaPicker = ImagePicker();

  pickMedia({required int argument}) async {
    Permission permission;
    int sdkInt = 36;
    if (Platform.isIOS) {
      permission = argument == 1 ? Permission.camera : Permission.photos;
    } else {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      sdkInt = androidInfo.version.sdkInt;
      if (argument == 1) {
        permission = Permission.camera;
      } else {
        permission = sdkInt <= 32 ? Permission.storage : Permission.photos;
      }
    }
    bool granted = true;
    if (argument == 1) {
      granted = await commonPermissionsHandler(permission: permission);
    } else {
      if (Platform.isAndroid && sdkInt > 32) {
        granted = true;
      } else {
        granted = await commonPermissionsHandler(permission: permission);
      }
    }
    if (granted) {
      final pickedFile = await mediaPicker.pickImage(source: argument == 1 ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final double fileSizeInMB = await imageFile.length() / (1024 * 1024);
        if (!_isImageFile(pickedFile.path)) return;
        if (fileSizeInMB > 10) return;
        image.value = pickedFile.path ?? '';
        update();
      }
    }
  }

  bool _isImageFile(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') || filePath.toLowerCase().endsWith('.jpeg') || filePath.toLowerCase().endsWith('.png');
  }

  var errorGender = ''.obs;
  var errorFrequencyAttendance = ''.obs;
  var errorAssignedStaff = ''.obs;

  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];

  String? selectedFrequencyAttendance;
  List<String> frequencyAttendanceList = ['Half Day - Morning', 'Half Day - Afternoon'];

  String? selectedAssignedStaff;
  List<String> assignedStaffList = ['Ronald Richards', 'Marvin McKinney', 'Courtney Henry'];

  Future dateOfBirthCalendar(BuildContext context) async {
    birthDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color.appColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: color.appColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (birthDate != null) {
      dateOfBirth.value = birthDate.toString();
      dateOfBirthController.text = commonWidget.formatDateByCountry(
        DateTime.parse(dateOfBirth.value),
        WidgetsBinding.instance.window.locale.countryCode ?? "GB",
      );
      errorDateOfBirth.value = '';
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fullNameController.text = 'Dianne Howard';
    parentsNameController.text = 'Esther Howard';
    homePhoneNumberController.text = '9876554321';
    dateOfBirthController.text = '22/10/2024';
    selectedGender = 'Male';
    relationToChildController.text = 'Son';
    selectedFrequencyAttendance = 'Half Day - Morning';
    medicalInsuranceNumberController.text = '999-99-9999';
    addressController.text = '3891 Preston Rd., South Dakota, California 62639';
    selectedAssignedStaff = 'Ronald Richards';
    profile = images.profileImage3;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isValidation() {
    errorFullName.value = '';
    errorParentsName.value = '';
    errorHomePhoneNumber.value = '';
    errorDateOfBirth.value = '';
    errorGender.value = '';
    errorRelationToChild.value = '';
    errorFrequencyAttendance.value = '';
    errorMedicalInsuranceNumber.value = '';
    errorAddress.value = '';
    errorAssignedStaff.value = '';
    // errorImage.value = '';

    bool isValid = true;

    // if (image == '') {
    //   errorImage.value = 'Please Select Your Profile Image.';
    //   isValid = false;
    // }
    if (fullNameController.text.trim().isEmpty) {
      errorFullName.value = 'Please enter your full name.';
      isValid = false;
    }
    if (parentsNameController.text.trim().isEmpty) {
      errorParentsName.value = 'Please enter your Parents name.';
      isValid = false;
    }
    if (homePhoneNumberController.text.trim().isEmpty) {
      errorHomePhoneNumber.value = 'Please enter your home phone number.';
      isValid = false;
    }
    if (homePhoneNumberController.text.trim().isNotEmpty && maxLength.value != homePhoneNumberController.text.length) {
      isValid = false;
      errorHomePhoneNumber.value = 'Please Enter Valid Mobile Number.'.tr;
    }
    if (dateOfBirthController.text.trim().isEmpty) {
      errorDateOfBirth.value = 'Please select your birth date.';
      isValid = false;
    }
    if (selectedGender == null) {
      errorGender.value = 'Please select your gender.';
      isValid = false;
    }
    if (relationToChildController.text.trim().isEmpty) {
      errorRelationToChild.value = 'Please select your relation.';
      isValid = false;
    }
    if (selectedFrequencyAttendance == null) {
      errorFrequencyAttendance.value = 'Please select your frequency attendance.';
      isValid = false;
    }
    if (medicalInsuranceNumberController.text.trim().isEmpty) {
      errorMedicalInsuranceNumber.value = "Please enter medical insurance number.";
      isValid = false;
    }
    if (addressController.text.trim().isEmpty) {
      errorAddress.value = "Please enter your address.";
      isValid = false;
    }
    if (selectedAssignedStaff == null) {
      errorAssignedStaff.value = 'Please select staff.';
      isValid = false;
    }
    return isValid;
  }
}
