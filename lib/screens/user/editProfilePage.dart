// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, unused_local_variable, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> editFromKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? userName;
  String? email;

  String? address;
  String? password;
  String? phone;
  User? user;
  bool isSignWithGoogle = false;
  String? docId;

  // String? address;
  // String? password;
  // String? phone;

  fetchData() async {
    user = await FirebaseRegistrationHelper.firebaseRegistrationHelper
        .currentUser();

    isSignWithGoogle = user!.providerData[0].providerId == "google.com";

    print("----------------");
    print(isSignWithGoogle);
    print("----------------");

    userNameController.text = user!.displayName as String;
    emailController.text = user!.email as String;

    if (emailController.text != "ishankakadiya7@gmail.com") {
      QuerySnapshot querySnapshot = await CloudFireStoreDatabaseHelper
          .cloudFireStoreDatabaseHelper.fireStore
          .collection("User")
          .where('id', isEqualTo: user!.uid)
          .get();

      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs[0];
      docId = querySnapshot.docs[0].id;

      Map<String, dynamic> userData =
          queryDocumentSnapshot.data() as Map<String, dynamic>;

      try {
        phoneController.text = userData['mobileNo']!;
      } catch (e) {
        print("-----------------");
        print("Throws Exception");
        print("-----------------");
      }

      try {
        passwordController.text = userData['password']!;
      } catch (e) {
        print("-----------------");
        print("Throws Exception");
        print("-----------------");
      }

      try {
        addressController.text = userData['address']!;
      } catch (e) {
        print("-----------------");
        print("Throws Exception");
        print("-----------------");
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Info & Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Form(
            key: editFromKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    controller: userNameController,
                    style: GoogleFonts.openSans(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    cursorColor: Colors.white,
                    enabled:
                        (emailController.text == "ishankakadiya7@gmail.com")
                            ? false
                            : true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter User Name";
                      }

                      return null;
                    },
                    onSaved: (val) {
                      userName = userNameController.text;
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
                        Icons.person,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      filled: true,
                      hintText: "UserName",
                      hintStyle: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    enabled: false,
                    controller: emailController,
                    style: GoogleFonts.openSans(
                      color: Colors.white.withOpacity(0.9),
                    ),
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
                  (emailController.text != "ishankakadiya7@gmail.com")
                      ? Column(
                          children: [
                            TextFormField(
                              controller: phoneController,
                              style: GoogleFonts.openSans(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter Phone Number";
                                } else if (val.length != 10) {
                                  return "Enter Valid Phone Number";
                                }

                                return null;
                              },
                              onSaved: (val) {
                                phone = phoneController.text;
                              },
                              keyboardType: TextInputType.phone,
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
                                  Icons.phone,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                filled: true,
                                hintText: "Phone",
                                hintStyle: GoogleFonts.openSans(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: addressController,
                              style: GoogleFonts.openSans(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter Address";
                                }

                                return null;
                              },
                              onSaved: (val) {
                                address = addressController.text;
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
                                  Icons.location_on_outlined,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                filled: true,
                                hintText: "Address",
                                hintStyle: GoogleFonts.openSans(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            (isSignWithGoogle == false)
                                ? TextFormField(
                                    controller: passwordController,
                                    style: GoogleFonts.openSans(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter Password";
                                      } else if (val.length < 6 ||
                                          val.length > 10) {
                                        return "Password Length Must be 6-10";
                                      }

                                      return null;
                                    },
                                    onSaved: (val) {
                                      password = passwordController.text;
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      fillColor: Colors.white.withOpacity(0.4),
                                      prefixIcon: Icon(
                                        Icons.lock_open,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      filled: true,
                                      hintText: "Password",
                                      hintStyle: GoogleFonts.openSans(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 25,
                  ),
                  (emailController.text == "ishankakadiya7@gmail.com")
                      ? Container()
                      : InkWell(
                          onTap: () async {
                            if (editFromKey.currentState!.validate()) {
                              editFromKey.currentState!.save();

                              try {
                                await FirebaseRegistrationHelper
                                    .firebaseRegistrationHelper
                                    .updateEmail(email: email!);
                                await FirebaseRegistrationHelper
                                    .firebaseRegistrationHelper
                                    .updateUserName(name: userName!);

                                Map<String, dynamic> userMapData = {
                                  'id': user!.uid,
                                  'fullName': userName,
                                  'address': address,
                                  'mobileNo': phone,
                                  'emailId': email,
                                  'password': password,
                                  'userStatus': true,
                                };

                                await CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper.fireStore
                                    .collection('User')
                                    .doc(docId)
                                    .set(userMapData);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Profile Update Successfully ..."),
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
                            }
                          },
                          child: Container(
                            height: 45,
                            width: width * 0.44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 153, 119, 247),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "UPDATE",
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
          ),
        ],
      ),
    );
  }
}
