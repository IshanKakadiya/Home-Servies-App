// ignore_for_file: file_names, camel_case_types, unused_import

import 'package:flutter/material.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_main_page.dart';
import '../../utils/components.dart';
import '../component/adminHomePageComponent/home.dart';
import '../component/adminHomePageComponent/services.dart';
import '../component/adminHomePageComponent/worker.dart';

class Worker_Home_Page extends StatefulWidget {
  const Worker_Home_Page({super.key});

  @override
  State<Worker_Home_Page> createState() => _Worker_Home_PageState();
}

class _Worker_Home_PageState extends State<Worker_Home_Page> {
  PageController controller = PageController();

  int initialPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Worker Home Page"),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: workerHomePageDrawer(context: context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: initialPageIndex,
        elevation: 10,
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
          Worker_Home(),
          Service(),
          Worker(),
        ],
      ),
    );
  }
}
