// ignore_for_file: camel_case_types, unused_local_variable, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, avoid_print, body_might_complete_normally_catch_error, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/screens/user/serviceDetailsPage.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/promocode.dart';

class billing_page extends StatefulWidget {
  const billing_page({super.key});

  @override
  State<billing_page> createState() => _billing_pageState();
}

class _billing_pageState extends State<billing_page> {
  int? discountPer;
  int? disCountedPrice;
  TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dynamic e = ModalRoute.of(context)!.settings.arguments;

    print("------------");
    print(e);
    print("------------");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 34,
                              backgroundImage: NetworkImage(
                                e[0].imageURL,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              iconAndDetailsUI(
                                icon: const Icon(
                                  Icons.person,
                                ),
                                data: e[0].fullName,
                              ),
                              iconAndDetailsUI(
                                icon: const Icon(
                                  Icons.email,
                                ),
                                data: e[0].emailId,
                              ),
                              iconAndDetailsUI(
                                icon: const Icon(
                                  Icons.phone,
                                ),
                                data: e[0].mobileNo,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Rating : ",
                                    style: GoogleFonts.openSans(fontSize: 13),
                                  ),
                                  RatingBar.builder(
                                    itemSize: 13,
                                    initialRating:
                                        (e[0].totalStar / e[0].totalRating),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: CloudFireStoreDatabaseHelper
                  .cloudFireStoreDatabaseHelper.fireStore
                  .collection('promoCode')
                  .where('stock', isGreaterThan: 0)
                  // .where("Is_Active", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Promocode> newsData =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Promocode.fromMap(data: data);
                  }).toList();

                  return Column(
                    children: [
                      ...newsData.map((e) {
                        return (e.is_Active)
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                              "${e.code}  -  ${e.discount} % Discount"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () async {
                                      await CloudFireStoreDatabaseHelper
                                          .cloudFireStoreDatabaseHelper
                                          .fireStore
                                          .collection("promoCode")
                                          .doc("${e.id}")
                                          .set({
                                        'id': e.id,
                                        'code': e.code,
                                        'discount': e.discount,
                                        'stock': e.stock - 1,
                                        'Is_Active': e.is_Active,
                                      });

                                      discountPer = e.discount.toInt();

                                      setState(() {});
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          side: const BorderSide(
                                              color: Colors.white),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.indigo),
                                    ),
                                    child: const Text("Apply"),
                                  )),
                                ],
                              )
                            : Container();
                      })
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(
                      (discountPer != null)
                          ? "\u{20B9} ${e[1].pricePerHour} - $discountPer %   = \u{20B9} ${(e[1].pricePerHour - ((e[1].pricePerHour / 100) * discountPer!)).toInt()}"
                          : "\u{20B9} ${e[1].pricePerHour}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.indigo)),
                      onPressed: () async {
                        if (discountPer != null) {
                          disCountedPrice = (e[1].pricePerHour -
                                  ((e[1].pricePerHour / 100) * discountPer!))
                              .toInt();
                          print(disCountedPrice);
                        }

                        if (true) {
                          int id = await CloudFireStoreDatabaseHelper
                              .cloudFireStoreDatabaseHelper
                              .gerCounter(
                                  collection: "bookingTransactionCounter");
                          id = id + 1;

                          User? user = await FirebaseRegistrationHelper
                              .firebaseRegistrationHelper
                              .currentUser();

                          String userId = user!.uid;
                          String name = "";
                          String address = "";
                          String emailId = "";
                          String phone = "";
                          String workerName = "";

                          await CloudFireStoreDatabaseHelper
                              .cloudFireStoreDatabaseHelper.fireStore
                              .collection('User')
                              .where('id', isEqualTo: userId)
                              .get()
                              .then((value) {
                            value.docs.forEach((e) {
                              name = e['fullName'];
                              address = e['address'] ?? "";
                              emailId = e['emailId'] ?? "";
                              phone = e['mobileNo'] ?? "";
                            });
                          });

                          List userDetails = [
                            {"fullName": name},
                            {"emailId": emailId},
                            {"mobileNo": phone},
                            {"address": address},
                          ];

                          if (address != "" && phone != "") {
                            int plateformCharge =
                                ((e[1].pricePerHour * 5) / 100).round();

                            Map<String, dynamic> workerDetails = {
                              'earrings': (discountPer != null)
                                  ? (e[0].earrings +
                                      (disCountedPrice! - plateformCharge))
                                  : (e[0].earrings +
                                      (e[1].pricePerHour - plateformCharge)),
                              'Password': e[0].password,
                              'address': e[0].address,
                              'totalServices': (e[0].totalServices + 1),
                              'emailId': e[0].emailId,
                              'fullName': e[0].fullName,
                              'id': e[0].id,
                              'imageURL': e[0].imageURL,
                              'is_Active': e[0].is_Active,
                              'mobileNo': e[0].mobileNo,
                              'totalRating': e[0].totalRating,
                              'totalStar': e[0].totalStar,
                              'serviceList': e[0].serviceList,
                              'serviceCategoryList': e[0].serviceCategoryList,
                            };

                            Map<String, dynamic> bookingTransaction = {
                              'id': id,
                              'workerId': e[0].id,
                              'workerName': e[0].fullName,
                              'userId': userId,
                              'userDetails': userDetails,
                              'serviceId': e[1].id,
                              'serviceCategoryName': e[1].serviceCategoriesName,
                              'amount': (discountPer != null)
                                  ? disCountedPrice
                                  : e[1].pricePerHour,
                              'date': e[2],
                              'time': e[3],
                              'formatTime': e[4],
                              'formatDate': e[5],
                              'totalHours': e[1].totalMinute,
                              'platformCharges':
                                  ((e[1].pricePerHour * 5) / 100).round(),
                            };

                            CloudFireStoreDatabaseHelper
                                .cloudFireStoreDatabaseHelper.fireStore
                                .collection("Worker")
                                .doc("${e[0].id}")
                                .set(workerDetails)
                                .then((value) async {})
                                .catchError((e) {
                              print("Error is $e");
                            });

                            CloudFireStoreDatabaseHelper
                                .cloudFireStoreDatabaseHelper.fireStore
                                .collection("bookingTransaction")
                                .doc("$id")
                                .set(bookingTransaction)
                                .then((value) async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Successfully Booked"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await CloudFireStoreDatabaseHelper
                                  .cloudFireStoreDatabaseHelper
                                  .setCounter(
                                counter: id,
                                collection: 'bookingTransactionCounter',
                              );
                            }).catchError((e) {
                              print("Error is $e");
                            });

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "userHomePage", (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (address == "" && phone == "")
                                      ? "Please Add Your Address & Phone Number"
                                      : (phone == "")
                                          ? "Please Add Your Phone Number"
                                          : "Please Add Your Address ",
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.of(context).pushNamed(
                              "editProfilePage",
                            );
                          }
                        }
                      },
                      child: const Text("Booking Now"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
