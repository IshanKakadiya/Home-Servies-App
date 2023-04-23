// ignore_for_file: file_names, unused_local_variable, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../models/service.dart';
import '../../utils/GLoble.dart';
import 'package:google_fonts/google_fonts.dart';

class AllSubServicesPage extends StatefulWidget {
  const AllSubServicesPage({super.key});

  @override
  State<AllSubServicesPage> createState() => _AllSubServicesPageState();
}

class _AllSubServicesPageState extends State<AllSubServicesPage> {
  String isSelected = "All";
  // int checkListLength = 0;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Popular Services"),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: (isSelected != "All")
            ? CloudFireStoreDatabaseHelper
                .cloudFireStoreDatabaseHelper.fireStore
                .collection('Service')
                .where("serviceCategoriesName", isEqualTo: isSelected)
                .snapshots()
            : CloudFireStoreDatabaseHelper
                .cloudFireStoreDatabaseHelper.fireStore
                .collection('Service')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Service> allServiceList =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Service.fromMap(data: data);
            }).toList();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Row(
                      children: [
                        FilterChip(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 153, 119, 247),
                          ),
                          label: Text(
                            "All",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              color: (isSelected != "All")
                                  ? const Color.fromARGB(255, 153, 119, 247)
                                  : Colors.white,
                            ),
                          ),
                          backgroundColor: (isSelected == "All")
                              ? const Color.fromARGB(255, 153, 119, 247)
                              : Colors.transparent,
                          onSelected: (bool isSelect) {
                            isSelected = "All";
                            setState(() {});
                          },
                        ),
                        ...Globle.allServiceCategoriesList.map(
                          (e) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: FilterChip(
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 153, 119, 247),
                                  ),
                                ),
                                label: Text(
                                  e.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    color: (isSelected != e.name)
                                        ? const Color.fromARGB(
                                            255, 153, 119, 247)
                                        : Colors.white,
                                  ),
                                ),
                                backgroundColor: (isSelected == e.name)
                                    ? const Color.fromARGB(255, 153, 119, 247)
                                    : Colors.transparent,
                                onSelected: (bool isSelect) {
                                  isSelected = e.name;
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 12,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...allServiceList
                            .sublist(0, allServiceList.length)
                            .map(
                              (e) => Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        'serviceDetailsPage',
                                        arguments: e,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(13),
                                      height: 130,
                                      width: _width * 0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 95,
                                            width: 95,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                width: 1,
                                              ),
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(e.imageURL),
                                                  fit: BoxFit.cover),
                                              color:
                                                  Colors.blue.withOpacity(0.3),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 8),
                                              Text(
                                                "Full Name",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 184,
                                                child: Text(
                                                  e.serviceName,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "\u{20B9} ${e.pricePerHour}",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 153, 119, 247),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Total Time : ${e.totalMinute} Min",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            )
                            .toList(),
                        const SizedBox(height: 15),
                        (allServiceList.isEmpty)
                            ? Container(
                                padding: const EdgeInsets.all(15),
                                height: 130,
                                width: _width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 153, 119, 247),
                                  ),
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Services Not Add Yet !",
                                  style: GoogleFonts.openSans(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
