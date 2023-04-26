// ignore_for_file: non_constant_identifier_names, file_names

class FeedbackModal {
  dynamic id;
  String Description;
  List User_Id;
  String name;
  String email;
  dynamic Date;
  bool is_Hide;

  FeedbackModal({
    this.id,
    required this.Date,
    required this.name,
    required this.email,
    required this.Description,
    required this.is_Hide,
    required this.User_Id,
  });

  factory FeedbackModal.fromMap({required Map<String, dynamic> data}) {
    return FeedbackModal(
      id: data['id'],
      Date: data['Feedback_Date'] ?? "",
      name: data['User_Id'][1]["fullName"] ?? "",
      email: data['User_Id'][2]["emailId"] ?? "",
      Description: data['Description'] ?? "",
      User_Id: data['User_Id'] ?? "",
      is_Hide: data['is_Hide'] ?? false,
    );
  }
}
