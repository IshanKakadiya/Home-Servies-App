// ignore_for_file: camel_case_types, unused_local_variable, nullable_type_in_catch_clause, use_build_context_synchronously, non_constant_identifier_names, unused_import, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import '../../models/rating_model.dart';
import '../../utils/GLoble.dart';

class Add_Review_Rating_Page extends StatefulWidget {
  const Add_Review_Rating_Page({super.key});

  @override
  State<Add_Review_Rating_Page> createState() => _Add_Review_Rating_PageState();
}

class _Add_Review_Rating_PageState extends State<Add_Review_Rating_Page>
    with SingleTickerProviderStateMixin {
  int rating = 0;
  int click = 0;
  List star = [
    {
      "id": 1,
      "color": false,
    },
    {
      "id": 2,
      "color": false,
    },
    {
      "id": 3,
      "color": false,
    },
    {
      "id": 4,
      "color": false,
    },
    {
      "id": 5,
      "color": false,
    }
  ];

  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reviewController.text = Globle.review;
    rating = Globle.rating;
    click = Globle.rating;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: (Globle.rating == 0)
            ? const Text("Add Review & Rating")
            : const Text("Edit Review & Rating"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  Globle.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: star.map(
                  (e) {
                    for (int i = 0; i < click; i++) {
                      star[i]["color"] = true;
                    }

                    return Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            (e["color"]) ? Icons.star : Icons.star_border,
                            color: (e["color"])
                                ? Colors.black
                                : Colors.black.withOpacity(0.3),
                            size: 50,
                          ),
                          onPressed: () {
                            for (int i = 0; i < 5; i++) {
                              star[i]["color"] = false;
                            }

                            click = e["id"];

                            rating = e["id"];

                            setState(() {});
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: reviewController,
              maxLength: 500,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Describe your experience (optional)",
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                if (rating != 0) {
                  try {
                    User? user = await FirebaseRegistrationHelper
                        .firebaseRegistrationHelper
                        .currentUser();

                    QuerySnapshot querySnapshot =
                        await CloudFireStoreDatabaseHelper
                            .cloudFireStoreDatabaseHelper.fireStore
                            .collection("bookingTransaction")
                            .where('id', isEqualTo: Globle.booking_id)
                            .get();

                    QueryDocumentSnapshot queryDocumentSnapshot =
                        querySnapshot.docs[0];

                    Map<String, dynamic> userData =
                        queryDocumentSnapshot.data() as Map<String, dynamic>;

                    Map<String, dynamic> workerDetails = {};

                    int workerId = 0;

                    await CloudFireStoreDatabaseHelper
                        .cloudFireStoreDatabaseHelper.fireStore
                        .collection('Worker')
                        .where('id', isEqualTo: userData["workerId"])
                        .get()
                        .then((value) {
                      value.docs.forEach((e) {
                        workerId = e.data()["id"];
                        workerDetails = {
                          'earrings': e.data()["earrings"],
                          'Password': e.data()["Password"],
                          'address': e.data()["address"],
                          'totalServices': e.data()["totalServices"],
                          'emailId': e.data()["emailId"],
                          'fullName': e.data()["fullName"],
                          'id': e.data()["id"],
                          'imageURL': e.data()["imageURL"],
                          'is_Active': e.data()["is_Active"],
                          'mobileNo': e.data()["mobileNo"],
                          'serviceList': e.data()["serviceList"],
                          'serviceCategoryList':
                              e.data()["serviceCategoryList"],
                          'totalRating': (Globle.rating == 0)
                              ? (++e.data()["totalRating"])
                              : e.data()["totalRating"],
                          'totalStar':
                              ((e.data()["totalStar"] - Globle.rating) +
                                  rating),
                        };
                      });
                    });

                    Map<String, dynamic> userMapData = {
                      'User_id': user!.uid,
                      'Booking_id': Globle.booking_id,
                      'Date': DateTime.now(),
                      'Review': reviewController.text,
                      'Rating': rating,
                      'Is_Display': true,
                      'userDetails': userData["userDetails"],
                      'serviceCategoryName': userData["serviceCategoryName"],
                      'workerName': userData["workerName"],
                      'workerId': userData["workerId"],
                      'amount': userData["amount"],
                      'formatDate': userData["formatDate"],
                      'formatTime': userData["formatTime"],
                      'totalMinute': userData["totalHours"],
                    };

                    await CloudFireStoreDatabaseHelper
                        .cloudFireStoreDatabaseHelper.fireStore
                        .collection("Worker")
                        .doc("$workerId")
                        .set(workerDetails)
                        .then((value) async {})
                        .catchError((e) {});

                    if (Globle.booking_docId != "") {
                      await CloudFireStoreDatabaseHelper
                          .cloudFireStoreDatabaseHelper.fireStore
                          .collection('Rating_Review')
                          .doc(Globle.booking_docId)
                          .set(userMapData);
                    } else {
                      await CloudFireStoreDatabaseHelper
                          .cloudFireStoreDatabaseHelper.fireStore
                          .collection('Rating_Review')
                          .add(userMapData);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text((Globle.booking_docId != "")
                            ? "Review Update Successfully ..."
                            : "Review Post Successfully ..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'userHomePage', (route) => false);
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message!),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Rating Not Posted"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                height: 45,
                width: width * 0.44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (Globle.rating == 0) ? "ADD" : "UPDATE",
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
