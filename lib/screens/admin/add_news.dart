// ignore_for_file: file_names, unused_local_variable, avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ty_demo_home_services_app/helper/cloud_firestore_database_helper.dart';
import '../../../helper/firebaseStorageHelper.dart';
import '../../models/news.dart';

class Add_News_Page extends StatefulWidget {
  const Add_News_Page({Key? key}) : super(key: key);

  @override
  State<Add_News_Page> createState() => _Add_News_PageState();
}

class _Add_News_PageState extends State<Add_News_Page> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Added News"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewsDetailsPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('News')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<News> newsData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return News.fromMap(data: data);
            }).toList();

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: newsData.length,
              separatorBuilder: (context, i) => const SizedBox(height: 15),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
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
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetailsPage(data: newsData[i]),
                                  ),
                                );

                                Navigator.of(context).pop();
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
                                                .collection("News")
                                                .doc("${newsData[i].id}")
                                                .delete()
                                                .then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("Sevice Deleted"),
                                                  behavior:
                                                      SnackBarBehavior.floating,
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
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.4),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 280,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                newsData[i].Image,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Title",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            newsData[i].News_title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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

class NewsDetailsPage extends StatefulWidget {
  News? data;

  NewsDetailsPage({super.key, this.data});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  GlobalKey<FormState> NewsFormKey = GlobalKey<FormState>();
  TextEditingController newsTitleController = TextEditingController();
  TextEditingController newsDecController = TextEditingController();
  bool onOff = true;
  String? newsTitle;
  String? imageURL;
  String? newsDec;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      newsTitleController.text = widget.data!.News_title;
      imageURL = widget.data!.Image;
      onOff = widget.data!.Is_Active;
      newsDecController.text = widget.data!.Description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add News"),
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

                            // setState(() {});
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
                  key: NewsFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: newsTitleController,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        cursorColor: Colors.white,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter News Title";
                          }

                          return null;
                        },
                        onSaved: (val) {
                          newsTitle = newsTitleController.text;
                        },
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
                            Icons.person,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          filled: true,
                          hintText: "Enter News Title",
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: newsDecController,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        cursorColor: Colors.white,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter News Decription";
                          }

                          return null;
                        },
                        onSaved: (val) {
                          newsDec = newsDecController.text;
                        },
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
                            Icons.person,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          filled: true,
                          hintText: "Enter News Decription",
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("off"),
                          Switch(
                            value: onOff,
                            onChanged: (val) {
                              setState(() {});
                              onOff = val;
                            },
                          ),
                          const Text("Live"),
                        ],
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: (widget.data == null)
                            ? () async {
                                int id = await CloudFireStoreDatabaseHelper
                                    .cloudFireStoreDatabaseHelper
                                    .gerCounter(
                                        collection: "NzDyUd2rNexJebHLggCm");
                                id = id + 1;

                                if (NewsFormKey.currentState!.validate() &&
                                    imageURL != null) {
                                  NewsFormKey.currentState!.save();

                                  DateTime dateTime = DateTime.now();

                                  Map<String, dynamic> news = {
                                    "id": id,
                                    "Image": imageURL,
                                    "Description": newsDec,
                                    "News_title": newsTitle,
                                    "News_Date":
                                        "${dateTime.day} / ${dateTime.month} / ${dateTime.year}",
                                    "News_Time":
                                        "${dateTime.hour} / ${dateTime.minute} / ${dateTime.second}",
                                    "Is_Active": onOff,
                                  };

                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("News")
                                      .doc("$id")
                                      .set(news)
                                      .then((value) async {
                                    await CloudFireStoreDatabaseHelper
                                        .cloudFireStoreDatabaseHelper
                                        .setCounter(
                                            counter: id,
                                            collection: 'NzDyUd2rNexJebHLggCm');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("News SuccessFull added"),
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
                                if (NewsFormKey.currentState!.validate() &&
                                    imageURL != null) {
                                  NewsFormKey.currentState!.save();

                                  DateTime dateTime = DateTime.now();

                                  Map<String, dynamic> news = {
                                    "id": widget.data!.id,
                                    "Image": imageURL,
                                    "Description": newsDec,
                                    "News_title": newsTitle,
                                    "News_Date":
                                        "${dateTime.day} / ${dateTime.month} / ${dateTime.year}",
                                    "News_Time":
                                        "${dateTime.hour} / ${dateTime.minute} / ${dateTime.second}",
                                    "Is_Active": onOff,
                                  };

                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("News")
                                      .doc("${widget.data!.id}")
                                      .update(news)
                                      .then((value) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("News SuccessFull Updated"),
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
