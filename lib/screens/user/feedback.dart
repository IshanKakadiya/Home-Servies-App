// ignore_for_file: depend_on_referenced_packages, unused_import, unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import '../../utils/GLoble.dart';

class FeedbaackPage extends StatefulWidget {
  const FeedbaackPage({super.key});

  @override
  State<FeedbaackPage> createState() => _FeedbaackPageState();
}

class _FeedbaackPageState extends State<FeedbaackPage> {
  //
  GlobalKey<FormState> feedbackFromKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Give Feedback"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Form(
              key: feedbackFromKey,
              child: TextFormField(
                controller: feedbackController,
                style: GoogleFonts.openSans(
                  color: Colors.white.withOpacity(0.9),
                ),
                cursorColor: Colors.white,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Feedback";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  fillColor: Colors.white.withOpacity(0.4),
                  prefixIcon: Icon(
                    Icons.feedback,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  filled: true,
                  hintText: "Enter Your Feedback",
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  if (feedbackFromKey.currentState!.validate()) {
                    feedbackFromKey.currentState!.save();

                    int id = await CloudFireStoreDatabaseHelper
                        .cloudFireStoreDatabaseHelper
                        .gerCounter(collection: "Feedback_Counter");
                    id = id + 1;

                    User? user = await FirebaseRegistrationHelper
                        .firebaseRegistrationHelper
                        .currentUser();

                    List userDetails = [
                      {"user_id": user!.uid},
                      {"fullName": Globle.name},
                      {"emailId": Globle.email},
                    ];

                    Map<String, dynamic> feedbackDetails = {
                      'id': id,
                      'User_Id': userDetails,
                      'Feedback_Date': DateTime.now(),
                      'Description': feedbackController.text,
                      'is_Hide': false,
                    };

                    await CloudFireStoreDatabaseHelper
                        .cloudFireStoreDatabaseHelper.fireStore
                        .collection("Feedback")
                        .doc("$id")
                        .set(feedbackDetails)
                        .then((value) async {
                      await CloudFireStoreDatabaseHelper
                          .cloudFireStoreDatabaseHelper
                          .setCounter(
                              counter: id, collection: 'Feedback_Counter');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Feedback Added SuccessFully ..."),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'userHomePage', (route) => false);
                    }).catchError((e) {
                      print("Error is $e");
                    });
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
                    "SUBMIT",
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 17,
                    ),
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
