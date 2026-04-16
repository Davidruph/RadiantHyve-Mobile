class MedicationModel {
  int? status;
  String? message;
  List<MedicationData>? data;

  MedicationModel({this.status, this.message, this.data});

  MedicationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MedicationData>[];
      json['data'].forEach((v) {
        data!.add(new MedicationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicationData {
  int? id;
  var typeDisease;
  var medicationDetails;
  var doctorName;
  var isoCode;
  var countryCode;
  var mobileNo;
  var adminId;
  var schoolId;
  var studentId;
  var createdAt;
  var updatedAt;
  var studentName;

  MedicationData({
    this.id,
    this.typeDisease,
    this.medicationDetails,
    this.doctorName,
    this.isoCode,
    this.countryCode,
    this.mobileNo,
    this.adminId,
    this.schoolId,
    this.studentId,
    this.createdAt,
    this.updatedAt,
    this.studentName,
  });

  MedicationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeDisease = json['type_disease'];
    medicationDetails = json['medication_details'];
    doctorName = json['doctor_name'];
    isoCode = json['iso_code'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    adminId = json['admin_id'];
    schoolId = json['school_id'];
    studentId = json['student_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    studentName = json['student_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_disease'] = this.typeDisease;
    data['medication_details'] = this.medicationDetails;
    data['doctor_name'] = this.doctorName;
    data['iso_code'] = this.isoCode;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    data['admin_id'] = this.adminId;
    data['school_id'] = this.schoolId;
    data['student_id'] = this.studentId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['student_name'] = this.studentName;
    return data;
  }
}
