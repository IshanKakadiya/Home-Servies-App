// ignore_for_file: file_names, unused_local_variable, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../models/service.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryServicesPage extends StatefulWidget {
  const CategoryServicesPage({Key? key}) : super(key: key);

  @override
  State<CategoryServicesPage> createState() => _CategoryServicesPageState();
}

class _CategoryServicesPageState extends State<CategoryServicesPage> {
  @override
  Widget build(BuildContext context) {
    String serviceName = ModalRoute.of(context)!.settings.arguments as String;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: StreamBuilder(
          stream: CloudFireStoreDatabaseHelper
              .cloudFireStoreDatabaseHelper.fireStore
              .collection('Service')
              .where('serviceCategoriesName', isEqualTo: serviceName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Service> allServicesList =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                // print(data);
                return Service.fromMap(data: data);
              }).toList();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: (allServicesList.isNotEmpty)
                    ? Column(
                        children: allServicesList.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  'serviceDetailsPage',
                                  arguments: e,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(13),
                                height: 130,
                                width: width * 0.9,
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
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.8),
                                          width: 1,
                                        ),
                                        image: DecorationImage(
                                            image: NetworkImage(e.imageURL),
                                            fit: BoxFit.cover),
                                        color: Colors.blue.withOpacity(0.3),
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
                                            overflow: TextOverflow.ellipsis,
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
                          );
                        }).toList(),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          "\n\n\n\n\n\n\n\n\nServices Not Add Yet !",
                          style: GoogleFonts.openSans(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
