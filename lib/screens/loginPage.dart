// ignore_for_file: file_names, use_build_context_synchronously, unused_local_variable, avoid_print, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import '../helper/cloud_firestore_database_helper.dart';
import '../helper/firebaseRegistrationHelper.dart';
import 'component/ScaffoldMessengerComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

setSpalshScreenData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('spalshSee', false);
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  void initState() {
    super.initState();
    setSpalshScreenData();
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
                "Create Your \nAccount",
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

                          try {
                            User? user = await FirebaseRegistrationHelper
                                .firebaseRegistrationHelper
                                .signIn(email: email!, password: password!);

                            if (user != null) {
                              QuerySnapshot querySnapshot =
                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection('admin')
                                      .where('adminUId',
                                          arrayContains: user.uid)
                                      .get();

                              if (querySnapshot.docs.length == 1) {
                                scaffoldMessengerComponent(
                                  context: context,
                                  msg: 'Log In Successfully...',
                                  color: Colors.green,
                                );

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'adminHomePage', (route) => false);
                              } else {
                                QuerySnapshot querySnapshot =
                                    await CloudFireStoreDatabaseHelper
                                        .cloudFireStoreDatabaseHelper.fireStore
                                        .collection("User")
                                        .where('id', isEqualTo: user.uid)
                                        .get();

                                Map<String, dynamic> userData =
                                    querySnapshot.docs[0].data()
                                        as Map<String, dynamic>;

                                if (userData["userStatus"] == false) {
                                  scaffoldMessengerComponent(
                                    context: context,
                                    msg: 'Your Account Block ...',
                                    color: Colors.red,
                                  );

                                  await FirebaseRegistrationHelper
                                      .firebaseRegistrationHelper
                                      .signOutUser();
                                } else {
                                  scaffoldMessengerComponent(
                                    context: context,
                                    msg: 'Login Successfully...',
                                    color: Colors.green,
                                  );

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'userHomePage', (route) => false);
                                }
                              }
                            } else {
                              scaffoldMessengerComponent(
                                context: context,
                                msg: 'Sign-In Failed...',
                                color: Colors.red,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            scaffoldMessengerComponent(
                              context: context,
                              msg: e.message!,
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
                    const SizedBox(height: 30),
                    Text(
                      "-----------  or continue with -----------",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        User? user;
                        try {
                          user = await FirebaseRegistrationHelper
                              .firebaseRegistrationHelper
                              .signInWithGoogle();
                        } catch (e) {
                          print(e);
                        }

                        if (user != null) {
                          QuerySnapshot querySnapshot =
                              await CloudFireStoreDatabaseHelper
                                  .cloudFireStoreDatabaseHelper.fireStore
                                  .collection('admin')
                                  .where('id', arrayContains: user.uid)
                                  .get();

                          if (querySnapshot.docs.length == 1) {
                            scaffoldMessengerComponent(
                              context: context,
                              msg: 'Login Successfully...',
                              color: Colors.green,
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'adminHomePage', (route) => false);
                          } else {
                            QuerySnapshot querySnapshot =
                                await CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper.fireStore
                                    .collection("User")
                                    .where('id', isEqualTo: user.uid)
                                    .get();

                            Map<String, dynamic> userMapData = {
                              'id': user.uid,
                              'fullName': user.displayName,
                              'address': null,
                              'mobileNo': user.phoneNumber,
                              'emailId': user.email,
                              'password': null,
                              'userStatus': true,
                            };

                            if (querySnapshot.docs.isEmpty) {
                              scaffoldMessengerComponent(
                                context: context,
                                msg: 'Login Successfully...',
                                color: Colors.green,
                              );

                              await CloudFireStoreDatabaseHelper
                                  .cloudFireStoreDatabaseHelper.fireStore
                                  .collection('User')
                                  .doc(user.uid)
                                  .set(userMapData);

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'userHomePage', (route) => false);
                            } else {
                              Map<String, dynamic> userData =
                                  querySnapshot.docs[0].data()
                                      as Map<String, dynamic>;

                              if (userData["userStatus"] == false) {
                                scaffoldMessengerComponent(
                                  context: context,
                                  msg: 'Your Account Block ...',
                                  color: Colors.red,
                                );

                                await FirebaseRegistrationHelper
                                    .firebaseRegistrationHelper
                                    .signOutUser();
                              } else {
                                scaffoldMessengerComponent(
                                  context: context,
                                  msg: 'Login Successfully...',
                                  color: Colors.green,
                                );

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'userHomePage', (route) => false);
                              }
                            }
                          }
                        } else {
                          scaffoldMessengerComponent(
                            context: context,
                            msg: 'Login Failed...',
                            color: Colors.red,
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: width * 0.95,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/loginPage/GoogleLogo.png",
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Login with Gmail",
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),
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
                                .pushReplacementNamed("registrationPage");
                          },
                          child: Text(
                            "User Sign up",
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
                          "Worker ? ",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
