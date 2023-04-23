// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, avoid_print, depend_on_referenced_packages, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import '../../models/bookingTransactionModel.dart';

class BookedPendingServicePage extends StatefulWidget {
  const BookedPendingServicePage({super.key});

  @override
  State<BookedPendingServicePage> createState() =>
      _BookedPendingServicePageState();
}

class _BookedPendingServicePageState extends State<BookedPendingServicePage> {
  Future<Widget> showBookingServiceUi(
      {required BookingTransactionModel data}) async {
    String? serviceName;
    String? workerName;
    await CloudFireStoreDatabaseHelper.cloudFireStoreDatabaseHelper.fireStore
        .collection('Service')
        .where('id', isEqualTo: data.serviceId)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        serviceName = e['serviceName'];
      });
    });

    await CloudFireStoreDatabaseHelper.cloudFireStoreDatabaseHelper.fireStore
        .collection('Worker')
        .where('id', isEqualTo: data.workerId)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        workerName = e['fullName'];
      });
    });

    // print("serviceName = $serviceName");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$serviceName",
            style: GoogleFonts.openSans(
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const CircleAvatar(),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.workerName,
                    style: GoogleFonts.openSans(fontSize: 15),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.formatDate,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_rounded,
                        size: 19,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${data.totalHours} Minute",
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        data.formatTime,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(
                "  \u{20B9} ${(data.amount)}",
                style: GoogleFonts.openSans(
                    fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Cancel booking"),
                onPressed: () async {
                  await CloudFireStoreDatabaseHelper
                      .cloudFireStoreDatabaseHelper.fireStore
                      .collection('bookingTransaction')
                      .doc("${data.id}")
                      .delete();

                  Map<String, dynamic> workerDetails = {};

                  await CloudFireStoreDatabaseHelper
                      .cloudFireStoreDatabaseHelper.fireStore
                      .collection('Worker')
                      .where('id', isEqualTo: data.workerId)
                      .get()
                      .then((value) {
                    value.docs.forEach((e) {
                      workerDetails = {
                        'earrings': e.data()["earrings"],
                        'Password': e.data()["Password"],
                        'address': e.data()["address"],
                        'totalServices': e.data()["totalServices"] - 1,
                        'emailId': e.data()["emailId"],
                        'fullName': e.data()["fullName"],
                        'id': e.data()["id"],
                        'imageURL': e.data()["imageURL"],
                        'is_Active': e.data()["is_Active"],
                        'mobileNo': e.data()["mobileNo"],
                        'totalRating': e.data()["totalRating"],
                        'totalStar': e.data()["totalStar"],
                        'serviceList': e.data()["serviceList"],
                        'serviceCategoryList': e.data()["serviceCategoryList"],
                      };
                    });
                  });

                  CloudFireStoreDatabaseHelper
                      .cloudFireStoreDatabaseHelper.fireStore
                      .collection("Worker")
                      .doc("${data.workerId}")
                      .set(workerDetails)
                      .catchError((e) {
                    print("Error is $e");
                  });

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'userHomePage', (route) => false);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Booking Canceled"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<BookingTransactionModel> pendingBookedService = [];

  getPendingBookedService() async {
    String userID = FirebaseRegistrationHelper.firebaseRegistrationHelper
        .getCurrentUserId();
    print(userID);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('bookingTransaction')
            .where('userId', isEqualTo: userID)
            .where('date', isGreaterThan: DateTime.now())
            .get();

    print(querySnapshot.docs.length);

    pendingBookedService = querySnapshot.docs
        .map((e) => BookingTransactionModel.fromMap(data: e.data()))
        .toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPendingBookedService();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: pendingBookedService
            .map(
              (e) => FutureBuilder(
                future: showBookingServiceUi(data: e),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
