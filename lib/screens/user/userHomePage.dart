// ignore_for_file: file_names, unused_local_variable, unnecessary_string_interpolations, depend_on_referenced_packages

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helper/cloud_firestore_database_helper.dart';
import '../../helper/firebaseRegistrationHelper.dart';
import '../../models/news.dart';
import '../../models/service.dart';
import '../../models/serviceCategories.dart';
import '../../utils/GLoble.dart';
import '../../utils/components.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  User? user;

  getUserName() async {
    user = await FirebaseRegistrationHelper.firebaseRegistrationHelper
        .currentUser();
    try {
      Globle.name = user!.displayName ?? "";
      Globle.email = user!.email ?? "";
    } catch (e) {}
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  // List allServiceName = [];

  String isSelected = "All";
  int checkListLength = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    getUserName();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Service"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      drawer: userHomePageDrawer(context: context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('serviceSearchPage');
                },
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    fillColor: Colors.white.withOpacity(0.2),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    filled: true,
                    hintText: "Search",
                    hintStyle: GoogleFonts.openSans(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                " Special Offers",
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: CloudFireStoreDatabaseHelper
                    .cloudFireStoreDatabaseHelper.fireStore
                    .collection('News')
                    .where("Is_Active", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<News> newsData =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return News.fromMap(data: data);
                    }).toList();

                    return CarouselSlider(
                      items: newsData
                          .map((e) => Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.white.withOpacity(0.1),
                                  image: DecorationImage(
                                    image: NetworkImage("${e.Image}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        scrollPhysics: const BouncingScrollPhysics(),
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        autoPlayAnimationDuration: const Duration(seconds: 2),
                        autoPlayInterval: const Duration(seconds: 4),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    " Service",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('allCategoryPage');
                    },
                    child: Text(
                      "See All",
                      style: GoogleFonts.openSans(
                        color: const Color.fromARGB(255, 153, 119, 247),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder(
                stream: CloudFireStoreDatabaseHelper
                    .cloudFireStoreDatabaseHelper.fireStore
                    .collection('serviceCategories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Globle.allServiceCategoriesList =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ServiceCategories.fromMap(data: data);
                    }).toList();

                    return Column(
                      children: [
                        Wrap(
                          children: [
                            ...Globle.allServiceCategoriesList
                                .sublist(0, 7)
                                .map((e) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      'categoryServicesPage',
                                      arguments: e.name);
                                },
                                child: SizedBox(
                                  width: 85,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            width: 1,
                                          ),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage("${e.imageURL}"),
                                              fit: BoxFit.cover),
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${e.name}",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.openSans(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('allCategoryPage');
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 35,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 153, 119, 247),
                                      radius: 20,
                                      child: Icon(
                                        Icons.more_horiz,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "More",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ],
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
              const SizedBox(height: 25),
              Divider(
                color: Colors.white.withOpacity(0.5),
              ),
              Row(
                children: [
                  Text(
                    " Most Popular Services",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('AllSubServicesPage');
                    },
                    child: Text(
                      "See All",
                      style: GoogleFonts.openSans(
                        color: const Color.fromARGB(255, 153, 119, 247),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder(
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

                    if (allServiceList.length < 5) {
                      checkListLength = allServiceList.length;
                    } else {
                      checkListLength = 5;
                    }

                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
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
                                        ? const Color.fromARGB(
                                            255, 153, 119, 247)
                                        : Colors.white,
                                  ),
                                ),
                                backgroundColor: (isSelected == "All")
                                    ? const Color.fromARGB(255, 153, 119, 247)
                                    : Colors.transparent,
                                onSelected: (bool isSelect) {
                                  isSelected = "All";
                                },
                              ),
                              ...Globle.allServiceCategoriesList
                                  .sublist(0, 8)
                                  .map(
                                (e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: FilterChip(
                                      shape: const StadiumBorder(
                                        side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 153, 119, 247),
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
                                          ? const Color.fromARGB(
                                              255, 153, 119, 247)
                                          : Colors.transparent,
                                      onSelected: (bool isSelect) {
                                        isSelected = e.name;
                                      },
                                    ),
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ),
                        ...allServiceList
                            .sublist(0, checkListLength)
                            .map(
                              (e) => Column(
                                children: [
                                  const SizedBox(height: 15),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                width: 1,
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${e.imageURL}"),
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
                                                  "${e.serviceName}",
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
                                ],
                              ),
                            )
                            .toList(),
                        const SizedBox(height: 15),
                        (checkListLength == 0)
                            ? Container(
                                padding: const EdgeInsets.all(15),
                                height: 130,
                                width: width * 0.9,
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
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.white.withOpacity(1),
    );
  }
}
