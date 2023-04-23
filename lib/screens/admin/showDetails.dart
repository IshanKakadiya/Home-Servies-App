// ignore: file_names
// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/models/userModel.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';

// ignore: camel_case_types
class Detail_Page extends StatefulWidget {
  const Detail_Page({super.key});

  @override
  State<Detail_Page> createState() => _Detail_PageState();
}

// ignore: camel_case_types
class _Detail_PageState extends State<Detail_Page> {
  bool onOff = true;

  @override
  Widget build(BuildContext context) {
    int i = 1;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("User Details Page"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('User')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> userData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return UserModel.fromMap(data: data);
            }).toList();

            int i = 1;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: userData.map<Widget>((e) {
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
                                "NO : ${i++}\nName : ${e.fullName}\nEmail : ${e.emailId}\nAddress : ${e.address}\nMo.No : ${e.mobileNo}\nAccount Status : ${(e.is_Active) ? "Enable" : "Disable"}",
                                style: GoogleFonts.openSans(),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton(
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(
                                          Icons.drive_file_rename_outline),
                                      const SizedBox(
                                        // sized box with width 10
                                        width: 10,
                                      ),
                                      Text(
                                        (e.is_Active)
                                            ? "Diable Account"
                                            : "Enable Account",
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (val) async {
                                if (val == 1) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Center(child: Text("Delete")),
                                        content: Text(
                                          (e.is_Active)
                                              ? "Are You Sure To Diable Account ?"
                                              : "Are You Sure To Enable Account ?",
                                        ),
                                        actions: [
                                          OutlinedButton(
                                            child: const Text("Calcle"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          OutlinedButton(
                                            child: Text(
                                              (e.is_Active)
                                                  ? "Diable"
                                                  : "Enable",
                                            ),
                                            onPressed: () async {
                                              print("---------");
                                              print(e.is_Active);
                                              print("---------");

                                              Map<String, dynamic> userMapData =
                                                  {
                                                'id': e.id,
                                                'fullName': e.fullName,
                                                'address': e.address,
                                                'mobileNo': e.mobileNo,
                                                'emailId': e.emailId,
                                                'password': e.password,
                                                'userStatus': (e.is_Active)
                                                    ? false
                                                    : true,
                                              };

                                              await CloudFireStoreDatabaseHelper
                                                  .cloudFireStoreDatabaseHelper
                                                  .fireStore
                                                  .collection("User")
                                                  .doc("${e.id}")
                                                  .set(userMapData)
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      (e.is_Active)
                                                          ? "Account Disable Successfully ..."
                                                          : "Account Enable Successfully ...",
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        (e.is_Active)
                                                            ? Colors.red
                                                            : Colors.green,
                                                  ),
                                                );
                                              }).catchError((e) {
                                                print(e);
                                              });

                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          )
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
