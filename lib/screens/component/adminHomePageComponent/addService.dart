// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, must_be_immutable, use_key_in_widget_constructors, depend_on_referenced_packages, unused_local_variable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ty_demo_home_services_app/utils/GLoble.dart';
import '../../../helper/cloud_firestore_database_helper.dart';
import '../../../helper/firebaseStorageHelper.dart';
import '../../../models/service.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

List<Service> allServicesList = [];

class _AddServiceState extends State<AddService> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: (Globle.workerDetails.isEmpty)
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsFormPage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              StreamBuilder(
                stream: CloudFireStoreDatabaseHelper
                    .cloudFireStoreDatabaseHelper.fireStore
                    .collection('Service')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    allServicesList =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Service.fromMap(data: data);
                    }).toList();

                    return Column(
                        children: allServicesList.map<Widget>((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                        ),
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
                              Expanded(
                                flex: 9,
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
                                          width: 158,
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
                              Expanded(
                                child: Stack(
                                  children: [
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList());
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceDetailsFormPage extends StatefulWidget {
  Service? data;

  ServiceDetailsFormPage({this.data});

  @override
  State<ServiceDetailsFormPage> createState() => _ServiceDetailsFormPageState();
}

class _ServiceDetailsFormPageState extends State<ServiceDetailsFormPage> {
  GlobalKey<FormState> serviceFormKey = GlobalKey<FormState>();

  TextEditingController servicesNameController = TextEditingController();
  TextEditingController pricePerHourController = TextEditingController();
  TextEditingController totalMinuteController = TextEditingController();

  String? servicesName;
  String? serviceCategoriesName;
  String? selectedCategory;
  int? pricePerHour;
  int? totalMinute;
  String? imageURL;

  List serviceCategoryList = [];

  getCategoryName() async {
    serviceCategoryList = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection("serviceCategories")
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    print(serviceCategoryList);
    setState(() {});
  }

  String? serviceCheckoutName;

  @override
  void initState() {
    super.initState();
    getCategoryName();

    if (widget.data != null) {
      servicesNameController.text = widget.data!.serviceName;
      serviceCheckoutName = widget.data!.serviceName;
      pricePerHourController.text = widget.data!.pricePerHour.toString();
      totalMinuteController.text = widget.data!.totalMinute.toString();
      selectedCategory = widget.data!.serviceCategoriesName;
      imageURL = widget.data!.imageURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              (widget.data == null) ? "Add Sub-Service" : "Update Sub-Service"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 15),
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          (imageURL != null) ? NetworkImage("$imageURL") : null,
                    ),
                    Align(
                      alignment: const Alignment(1.25, 1.25),
                      child: FloatingActionButton(
                        onPressed: () async {
                          final picker = ImagePicker();

                          XFile? pickedImage;
                          try {
                            pickedImage = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 5,
                            );

                            final String fileName =
                                path.basename(pickedImage!.path);
                            print("----------------------------------");
                            print(fileName);
                            print("----------------------------------");
                            File imageFile = File(pickedImage.path);

                            try {
                              await FirebaseStorageHelper
                                  .firebaseStorageHelper.storage
                                  .ref(fileName)
                                  .putFile(
                                    imageFile,
                                  );

                              FirebaseStorageHelper
                                  .firebaseStorageHelper.storage
                                  .ref(fileName)
                                  .getDownloadURL()
                                  .then((value) {
                                setState(() {
                                  imageURL = value;
                                });
                              });

                              setState(() {});
                            } on FirebaseException catch (error) {
                              print(error);
                            }
                          } catch (err) {
                            print(err);
                          }

                          setState(() {});
                        },
                        mini: true,
                        child: (imageURL == null)
                            ? const Icon(Icons.add)
                            : const Icon(Icons.refresh),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: serviceFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: servicesNameController,
                      style: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      cursorColor: Colors.white,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Your Sub-Service Name";
                        }

                        for (int i = 0; i < allServicesList.length; i++) {
                          if (val == allServicesList[i].serviceName &&
                              val != serviceCheckoutName) {
                            return "Sub-Service Name Not be Dublicate";
                          }
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      onSaved: (val) {
                        servicesName = servicesNameController.text;
                      },
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        fillColor: Colors.white.withOpacity(0.4),
                        prefixIcon: Icon(
                          Icons.room_service,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        hintText: "Enter Your Sub-Service Name",
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.4),
                      ),
                      child: DropdownButton(
                          alignment: Alignment.center,
                          isExpanded: true,
                          hint: Text(
                            "Select Category",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                            ),
                          ),
                          // key: dropDownState,

                          value: selectedCategory,
                          items: serviceCategoryList
                              .map(
                                (e) => DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: e['name'],
                                  child: Text("${e['name']}"),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCategory = val.toString();
                            });
                          }),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: totalMinuteController,
                      style: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      cursorColor: Colors.white,
                      maxLength: 3,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Minute Per Sevices";
                        } else if (30 > num.parse(val)) {
                          return "Service Time Not Below 30 Minute";
                        }

                        return null;
                      },
                      onSaved: (val) {
                        totalMinute = int.parse(totalMinuteController.text);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        fillColor: Colors.white.withOpacity(0.4),
                        prefixIcon: Icon(
                          Icons.timelapse,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        hintText: "Enter Total Minite of Service",
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: pricePerHourController,
                      style: GoogleFonts.openSans(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      cursorColor: Colors.white,
                      maxLength: 3,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Charge for Minute";
                        } else if (50 > num.parse(val)) {
                          return "Charge Not Below 50 Rs.";
                        }

                        return null;
                      },
                      onSaved: (val) {
                        pricePerHour = int.parse(pricePerHourController.text);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        fillColor: Colors.white.withOpacity(0.4),
                        prefixIcon: Icon(
                          Icons.mode_edit_outline,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        filled: true,
                        hintText: "Enter Per Time Charge",
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: (widget.data == null)
                          ? () async {
                              int id = await CloudFireStoreDatabaseHelper
                                  .cloudFireStoreDatabaseHelper
                                  .gerCounter(collection: "serviceCounter");
                              id = id + 1;

                              if (serviceFormKey.currentState!.validate() &&
                                  imageURL != null &&
                                  selectedCategory != null) {
                                serviceFormKey.currentState!.save();

                                Map<String, dynamic> services = {
                                  "id": id,
                                  "imageURL": imageURL,
                                  "serviceName": servicesName,
                                  "serviceCategoriesName": selectedCategory,
                                  "pricePerHour": pricePerHour,
                                  "totalMinute": totalMinute,
                                };

                                CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper.fireStore
                                    .collection("Service")
                                    .doc("$id")
                                    .set(services)
                                    .then((value) async {
                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper
                                      .setCounter(
                                          counter: id,
                                          collection: 'serviceCounter');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Service SuccessFull added"),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }).catchError((e) {
                                  print("Error is $e");
                                });

                                Navigator.of(context).pop();
                              } else if (imageURL == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("add Image"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Select Category"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          : () async {
                              print("update");

                              if (serviceFormKey.currentState!.validate() &&
                                  imageURL != null &&
                                  selectedCategory != null) {
                                serviceFormKey.currentState!.save();

                                Map<String, dynamic> services = {
                                  "id": widget.data!.id,
                                  "imageURL": imageURL,
                                  "serviceName": servicesName,
                                  "serviceCategoriesName": selectedCategory,
                                  "pricePerHour": pricePerHour,
                                };

                                CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper.fireStore
                                    .collection("Service")
                                    .doc("${widget.data!.id}")
                                    .update(services)
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Service SuccessFull Updated"),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }).catchError((e) {
                                  print("Error is $e");
                                });

                                Navigator.of(context).pop();
                              } else if (imageURL == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("add Image"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Select Category"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      child: Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          (widget.data == null) ? "ADD" : "UPDATE",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
