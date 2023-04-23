// ignore_for_file: file_names, unused_local_variable, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../models/serviceCategories.dart';

class AllCategoryPage extends StatefulWidget {
  const AllCategoryPage({Key? key}) : super(key: key);

  @override
  State<AllCategoryPage> createState() => _AllCategoryPageState();
}

class _AllCategoryPageState extends State<AllCategoryPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Services"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('serviceCategories')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServiceCategories> allServiceCategoriesList =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              // print(snapsh);

              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ServiceCategories.fromMap(data: data);
            }).toList();

            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: allServiceCategoriesList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('categoryServicesPage',
                          arguments: allServiceCategoriesList[index].name);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                allServiceCategoriesList[index].imageURL,
                              ),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          allServiceCategoriesList[index].name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(fontSize: 15),
                        )
                      ],
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   height: 125,
                    //   width: (width - 20) / 4,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         height: 100,
                    //         width: 100,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           border: Border.all(color: Colors.white, width: 2),
                    //           image: DecorationImage(
                    //               image: NetworkImage(
                    //                   allServiceCategoriesList[index].imageURL),
                    //               fit: BoxFit.cover),
                    //           color: Colors.blue.withOpacity(0.2),
                    //         ),
                    //       ),
                    //       // Spacer(),
                    //       Text(
                    //         allServiceCategoriesList[index].name,
                    //         style: const TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.w500),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  );
                },
              ),
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
