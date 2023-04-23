// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, avoid_print, unused_local_variable, unused_element, depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/utils/GLoble.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import '../../models/bookingTransactionModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookedCompleteServicePage extends StatefulWidget {
  const BookedCompleteServicePage({super.key});

  @override
  State<BookedCompleteServicePage> createState() =>
      _BookedCompleteServicePageState();
}

class _BookedCompleteServicePageState extends State<BookedCompleteServicePage> {
  Future<Widget> showBookingServiceUi(
      {required BookingTransactionModel data}) async {
    String? serviceName;
    String? workerName;
    int rating = 0;
    String review = "";
    String bookingDocId = "";
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

    await CloudFireStoreDatabaseHelper.cloudFireStoreDatabaseHelper.fireStore
        .collection('Worker')
        .where('id', isEqualTo: data.workerId)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        workerName = e['fullName'];
      });
    });

    await CloudFireStoreDatabaseHelper.cloudFireStoreDatabaseHelper.fireStore
        .collection('Rating_Review')
        .where('Booking_id', isEqualTo: data.id)
        .get()
        .then((value) {
      value.docs.forEach((e) {
        rating = e.data()['Rating'];
        review = e.data()['Review'];
        bookingDocId = value.docs[0].id;
      });
    });

    // print("serviceName = $serviceName");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      // height: 160,
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
                    style: GoogleFonts.openSans(),
                  ),
                  RatingBar.builder(
                    itemSize: 15,
                    initialRating: rating.toDouble(),
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
                        size: 17,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${data.totalHours} Minute",
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        data.formatTime,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
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
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: (rating == 0)
                    ? const Text("Add Review & Rating")
                    : const Text("Edit Review & Rating"),
                onPressed: () {
                  Globle.booking_id = data.id!;
                  Globle.rating = rating;
                  Globle.review = review;
                  Globle.booking_docId = bookingDocId;
                  setState(() {});
                  Navigator.of(context).pushNamed("Add_Review_Rating_Page",
                      arguments: [data.id, rating, review]);
                },
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(
              //     Icons.delete,
              //     size: 25,
              //   ),
              // )
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
            .where('date', isLessThan: DateTime.now())
            .get();

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
