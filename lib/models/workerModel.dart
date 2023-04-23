// ignore_for_file: non_constant_identifier_names

class WorkerModel {
  num? id;
  String imageURL;
  String fullName;
  String password;
  String address;
  String mobileNo;
  String emailId;
  List serviceCategoryList;
  List serviceList;
  num earrings;
  bool is_Active;
  int totalServices;
  int totalRating;
  int totalStar;

  WorkerModel({
    this.id,
    required this.imageURL,
    required this.fullName,
    required this.address,
    required this.mobileNo,
    required this.emailId,
    required this.serviceCategoryList,
    required this.serviceList,
    required this.earrings,
    required this.is_Active,
    required this.password,
    required this.totalServices,
    required this.totalRating,
    required this.totalStar,
  });

  factory WorkerModel.fromMap({required Map<String, dynamic> data}) {
    return WorkerModel(
      id: data['id'],
      imageURL: data['imageURL'],
      fullName: data['fullName'],
      address: data['address'],
      mobileNo: data['mobileNo'],
      emailId: data['emailId'],
      serviceCategoryList: data['serviceCategoryList'],
      serviceList: data['serviceList'],
      earrings: data["earrings"] ?? 0,
      is_Active: data["is_Active"] ?? true,
      password: data["Password"],
      totalServices: data["totalServices"] ?? 0,
      totalRating: data["totalRating"] ?? 0,
      totalStar: data["totalStar"] ?? 0,
    );
  }
}
