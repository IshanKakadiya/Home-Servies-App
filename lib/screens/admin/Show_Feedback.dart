// ignore_for_file: file_names, unused_local_variable, avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, non_constant_identifier_names, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/helper/cloud_firestore_database_helper.dart';
import 'package:ty_demo_home_services_app/models/Feedback_Model.dart';

import 'package:ty_demo_home_services_app/models/promocode.dart';

class Show_Feedback_Page extends StatefulWidget {
  const Show_Feedback_Page({Key? key}) : super(key: key);

  @override
  State<Show_Feedback_Page> createState() => _Show_Feedback_PageState();
}

class _Show_Feedback_PageState extends State<Show_Feedback_Page> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Feedback"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('Feedback')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FeedbackModal> feedbackData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return FeedbackModal.fromMap(data: data);
            }).toList();

            int number = 1;

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: feedbackData.length,
              separatorBuilder: (context, i) => const SizedBox(height: 15),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Map<String, dynamic> newfeedbackData = {
                                  "id": feedbackData[i].id,
                                  "Description": feedbackData[i].Description,
                                  "Feedback_Date":
                                      feedbackData[i].Feedback_Date,
                                  "Feedback_Time":
                                      feedbackData[i].Feedback_Time,
                                  "is_Hide": feedbackData[i].is_Hide,
                                };

                                await CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper.fireStore
                                    .collection("Feedback")
                                    .doc("${feedbackData[i].id}")
                                    .update(newfeedbackData)
                                    .then((value) async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        (feedbackData[i].is_Hide)
                                            ? "Feedback UnHide Successfully .. "
                                            : "Feedback Hide Successfully .. ",
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }).catchError((e) {
                                  print("Error is $e");
                                });
                                Navigator.of(context).pop();
                              },
                              child: (feedbackData[i].is_Hide)
                                  ? const Text("UNHIDE")
                                  : const Text("HIDE"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Center(child: Text("Delete")),
                                      content: const Text(
                                          "Are You Sure To Delete ?"),
                                      actions: [
                                        OutlinedButton(
                                          child: const Text("Calcle"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        OutlinedButton(
                                          child: const Text("Delete"),
                                          onPressed: () async {
                                            await CloudFireStoreDatabaseHelper
                                                .cloudFireStoreDatabaseHelper
                                                .fireStore
                                                .collection("Feedback")
                                                .doc("${feedbackData[i].id}")
                                                .delete()
                                                .then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("Feedback Deleted"),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }).catchError((e) {
                                              print(e);
                                            });

                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                Navigator.of(context).pop();
                              },
                              child: const Text("DETETE"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("CANCEL"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                          "Number : ${number++}\nDescription : ${feedbackData[i].Description}\nDate : ${feedbackData[i].Feedback_Date}\nTime : ${feedbackData[i].Feedback_Time}\nIs Hide : ${feedbackData[i].is_Hide}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
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
