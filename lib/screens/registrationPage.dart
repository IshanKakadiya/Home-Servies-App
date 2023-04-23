// ignore_for_file: file_names, unnecessary_null_comparison, use_build_context_synchronously, depend_on_referenced_packages, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

import '../helper/cloud_firestore_database_helper.dart';
import '../helper/firebaseRegistrationHelper.dart';
import 'component/ScaffoldMessengerComponent.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                "Sign Up",
                style: GoogleFonts.openSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
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
                        } else if (val.length < 6 || val.length > 10) {
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
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    if (registrationFromKey.currentState!.validate()) {
                      registrationFromKey.currentState!.save();

                      try {
                        User? user = await FirebaseRegistrationHelper
                            .firebaseRegistrationHelper
                            .signUp(email: email!, password: password!);

                        Map<String, dynamic> userMapData = {
                          'id': user!.uid,
                          'fullName': fullName,
                          'address': address,
                          'mobileNo': phone,
                          'emailId': email,
                          'password': password,
                          'userStatus': true,
                        };

                        await CloudFireStoreDatabaseHelper
                            .cloudFireStoreDatabaseHelper.fireStore
                            .collection('User')
                            .doc(user.uid)
                            .set(userMapData);

                        await FirebaseRegistrationHelper
                            .firebaseRegistrationHelper
                            .updateUserName(name: fullName!);

                        if (user != null) {
                          scaffoldMessengerComponent(
                              context: context,
                              msg: 'Sign Up Successfully...',
                              color: Colors.green);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              'loginPage', (route) => false);
                        } else {
                          scaffoldMessengerComponent(
                              context: context,
                              msg: 'Sign-Up Failed...',
                              color: Colors.red);
                        }
                      } on FirebaseAuthException catch (e) {
                        scaffoldMessengerComponent(
                            context: context,
                            msg: e.message!,
                            color: Colors.red);
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
                height: 60,
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
                      Navigator.of(context).pushReplacementNamed("loginPage");
                    },
                    child: Text(
                      "User Login",
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
                    "Worker ? ",
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
            ],
          ),
        ),
      ),
    );
  }
}
