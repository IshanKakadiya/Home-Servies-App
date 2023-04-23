// ignore_for_file: file_names, unnecessary_null_comparison, use_build_context_synchronously, depend_on_referenced_packages, unused_local_variable, camel_case_types, avoid_function_literals_in_foreach_calls, unnecessary_import

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseStorageHelper.dart';
import '../component/ScaffoldMessengerComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Worker_Ragister_Page extends StatefulWidget {
  const Worker_Ragister_Page({super.key});

  @override
  State<Worker_Ragister_Page> createState() => _Worker_Ragister_PageState();
}

class _Worker_Ragister_PageState extends State<Worker_Ragister_Page> {
  TextStyle fontStyle = GoogleFonts.openSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  GlobalKey<FormState> registrationFromKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? address;
  String? fullName;
  String? password;
  String? phone;
  bool showPassword = false;
  String? imageURL;

  List selectedServiceCategoryList = [];
  List selectedServiceList = [];
  List allServiceCategoryList = [];
  List allServiceList = [];

  getServiceCategoryName() async {
    allServiceCategoryList = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection("serviceCategories")
        .get()
        .then((value) => value.docs.map((e) => e.data()['name']).toList());
    setState(() {});
  }

  getServiceName({required String categoryName}) async {
    List res = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection("Service")
        .where('serviceCategoriesName', isEqualTo: categoryName)
        .get()
        .then(
            (value) => value.docs.map((e) => e.data()['serviceName']).toList());

    res.forEach((element) {
      allServiceList.add(element);
    });
  }

  removeServiceName({required String categoryName}) async {
    List res = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection("Service")
        .where('serviceCategoriesName', isEqualTo: categoryName)
        .get()
        .then(
            (value) => value.docs.map((e) => e.data()['serviceName']).toList());

    res.forEach((element) {
      allServiceList.remove(element);
      selectedServiceList.remove(element);
    });
  }

  @override
  void initState() {
    super.initState();
    getServiceCategoryName();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Worker Sign Up",
                      style: GoogleFonts.openSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                  flex: 13,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: (imageURL != null)
                                      ? NetworkImage("$imageURL")
                                      : null,
                                ),
                                Align(
                                  alignment: const Alignment(1.25, 1.25),
                                  child: FloatingActionButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      XFile? pickedImage;
                                      try {
                                        pickedImage = await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );

                                        final String fileName =
                                            path.basename(pickedImage!.path);

                                        File imageFile = File(pickedImage.path);

                                        try {
                                          await FirebaseStorageHelper
                                              .firebaseStorageHelper.storage
                                              .ref(fileName)
                                              .putFile(
                                                imageFile,
                                              );
                                          FirebaseStorageHelper
                                              .firebaseStorageHelper.storage
                                              .ref(fileName)
                                              .getDownloadURL()
                                              .then((value) {
                                            setState(() {
                                              imageURL = value;
                                            });
                                          });

                                          setState(() {});
                                        } on FirebaseException catch (error) {}
                                      } catch (err) {}

                                      setState(() {});
                                    },
                                    mini: true,
                                    child: (imageURL == null)
                                        ? const Icon(Icons.add)
                                        : const Icon(Icons.refresh),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                          key: registrationFromKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: userNameController,
                                style: GoogleFonts.openSans(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                cursorColor: Colors.white,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter User Name";
                                  }

                                  return null;
                                },
                                onSaved: (val) {
                                  fullName = userNameController.text;
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
                                  hintText: "Username",
                                  hintStyle: GoogleFonts.openSans(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
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
                                controller: phoneController,
                                style: GoogleFonts.openSans(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                cursorColor: Colors.white,
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
                                cursorColor: Colors.white,
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
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Categories",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (allServiceCategoryList.isNotEmpty) {
                                        bool? res = await showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: allServiceCategoryList
                                                    .map(
                                                      (e) => TextButton(
                                                        onPressed: () async {
                                                          selectedServiceCategoryList
                                                              .add("$e");

                                                          await getServiceName(
                                                              categoryName: e);

                                                          allServiceCategoryList
                                                              .remove("$e");
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: Text("$e"),
                                                      ),
                                                    )
                                                    .toList()),
                                          ),
                                        );

                                        if (res != null) {
                                          setState(() {});
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.green),
                                    ),
                                    child: const Text("ADD"),
                                  ),
                                ],
                              ),
                              Wrap(
                                spacing: 20,
                                children: selectedServiceCategoryList
                                    .map(
                                      (e) => InputChip(
                                          label: Text("$e"),
                                          onDeleted: () async {
                                            await removeServiceName(
                                                categoryName: e);
                                            setState(() {
                                              selectedServiceCategoryList
                                                  .remove("$e");

                                              allServiceCategoryList.add("$e");
                                            });
                                          }),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Service",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // Spacer(),
                                  // TextButton(onPressed: (){}, child: Text("ADD"),),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (allServiceList.isNotEmpty) {
                                        bool? res = await showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: allServiceList
                                                    .map(
                                                      (e) => TextButton(
                                                        onPressed: () {
                                                          allServiceList
                                                              .remove(e);
                                                          selectedServiceList
                                                              .add(e);

                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: Text("$e"),
                                                      ),
                                                    )
                                                    .toList()),
                                          ),
                                        );

                                        if (res != null) {
                                          setState(() {});
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.green),
                                    ),
                                    child: const Text("ADD"),
                                  ),
                                ],
                              ),
                              Wrap(
                                spacing: 20,
                                children: selectedServiceList
                                    .map(
                                      (e) => InputChip(
                                        label: Text("$e"),
                                        onDeleted: () {
                                          setState(() {
                                            allServiceList.add(e);
                                            selectedServiceList.remove(e);
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1,
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              int id = await CloudFireStoreDatabaseHelper
                                  .cloudFireStoreDatabaseHelper
                                  .gerCounter(collection: "workerCounter");
                              id = id + 1;

                              // print("-------------");
                              // print(id);
                              // print("-------------");

                              QuerySnapshot querySnapshot =
                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("Worker")
                                      .where('emailId',
                                          isEqualTo: emailController.text)
                                      .get();

                              if (registrationFromKey.currentState!
                                      .validate() &&
                                  selectedServiceList.isNotEmpty &&
                                  selectedServiceCategoryList.isNotEmpty &&
                                  imageURL != null &&
                                  querySnapshot.docs.isEmpty) {
                                registrationFromKey.currentState!.save();

                                Map<String, dynamic> workerData = {
                                  'id': id,
                                  "imageURL": imageURL,
                                  'fullName': fullName,
                                  'address': address,
                                  'mobileNo': phone,
                                  'emailId': email,
                                  'Password': password,
                                  "serviceCategoryList":
                                      selectedServiceCategoryList,
                                  "serviceList": selectedServiceList,
                                  'earrings': 0,
                                  'totalRating': 0,
                                  'totalServices': 0,
                                  'totalStar': 0,
                                };

                                await CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper.fireStore
                                    .collection("Worker")
                                    .doc("$id")
                                    .set(workerData)
                                    .then((value) async {
                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper
                                      .setCounter(
                                          counter: id,
                                          collection: 'workerCounter');
                                });

                                scaffoldMessengerComponent(
                                    context: context,
                                    msg: 'Sign Up Successfully...',
                                    color: Colors.green);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'Worker_Login_Page', (route) => false);
                              } else if (imageURL == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("add Image"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (querySnapshot.docs.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "this email-Id is already registered",
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (selectedServiceCategoryList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Add Service"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (selectedServiceList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Add Sub-Service"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
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
                                "Sign Up",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already Have an Account ? ",
                              style: fontStyle.copyWith(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("Worker_Login_Page");
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
                                    .pushReplacementNamed("registrationPage");
                              },
                              child: Text(
                                "Sign up",
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
