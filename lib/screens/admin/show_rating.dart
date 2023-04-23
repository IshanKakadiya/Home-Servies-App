// ignore_for_file: file_names, unused_local_variable, avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, non_constant_identifier_names, unused_element, depend_on_referenced_packages, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/helper/cloud_firestore_database_helper.dart';
import 'package:ty_demo_home_services_app/models/Feedback_Model.dart';
import 'package:ty_demo_home_services_app/models/rating_model.dart';
import '../../models/userModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Show_Rating_Page extends StatefulWidget {
  const Show_Rating_Page({Key? key}) : super(key: key);

  @override
  State<Show_Rating_Page> createState() => _Show_Rating_PageState();
}

class _Show_Rating_PageState extends State<Show_Rating_Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Review-Rating"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('Rating_Review')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RatingModel> ratingData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              // print("-------------");
              // print(data["userDetails"][1]);
              // print("-------------");
              return RatingModel.fromMap(data: data);
            }).toList();

            int number = 1;

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: ratingData.length,
              separatorBuilder: (context, i) => const SizedBox(height: 15),
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.4),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Number : ${number++}\nUserName : ${ratingData[i].userName}\nEmail: ${ratingData[i].emailId}\nWorker-Name : ${ratingData[i].workerName}\nService-Name : ${ratingData[i].serviceCategoryName}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                        ),
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
                            initialRating: ratingData[i].Rating.toDouble(),
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
                        ],
                      ),
                      Text(
                        "Review : ${(ratingData[i].Review)}\nDate : ${ratingData[i].Date.toDate()}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
