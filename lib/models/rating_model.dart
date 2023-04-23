// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  dynamic id;
  dynamic User_id;
  dynamic Booking_id;
  int Rating;
  String Review;
  Timestamp Date;
  bool Is_Display;
  String userName;
  String emailId;
  String mobileNo;
  String address;
  String serviceCategoryName;
  String workerName;
  String formateDate;
  String formateTime;
  int amount;
  int totalMinute;

  RatingModel({
    this.id,
    required this.User_id,
    required this.Booking_id,
    required this.Rating,
    required this.Review,
    required this.Date,
    required this.Is_Display,
    required this.userName,
    required this.address,
    required this.emailId,
    required this.mobileNo,
    required this.serviceCategoryName,
    required this.workerName,
    required this.amount,
    required this.formateDate,
    required this.formateTime,
    required this.totalMinute,
  });

  factory RatingModel.fromMap({required Map<String, dynamic> data}) {
    return RatingModel(
      id: data["id"] ?? "",
      User_id: data["User_id"] ?? "",
      Booking_id: data["Booking_id"] ?? "",
      Rating: data["Rating"] ?? 5,
      Review: data["Review"] ?? "",
      Date: data["Date"] ?? "",
      Is_Display: data["Is_Display"] ?? true,
      userName: data["userDetails"][0]["fullName"],
      emailId: data["userDetails"][1]["emailId"],
      mobileNo: data["userDetails"][2]["mobileNo"],
      address: data["userDetails"][3]["address"],
      serviceCategoryName: data["serviceCategoryName"],
      workerName: data["workerName"] ?? "",
      amount: data["amount"],
      formateDate: data["formatDate"],
      formateTime: data["formatTime"],
      totalMinute: data["totalMinute"],
    );
  }
}
