// ignore: file_names
// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/models/userModel.dart';
import 'package:ty_demo_home_services_app/models/workerModel.dart';
import '../../../helper/cloud_firestore_database_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: camel_case_types
class Wroker_Details_Page extends StatefulWidget {
  const Wroker_Details_Page({super.key});

  @override
  State<Wroker_Details_Page> createState() => _Wroker_Details_PageState();
}

// ignore: camel_case_types
class _Wroker_Details_PageState extends State<Wroker_Details_Page> {
  bool onOff = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Worker Details Page"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('Worker')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<WorkerModel> userData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return WorkerModel.fromMap(data: data);
            }).toList();

            int i = 1;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: userData.map<Widget>((e) {
                  double rating =
                      (e.totalStar != 0) ? (e.totalStar / e.totalRating) : 0;
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
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "NO : ${i++}\nName : ${e.fullName}\nEmail : ${e.emailId}\nAddress : ${e.address}\nMo.No : ${e.mobileNo}\nTotal Completed Services : ${e.totalServices}",
                                style: GoogleFonts.openSans(),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Rating : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 15,
                                    ),
                                  ),
                                  RatingBar.builder(
                                    itemSize: 15,
                                    initialRating: rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  Text(
                                    "  | ${e.totalRating} Person",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              // Text(
                              //   "Account Status : ${(e.is_Active) ? "Enable" : "Disable"}",
                              //   style: GoogleFonts.openSans(),
                              // ),
                            ],
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
