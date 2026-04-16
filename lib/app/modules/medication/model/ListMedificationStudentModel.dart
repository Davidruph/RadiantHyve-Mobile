class ListMedicationStudentModel {
  int? status;
  String? message;
  int? totalMedication;
  int? currentPage;
  int? totalPage;
  List<ListMedicationStudentData>? data;

  ListMedicationStudentModel({this.status, this.message, this.totalMedication, this.currentPage, this.totalPage, this.data});

  ListMedicationStudentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalMedication = json['total_medication'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <ListMedicationStudentData>[];
      json['data'].forEach((v) {
        data!.add(new ListMedicationStudentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_medication'] = this.totalMedication;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListMedicationStudentData {
  int? id;
  int? studentId;
  var mobileNo;
  var countryCode;
  var isoCode;
  var medicationDetails;
  var typeDisease;
  var doctorName;
  var studentName;

  ListMedicationStudentData({this.id, this.studentId, this.mobileNo, this.countryCode, this.isoCode, this.medicationDetails, this.typeDisease, this.doctorName, this.studentName});

  ListMedicationStudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    isoCode = json['iso_code'];
    medicationDetails = json['medication_details'];
    typeDisease = json['type_disease'];
    doctorName = json['doctor_name'];
    studentName = json['student_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['iso_code'] = this.isoCode;
    data['medication_details'] = this.medicationDetails;
    data['type_disease'] = this.typeDisease;
    data['doctor_name'] = this.doctorName;
    data['student_name'] = this.studentName;
    return data;
  }
}
