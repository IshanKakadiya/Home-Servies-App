// ignore_for_file: file_names, unused_local_variable, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../models/service.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceSearchPage extends StatefulWidget {
  const ServiceSearchPage({Key? key}) : super(key: key);

  @override
  State<ServiceSearchPage> createState() => _ServiceSearchPageState();
}

class _ServiceSearchPageState extends State<ServiceSearchPage> {
  String search = "1";

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              TextField(
                onChanged: (val) {
                  setState(() {
                    search = val.trim();
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  fillColor: Colors.grey.withOpacity(0.25),
                  filled: true,
                  hintText: "Search",
                  suffixIcon: const Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: CloudFireStoreDatabaseHelper
                    .cloudFireStoreDatabaseHelper.fireStore
                    .collection('Service')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Service> allServicesList =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      // print(data.runtimeType);
                      return Service.fromMap(data: data);
                    }).toList();

                    return SizedBox(
                      height: _height * 0.76,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                            children: allServicesList.map<Widget>((e) {
                          if (e.serviceName.toLowerCase().contains(search)) {
                            return Column(
                              children: [
                                const SizedBox(height: 7),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
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
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }).toList()),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          )),
    );
  }
}
