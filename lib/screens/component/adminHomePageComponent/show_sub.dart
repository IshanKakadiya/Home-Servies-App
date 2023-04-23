// ignore_for_file: file_names, unused_local_variable, camel_case_types, unused_import, depend_on_referenced_packages

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/models/service.dart';
import 'package:ty_demo_home_services_app/models/serviceCategories.dart';
import 'package:ty_demo_home_services_app/screens/component/adminHomePageComponent/addService.dart';
import '../../../helper/cloud_firestore_database_helper.dart';
import '../../../utils/GLoble.dart';
import 'addServiceCategories.dart';

class Show_Sub_Category extends StatefulWidget {
  const Show_Sub_Category({Key? key}) : super(key: key);

  @override
  State<Show_Sub_Category> createState() => _Show_Sub_CategoryState();
}

class _Show_Sub_CategoryState extends State<Show_Sub_Category> {
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

              // allServiceCategoriesList.shuffle();
              return (allServicesList.isNotEmpty)
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          children: allServicesList.map<Widget>((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                          child: Container(
                            height: 150,
                            width: width,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              e.imageURL,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        e.serviceCategoriesName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(
                                          flex: 2,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Service :",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          e.serviceName,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Price Per Hours : ",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "\u{20B9} ${e.pricePerHour}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(
                                          flex: 5,
                                        ),
                                      ],
                                    ),
                                    (Globle.workerDetails.isEmpty)
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: PopupMenuButton(
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons
                                                          .drive_file_rename_outline),
                                                      SizedBox(
                                                        // sized box with width 10
                                                        width: 10,
                                                      ),
                                                      Text("Update")
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.delete),
                                                      SizedBox(
                                                        // sized box with width 10
                                                        width: 10,
                                                      ),
                                                      Text("Delete")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (val) async {
                                                if (val == 1) {
                                                  print("naviogate");
                                                  // Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        ServiceDetailsFormPage(
                                                      data: e,
                                                    ),
                                                  ));
                                                  print("not navigate");
                                                } else {
                                                  print("daon");
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Center(
                                                            child:
                                                                Text("Delete")),
                                                        content: const Text(
                                                            "Are You Sure To Delete ?"),
                                                        actions: [
                                                          OutlinedButton(
                                                            child: const Text(
                                                                "Calcle"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          OutlinedButton(
                                                            child: const Text(
                                                                "Delete"),
                                                            onPressed:
                                                                () async {
                                                              await CloudFireStoreDatabaseHelper
                                                                  .cloudFireStoreDatabaseHelper
                                                                  .fireStore
                                                                  .collection(
                                                                      "Service")
                                                                  .doc(
                                                                      "${e.id}")
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        "Sevice Deleted"),
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                              }).catchError(
                                                                      (e) {
                                                                print(e);
                                                              });

                                                              // ignore: use_build_context_synchronously
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  // var collection = FirebaseFirestore.instance.collection('collection');
                                                  // collection
                                                  //     .doc('some_id') // <-- Doc ID to be deleted.
                                                  // .delete();
                                                }
                                              },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                    )
                  : Center(
                      child: Text(
                        "Service Not Added Yet !",
                        style: GoogleFonts.openSans(
                          fontSize: 25,
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
