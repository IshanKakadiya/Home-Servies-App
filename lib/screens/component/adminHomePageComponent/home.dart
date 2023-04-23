// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import '../../../helper/cloud_firestore_database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget containerUi(
      {required String title,
      required String data,
      required IconData iconData,
      required Color colors}) {
    return InkWell(
      onTap: () {
        if (title == "Total User") {
          Navigator.of(context).pushNamed("Detail_Page");
        } else if (title == "Total Booked Service") {
          Navigator.of(context).pushNamed("Total_Booked_Service_Page");
        } else if (title == "Total Worker") {
          Navigator.of(context).pushNamed("Wroker_Details_Page");
        }
      },
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: colors,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.kanit(
                    fontWeight: FontWeight.w500, fontSize: 22),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    data,
                    style: GoogleFonts.kanit(
                        fontWeight: FontWeight.w500, fontSize: 30),
                  ),
                  Icon(
                    iconData,
                    size: 55,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  int? totalBookingService;
  int? totalService;
  int? totalServiceCategory;
  int? totalEarning;
  int? totalUser;
  int? totalWorker;

  getData() async {
    totalBookingService = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('bookingTransaction')
        .get()
        .then((value) {
      return value.docs.length;
    });

    setState(() {});

    totalWorker = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('Worker')
        .get()
        .then((value) {
      return value.docs.length;
    });

    setState(() {});

    totalServiceCategory = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('serviceCategories')
        .get()
        .then((value) {
      return value.docs.length;
    });

    setState(() {});

    totalService = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('Service')
        .get()
        .then((value) {
      return value.docs.length;
    });

    setState(() {});

    totalUser = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('User')
        .get()
        .then((value) {
      return value.docs.length;
    });

    setState(() {});

    totalEarning = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('bookingTransaction')
        .get()
        .then((value) {
      int earning = 0;
      value.docs.forEach((element) {
        print(element.data()['platformCharges']);
        earning = earning + element.data()['platformCharges'] as int;
      });
      print(earning);
      return earning;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
    print("done");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            containerUi(
              title: "Total Booked Service",
              data: "$totalBookingService",
              iconData: Icons.shopping_cart,
              colors: Colors.lightBlue,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Earning",
              data: "$totalEarning RS",
              iconData: Icons.monetization_on,
              colors: Colors.green,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Services",
              data: "$totalServiceCategory",
              iconData: Icons.category,
              colors: Colors.orange,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Sub-Service",
              data: "$totalService",
              iconData: Icons.cleaning_services,
              colors: Colors.red,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Worker",
              data: "$totalWorker",
              iconData: Icons.person,
              colors: Colors.purple,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total User",
              data: "$totalUser",
              iconData: Icons.person_pin_outlined,
              colors: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
