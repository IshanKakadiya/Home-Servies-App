// ignore_for_file: non_constant_identifier_names

class FeedbackModal {
  dynamic id;
  String Description;
  String Feedback_Date;
  String Feedback_Time;
  String User_Id;
  bool is_Hide;

  FeedbackModal({
    this.id,
    required this.Description,
    required this.Feedback_Date,
    required this.Feedback_Time,
    required this.User_Id,
    required this.is_Hide,
  });

  factory FeedbackModal.fromMap({required Map<String, dynamic> data}) {
    return FeedbackModal(
      id: data['id'],
      Description: data['Description'] ?? "",
      Feedback_Date: data['Feedback_Date'] ?? "",
      Feedback_Time: data['Feedback_Time'] ?? "",
      User_Id: data['User_Id'] ?? "",
      is_Hide: data['is_Hide'] ?? false,
    );
  }
}
