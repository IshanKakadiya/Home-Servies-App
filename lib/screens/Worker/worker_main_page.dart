// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, camel_case_types, unused_import

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/utils/GLoble.dart';
import '../../../helper/cloud_firestore_database_helper.dart';
import '../../models/workerModel.dart';

class Worker_Home extends StatefulWidget {
  const Worker_Home({super.key});

  @override
  State<Worker_Home> createState() => _Worker_HomeState();
}

class _Worker_HomeState extends State<Worker_Home> {
  Widget containerUi(
      {required String title,
      required String data,
      required IconData iconData,
      required Color colors}) {
    return InkWell(
      onTap: () {
        if (title == "Total User") {
          // Navigator.of(context).pushNamed("Detail_Page");
        } else if (title == "Total Booked Service") {
          // Navigator.of(context).pushNamed("Total_Booked_Service_Page");
        } else if (title == "Total Worker") {
          // Navigator.of(context).pushNamed("Wroker_Details_Page");
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

  int totalEarning = 0;

  getData() async {
    totalEarning = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('bookingTransaction')
        .where("workerId", isEqualTo: Globle.workerDetails[0].id)
        .get()
        .then((value) {
      int earning = 0;
      value.docs.forEach((element) {
        earning =
            element.data()["amount"] - element.data()['platformCharges'] as int;
      });

      return earning;
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
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
              data: "${Globle.workerDetails[0].totalServices}",
              iconData: Icons.shopping_cart,
              colors: Colors.lightBlue,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Earning",
              data: "$totalEarning",
              iconData: Icons.monetization_on,
              colors: Colors.green,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Rating",
              data:
                  "${Globle.workerDetails[0].totalStar / Globle.workerDetails[0].totalRating} / 5",
              iconData: Icons.cleaning_services,
              colors: Colors.red,
            ),
            const SizedBox(
              height: 15,
            ),
            containerUi(
              title: "Total Person Ratig",
              data: "${Globle.workerDetails[0].totalRating}",
              iconData: Icons.category,
              colors: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
