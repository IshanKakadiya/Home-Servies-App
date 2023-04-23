// ignore_for_file: file_names, non_constant_identifier_names

class UserModel {
  String? id;
  String? fullName;
  String? address;
  String? mobileNo;
  String? emailId;
  String? password;
  bool is_Active;

  UserModel(
      {this.id,
      required this.fullName,
      required this.address,
      required this.mobileNo,
      required this.emailId,
      required this.password,
      required this.is_Active});

  factory UserModel.fromMap({required Map<String, dynamic> data}) {
    return UserModel(
      id: data['id'],
      fullName: data['fullName'],
      address: data['address'] ?? "",
      mobileNo: data['mobileNo'] ?? "",
      emailId: data['emailId'] ?? "",
      password: data['password'] ?? "",
      is_Active: data['userStatus'] ?? true,
    );
  }
}
