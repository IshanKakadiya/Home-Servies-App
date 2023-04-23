// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls, unused_local_variable, avoid_print, depend_on_referenced_packages, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../models/bookingTransactionModel.dart';
import '../../models/service.dart';
import '../../models/workerModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({Key? key}) : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

Widget iconAndDetailsUI({required Icon icon, required String data}) {
  return Row(
    children: [
      icon,
      const SizedBox(
        width: 7,
      ),
      Expanded(
        child: Text(
          data,
          softWrap: true,
        ),
      ),
    ],
  );
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  TextEditingController promoCodeController = TextEditingController();

  int? discountPer;
  DateTime? selectedDate;
  bool isSelectDate = false;
  bool isSelectTime = false;
  List<String> selectedTimeList = [];

  bool hasSelectedTimeList({required String data}) {
    bool res = false;
    selectedTimeList.forEach((element) {
      // print(element.runtimeType);
      if (element == data) {
        res = true;
      }
    });

    return res;
  }

  Widget detailsComponent({required String title, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title :",
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              letterSpacing: 1,
              color: Colors.blue),
        ),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            details,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  List<WorkerModel> workerList = [];
  List removeNotAvailableWorkerList = [];
  List removeWorkerIdList = [];

  removeNotAvailableWorker(
      {required DateTime dateTime, required List timeList}) {
    List<BookingTransactionModel> workerBookingTransactionList = [];

    workerList.forEach((element) async {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await CloudFireStoreDatabaseHelper
              .cloudFireStoreDatabaseHelper.fireStore
              .collection('bookingTransaction')
              .where('workerId', isEqualTo: element.id)
              .where('date', isGreaterThanOrEqualTo: dateTime)
              .where('time', arrayContainsAny: timeList)
              .get();

      List<BookingTransactionModel>? workerBookingTransactionList =
          querySnapshot.docs
              .map((e) => BookingTransactionModel.fromMap(data: e.data()))
              .toList();

      workerBookingTransactionList.forEach((element) {
        removeWorkerIdList.add(element.workerId);
      });

      print(removeWorkerIdList);

      setState(() {});
    });

    setState(() {});
  }

  getWorker({required String serviceName}) async {
    // workerList.forEach((element) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('Worker')
            .where('serviceList', arrayContains: serviceName)
            .get();

    workerList = querySnapshot.docs
        .map((e) => WorkerModel.fromMap(data: e.data()))
        .toList();

    setState(() {});
  }

  bool hasGetWorker = true;

  @override
  void initState() {
    super.initState();
  }

  DateTime dt = DateTime.now();
  String datePick = "";
  String timePick = "";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Service data = ModalRoute.of(context)!.settings.arguments as Service;

    int? disCountedPrice;

    if (hasGetWorker) {
      getWorker(serviceName: data.serviceName);
      hasGetWorker = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(data.serviceCategoriesName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: NetworkImage(data.imageURL),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 7),
                      Text(
                        "Sub-Service Name : ",
                        style: GoogleFonts.openSans(),
                      ),
                      Text(
                        data.serviceName,
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 153, 119, 247),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Total Minutes : ",
                        style: GoogleFonts.openSans(),
                      ),
                      Text(
                        "${data.totalMinute} Minutes",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 153, 119, 247),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Total Amount : ",
                        style: GoogleFonts.openSans(),
                      ),
                      Text(
                        (discountPer != null)
                            ? "\u{20B9} ${data.pricePerHour} - $discountPer % = ${(data.pricePerHour - ((data.pricePerHour / 100) * discountPer!)).toInt()}  RS"
                            : "\u{20B9} ${data.pricePerHour}",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 153, 119, 247),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Date & Time Picker",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Date: $datePick  Time: $timePick",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: Colors.white),
              Theme(
                data: ThemeData.from(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.deepPurple,
                  ),
                ),
                child: DateTimePicker(
                  initialSelectedDate: DateTime.now(),
                  endDate: dt.add(const Duration(days: 7)),
                  startTime: DateTime(dt.year, dt.month, dt.day, 8),
                  endTime: DateTime(dt.year, dt.month, dt.day, 20),
                  timeInterval: Duration(minutes: data.totalMinute),
                  datePickerTitle: 'Pick a Date',
                  timePickerTitle: 'Pick a Time',
                  timeOutOfRangeError: 'Sorry shop is closed now',
                  is24h: false,
                  numberOfWeeksToDisplay: 2,
                  onDateChanged: (date) async {
                    datePick = DateFormat('dd MMM, yyyy').format(date);
                    setState(() {});
                  },
                  onTimeChanged: (time) async {
                    timePick = DateFormat('hh:mm aa').format(time);
                    String timePickDemo1 = DateFormat('hh:mm aa').format(time);
                    String timePickDemo2 = DateFormat('hh:mm aa')
                        .format(time.add(Duration(minutes: data.totalMinute)));

                    selectedDate = time;

                    String addToList = "$timePickDemo1 To $timePickDemo2";
                    selectedTimeList.clear();
                    selectedTimeList.add(addToList);

                    removeWorkerIdList.clear();

                    await removeNotAvailableWorker(
                      dateTime: selectedDate!,
                      timeList: selectedTimeList,
                    );

                    setState(() {});
                  },
                ),
              ),
              Divider(color: Colors.white),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.white,
                indent: 45,
                endIndent: 45,
                thickness: 2,
              ),
              Center(
                child: const Text(
                  ": Available Worker : ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Divider(
                color: Colors.white,
                indent: 45,
                thickness: 2,
                endIndent: 45,
              ),
              const SizedBox(
                height: 10,
              ),
              (workerList.isNotEmpty)
                  ? Column(
                      children: [
                        ...workerList.map<Widget>((e) {
                          bool value = true;

                          removeWorkerIdList.forEach((element) {
                            if (element == e.id) {
                              value = false;
                            }
                          });

                          return (value)
                              ? Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed("billing_page");
                                      },
                                      child: Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.25),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 15),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: CircleAvatar(
                                                      radius: 46,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: CircleAvatar(
                                                        radius: 45,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          e.imageURL,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        iconAndDetailsUI(
                                                          icon: const Icon(
                                                            Icons.person,
                                                          ),
                                                          data: e.fullName,
                                                        ),
                                                        iconAndDetailsUI(
                                                          icon: const Icon(
                                                            Icons.email,
                                                          ),
                                                          data: e.emailId,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Rating : ",
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                            RatingBar.builder(
                                                              itemSize: 13,
                                                              initialRating: (e
                                                                      .totalStar /
                                                                  e.totalRating),
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                print(rating);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        SizedBox(
                                                          width: 100,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              if (selectedDate !=
                                                                      null &&
                                                                  selectedTimeList
                                                                      .isNotEmpty) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                  "billing_page",
                                                                  arguments: [
                                                                    e,
                                                                    data,
                                                                    selectedDate,
                                                                    selectedTimeList,
                                                                    timePick,
                                                                    datePick,
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                            style: ButtonStyle(
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10,
                                                                  ),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateColor
                                                                      .resolveWith(
                                                                (states) => Colors
                                                                    .deepPurple,
                                                              ),
                                                            ),
                                                            child:
                                                                Text("Select"),
                                                          ),
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
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                )
                              : Container();
                        }).toList(),
                      ],
                    )
                  : const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Worker Not available",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
