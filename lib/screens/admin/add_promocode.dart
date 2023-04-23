// ignore_for_file: file_names, unused_local_variable, avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, non_constant_identifier_names, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/helper/cloud_firestore_database_helper.dart';
import 'package:ty_demo_home_services_app/models/promocode.dart';

class Add_Promocode extends StatefulWidget {
  const Add_Promocode({Key? key}) : super(key: key);

  @override
  State<Add_Promocode> createState() => _Add_PromocodeState();
}

class _Add_PromocodeState extends State<Add_Promocode> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Added Promocode"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PromocodeDetailsPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: CloudFireStoreDatabaseHelper
            .cloudFireStoreDatabaseHelper.fireStore
            .collection('promoCode')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Promocode> promocodeData =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Promocode.fromMap(data: data);
            }).toList();

            int number = 1;

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: promocodeData.length,
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
                                    builder: (context) => PromocodeDetailsPage(
                                        data: promocodeData[i]),
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
                                                .collection("promoCode")
                                                .doc("${promocodeData[i].id}")
                                                .delete()
                                                .then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("Promocode Deleted"),
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
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.4),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Number : ${number++}\nPromocode : ${promocodeData[i].code}\nDiscount : ${promocodeData[i].discount}\nStock : ${promocodeData[i].stock}\nIs Active : ${promocodeData[i].is_Active}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            fontSize: 15,
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

class PromocodeDetailsPage extends StatefulWidget {
  Promocode? data;

  PromocodeDetailsPage({super.key, this.data});

  @override
  State<PromocodeDetailsPage> createState() => _PromocodeDetailsPageState();
}

class _PromocodeDetailsPageState extends State<PromocodeDetailsPage> {
  GlobalKey<FormState> PromocodeFormKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  bool onOff = true;
  String? code;
  num? discount;
  num? stock;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      codeController.text = widget.data!.code;
      discountController.text = widget.data!.discount.toString();
      stockController.text = widget.data!.stock.toString();
      onOff = widget.data!.is_Active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              (widget.data == null) ? "Add Promocode" : "Update Promocode"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: PromocodeFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: codeController,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        cursorColor: Colors.white,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Promocode";
                          }

                          return null;
                        },
                        onSaved: (val) {
                          code = codeController.text;
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
                          hintText: "Enter Promocode",
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: discountController,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        ],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Discount [Which %]";
                          } else if (100 <= num.parse(val) ||
                              0 == num.parse(val)) {
                            return "Valid Discount";
                          }

                          return null;
                        },
                        onSaved: (val) {
                          discount = num.parse(discountController.text);
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
                          hintText: "Enter Discount",
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: stockController,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Promocode Stock";
                          } else if (0 == num.parse(val)) {
                            return "Valid Discount";
                          }

                          return null;
                        },
                        onSaved: (val) {
                          stock = num.parse(stockController.text);
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
                          hintText: "Enter Promocode Stock",
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
                                    .gerCounter(collection: "PromocodeCounter");
                                id = id + 1;

                                if (PromocodeFormKey.currentState!.validate()) {
                                  PromocodeFormKey.currentState!.save();

                                  Map<String, dynamic> promocode = {
                                    "id": id,
                                    "code": code,
                                    "discount": discount,
                                    "Is_Active": onOff,
                                    "stock": stock,
                                  };

                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("promoCode")
                                      .doc("$id")
                                      .set(promocode)
                                      .then((value) async {
                                    await CloudFireStoreDatabaseHelper
                                        .cloudFireStoreDatabaseHelper
                                        .setCounter(
                                            counter: id,
                                            collection: 'PromocodeCounter');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Promocode SuccessFull added"),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }).catchError((e) {
                                    print("Error is $e");
                                  });
                                  Navigator.of(context).pop();
                                }
                              }
                            : () async {
                                if (PromocodeFormKey.currentState!.validate()) {
                                  PromocodeFormKey.currentState!.save();

                                  Map<String, dynamic> promocode = {
                                    "id": widget.data!.id,
                                    "code": code,
                                    "discount": discount,
                                    "Is_Active": onOff,
                                    "stock": stock,
                                  };

                                  await CloudFireStoreDatabaseHelper
                                      .cloudFireStoreDatabaseHelper.fireStore
                                      .collection("promoCode")
                                      .doc("${widget.data!.id}")
                                      .update(promocode)
                                      .then((value) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Promocode SuccessFull Updated"),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }).catchError((e) {
                                    print("Error is $e");
                                  });
                                  Navigator.of(context).pop();
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
