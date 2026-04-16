class CertificateListModel {
  int? status;
  String? message;
  int? totalCertificat;
  int? currentPage;
  int? totalPage;
  List<CertificateListData>? certificateListDataData;

  CertificateListModel({
    this.status,
    this.message,
    this.totalCertificat,
    this.currentPage,
    this.totalPage,
    this.certificateListDataData,
  });

  CertificateListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalCertificat = json['total_certificat'];
    currentPage = json['current_page'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      certificateListDataData = <CertificateListData>[];
      json['data'].forEach((v) {
        certificateListDataData!.add(new CertificateListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_certificat'] = this.totalCertificat;
    data['current_page'] = this.currentPage;
    data['totalPage'] = this.totalPage;
    if (this.certificateListDataData != null) {
      data['data'] = this.certificateListDataData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CertificateListData {
  int? id;
  int? staffId;
  String? hireChecklist;
  String? institutionName;
  String? staffName;
  Certificats? certificats;

  CertificateListData({this.id, this.staffId, this.hireChecklist, this.institutionName, this.staffName, this.certificats});

  CertificateListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staff_id'];
    hireChecklist = json['hire_checklist'];
    institutionName = json['institution_name'];
    staffName = json['staff_name'];
    certificats = json['certificats'] != null ? new Certificats.fromJson(json['certificats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['staff_id'] = this.staffId;
    data['hire_checklist'] = this.hireChecklist;
    data['institution_name'] = this.institutionName;
    data['staff_name'] = this.staffName;
    if (this.certificats != null) {
      data['certificats'] = this.certificats!.toJson();
    }
    return data;
  }
}

class Certificats {
  int? id;
  String? fullName;

  Certificats({this.id, this.fullName});

  Certificats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    return data;
  }
}
