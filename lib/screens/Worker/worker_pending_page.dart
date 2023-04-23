// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print, unused_local_variable, unused_element, depend_on_referenced_packages, camel_case_types, unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/utils/GLoble.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import '../../models/bookingTransactionModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import '../../models/rating_model.dart';

class Worker_Pading_Page extends StatefulWidget {
  const Worker_Pading_Page({super.key});

  @override
  State<Worker_Pading_Page> createState() => _Worker_Pading_PageState();
}

class _Worker_Pading_PageState extends State<Worker_Pading_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Service"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('bookingTransaction')
            .where("workerId", isEqualTo: Globle.workerDetails[0].id)
            .where('date', isGreaterThan: DateTime.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BookingTransactionModel> data =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return BookingTransactionModel.fromMap(data: data);
            }).toList();

            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, i) => const SizedBox(height: 5),
              itemBuilder: (context, i) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[i].serviceCategoryName,
                        style: GoogleFonts.openSans(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const CircleAvatar(),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[i].userName,
                                style: GoogleFonts.openSans(),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                data[i].formatDate,
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.watch_later_rounded,
                                    size: 17,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${data[i].totalHours} Minute",
                                    style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    data[i].formatTime,
                                    style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "  \u{20B9} ${(data[i].amount)}",
                            style: GoogleFonts.openSans(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
