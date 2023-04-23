// ignore: file_names
// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingTransactionModel {
  int? id;
  int workerId;
  String userId;
  int serviceId;
  String booking_Status_id;
  int platformCharges;
  int amount;
  num totalHours;
  DateTime date;
  List time;
  String formatDate;
  String formatTime;
  String Complete_Date;
  String Complete_Time;
  String Payment_type;
  String Service_Date;
  String Service_Time;
  String userName;
  String emailId;
  String mobileNo;
  String address;
  String serviceCategoryName;
  String workerName;

  BookingTransactionModel({
    this.id,
    required this.workerId,
    required this.userId,
    required this.serviceId,
    required this.serviceCategoryName,
    required this.platformCharges,
    required this.amount,
    required this.date,
    required this.time,
    required this.totalHours,
    required this.Complete_Date,
    required this.Complete_Time,
    required this.Payment_type,
    required this.Service_Date,
    required this.Service_Time,
    required this.address,
    required this.booking_Status_id,
    required this.formatDate,
    required this.formatTime,
    required this.userName,
    required this.workerName,
    required this.emailId,
    required this.mobileNo,
  });

  factory BookingTransactionModel.fromMap({required Map data}) {
    Timestamp time = data['date'] as Timestamp;
    DateTime dateTime = DateTime.parse(time.toDate().toString());
    return BookingTransactionModel(
      id: data['id'],
      workerId: data['workerId'],
      userId: data['userId'],
      serviceId: data['serviceId'],
      platformCharges: data['platformCharges'],
      amount: data['amount'],
      date: dateTime,
      time: data['time'],
      totalHours: data['totalHours'],
      Complete_Date: data['Complete_Date'] ?? "",
      Complete_Time: data['Complete_Time'] ?? "",
      Payment_type: data['Payment_type'] ?? "",
      Service_Date: data['Service_Date'] ?? "",
      Service_Time: data['Service_Time'] ?? "",
      booking_Status_id: data['booking_Status_id'] ?? "",
      formatDate: data["formatDate"],
      formatTime: data["formatTime"],
      userName: data["userDetails"][0]["fullName"],
      emailId: data["userDetails"][1]["emailId"],
      mobileNo: data["userDetails"][2]["mobileNo"],
      address: data["userDetails"][3]["address"],
      serviceCategoryName: data["serviceCategoryName"],
      workerName: data["workerName"] ?? "",
    );
  }
}
