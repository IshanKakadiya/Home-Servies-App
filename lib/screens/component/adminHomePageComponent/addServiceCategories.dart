// ignore_for_file: file_names, unused_local_variable, avoid_print, use_build_context_synchronously, must_be_immutable, depend_on_referenced_packages

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ty_demo_home_services_app/helper/cloud_firestore_database_helper.dart';
import '../../../helper/firebaseStorageHelper.dart';
import '../../../models/serviceCategories.dart';
import '../../../utils/GLoble.dart';

class AddServiceCategories extends StatefulWidget {
  const AddServiceCategories({Key? key}) : super(key: key);

  @override
  State<AddServiceCategories> createState() => _AddServiceCategoriesState();
}

class _AddServiceCategoriesState extends State<AddServiceCategories> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: (Globle.workerDetails.isEmpty)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceCategoryDetailsFormPage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('serviceCategories')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServiceCategories> allServiceCategoriesList =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ServiceCategories.fromMap(data: data);
            }).toList();

            // allServiceCategoriesList.shuffle();
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
                      Navigator.of(context).pushNamed('Show_Sub_Category',
                          arguments: allServiceCategoriesList[index].name);
                    },
                    onDoubleTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceCategoryDetailsFormPage(
                                              data: allServiceCategoriesList[
                                                  index]),
                                    ),
                                  );
                                },
                                child: const Text("UPDATE"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Center(child: Text("Delete")),
                                        content: const Text(
                                            "Are You Sure To Delete ?"),
                                        actions: [
                                          OutlinedButton(
                                            child: const Text("Calcle"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          OutlinedButton(
                                            child: const Text("Delete"),
                                            onPressed: () async {
                                              await CloudFireStoreDatabaseHelper
                                                  .cloudFireStoreDatabaseHelper
                                                  .fireStore
                                                  .collection(
                                                      "serviceCategories")
                                                  .doc(
                                                      "${allServiceCategoriesList[index].id}")
                                                  .delete()
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text("Sevice Deleted"),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }).catchError((e) {
                                                print(e);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  Navigator.of(context).pop();
                                },
                                child: const Text("DETETE"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("CANCEL"),
                              ),
                            ],
                          ),
                        ),
                      );
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

class ServiceCategoryDetailsFormPage extends StatefulWidget {
  ServiceCategories? data;

  ServiceCategoryDetailsFormPage({super.key, this.data});

  @override
  State<ServiceCategoryDetailsFormPage> createState() =>
      _ServiceCategoryDetailsFormPageState();
}

class _ServiceCategoryDetailsFormPageState
    extends State<ServiceCategoryDetailsFormPage> {
  GlobalKey<FormState> serviceCategoryForm = GlobalKey<FormState>();

  TextEditingController nameCategoriesController = TextEditingController();

  TextEditingController serviceCategoriesNameController =
      TextEditingController();
  String? categoryName;
  String? imageURL;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      nameCategoriesController.text = widget.data!.name;
      imageURL = widget.data!.imageURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Service"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (imageURL != null)
                            ? NetworkImage("$imageURL")
                            : null,
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
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: serviceCategoryForm,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameCategoriesController,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        cursorColor: Colors.white,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Your Service Name";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          categoryName = nameCategoriesController.text;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z ]")),
                        ],
                        decoration: InputDecoration(
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
                          fillColor: Colors.white.withOpacity(0.4),
                          prefixIcon: Icon(
                            Icons.design_services_outlined,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          filled: true,
                          hintText: "Enter Your Service Name",
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: (widget.data == null)
                            ? () async {
                                int id = await CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper
                                    .gerCounter(
                                        collection: "serviceCategoriesCounter");
                                id = id + 1;

                                if (serviceCategoryForm.currentState!
                                        .validate() &&
                                    imageURL != null) {
                                  serviceCategoryForm.currentState!.save();

                                  Map<String, dynamic> servicesCategory = {
                                    "id": id,
                                    "imageURL": imageURL,
                                    "name": categoryName,
                                  };

                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("serviceCategories")
                                      .doc("$id")
                                      .set(servicesCategory)
                                      .then((value) async {
                                    await CloudFireStoreDatabaseHelper
                                        .cloudFireStoreDatabaseHelper
                                        .setCounter(
                                            counter: id,
                                            collection:
                                                'serviceCategoriesCounter');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Category SuccessFull added"),
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
                                }
                              }
                            : () async {
                                if (serviceCategoryForm.currentState!
                                        .validate() &&
                                    imageURL != null) {
                                  serviceCategoryForm.currentState!.save();

                                  Map<String, dynamic> servicesCategory = {
                                    "id": widget.data!.id,
                                    "imageURL": imageURL,
                                    "name": categoryName,
                                  };

                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("serviceCategories")
                                      .doc("${widget.data!.id}")
                                      .update(servicesCategory)
                                      .then((value) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Category SuccessFull Updated"),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }).catchError((e) {
                                    print("Error is $e");
                                  });
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } else if (imageURL == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("add Image"),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
