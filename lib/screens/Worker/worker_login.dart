// ignore_for_file: file_names, use_build_context_synchronously, unused_local_variable, avoid_print, depend_on_referenced_packages, camel_case_types, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../models/workerModel.dart';
import '../../utils/GLoble.dart';
import '../component/ScaffoldMessengerComponent.dart';

class Worker_Login_Page extends StatefulWidget {
  const Worker_Login_Page({super.key});

  @override
  State<Worker_Login_Page> createState() => _Worker_Login_PageState();
}

class _Worker_Login_PageState extends State<Worker_Login_Page> {
  TextStyle fontStyle = GoogleFonts.openSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  GlobalKey<FormState> loginFromKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;
  bool showPassword = false;

  Future getData({required int workerId}) async {
    await CloudFireStoreDatabaseHelper.cloudFireStoreDatabaseHelper.fireStore
        .collection('Worker')
        .where("id", isEqualTo: workerId)
        .get()
        .then((value) {
      Globle.workerDetails.add(WorkerModel.fromMap(data: value.docs[0].data()));
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              Text(
                "Worker Account\nLogin",
                style: GoogleFonts.openSans(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 70),
              Form(
                key: loginFromKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      style: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      cursorColor: Colors.white,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Email Address";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)) {
                          return "Enter Valid Email";
                        }

                        return null;
                      },
                      onSaved: (val) {
                        email = emailController.text;
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
                          Icons.email,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        hintText: "Email",
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      style: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      cursorColor: Colors.white,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Password";
                        }

                        return null;
                      },
                      onSaved: (val) {
                        password = passwordController.text;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: (showPassword) ? false : true,
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
                          Icons.lock,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: (showPassword)
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.white,
                                ),
                          onPressed: () {
                            showPassword = !showPassword;
                            setState(() {});
                          },
                        ),
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () async {
                        if (loginFromKey.currentState!.validate()) {
                          loginFromKey.currentState!.save();

                          Globle.workerId = 0;

                          QuerySnapshot querySnapshot =
                              await CloudFireStoreDatabaseHelper
                                  .cloudFireStoreDatabaseHelper.fireStore
                                  .collection("Worker")
                                  .where('emailId', isEqualTo: email)
                                  .where('Password', isEqualTo: password)
                                  .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            Globle.workerDetails = [];
                            Globle.workerId =
                                int.parse(querySnapshot.docs[0].id);

                            await getData(workerId: Globle.workerId);

                            // print("-------");
                            // print(Globle.workerDetails);
                            // print(email);
                            // print(password);
                            // print(Globle.workerId);
                            // print("-------");

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'Worker_Home_Page', (route) => false);
                          } else {
                            scaffoldMessengerComponent(
                              context: context,
                              msg: 'Login Failed...',
                              color: Colors.red,
                            );
                          }
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
                          "Login",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 180),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have a account? ",
                          style: fontStyle.copyWith(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("Worker_Ragister_Page");
                          },
                          child: Text(
                            "Worker Sign up",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.white,
                      thickness: 2,
                      indent: 120,
                      endIndent: 120,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "User ? ",
                          style: fontStyle.copyWith(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("loginPage");
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      color: Colors.white,
                      thickness: 2,
                      indent: 120,
                      endIndent: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
