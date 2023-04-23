// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../utils/components.dart';
import '../component/adminHomePageComponent/home.dart';
import '../component/adminHomePageComponent/services.dart';
import '../component/adminHomePageComponent/worker.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  PageController controller = PageController();

  int initialPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // printData();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Home Service"),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: adminHomePageDrawer(context: context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: initialPageIndex,
        elevation: 10,
        // iconSize: 25,
        onTap: (val) {
          setState(() {
            initialPageIndex = val;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Worker',
          ),
        ],
      ),
      body: IndexedStack(
        index: initialPageIndex,
        children: const [
          Home(),
          Service(),
          Worker(),
        ],
      ),
    );
  }
}
