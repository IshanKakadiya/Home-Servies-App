// ignore: file_names
// ignore_for_file: unused_local_variable, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/models/bookingTransactionModel.dart';
import '../../helper/cloud_firestore_database_helper.dart';

// ignore: camel_case_types
class Total_Booked_Service_Page extends StatefulWidget {
  const Total_Booked_Service_Page({super.key});

  @override
  State<Total_Booked_Service_Page> createState() =>
      _Total_Booked_Service_PageState();
}

// ignore: camel_case_types
class _Total_Booked_Service_PageState extends State<Total_Booked_Service_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Total Booking Service"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('bookingTransaction')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BookingTransactionModel> bookingData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return BookingTransactionModel.fromMap(data: data);
            }).toList();

            int i = 1;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: bookingData.map<Widget>((e) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No : ${i++}\nUser-Name : ${e.userName}\nEmail-Id : ${e.emailId}\nService-Name : ${e.serviceCategoryName}\nWorker-Name : ${e.workerName}\nAmount : ${e.amount}\nPlatform Charges : ${e.platformCharges}\nTotal Minute : ${e.totalHours} Minute\nDate : ${e.formatDate}\nTime : ${e.formatTime}\nAddress : ${e.address}",
                            style: GoogleFonts.openSans(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
