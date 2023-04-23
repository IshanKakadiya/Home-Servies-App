// ignore_for_file: file_names

import "package:flutter/material.dart";
import 'BookedPanddingServicePage.dart';
import 'bookedCompleteServicePage.dart';

class BookedServicesPage extends StatefulWidget {
  const BookedServicesPage({super.key});

  @override
  State<BookedServicesPage> createState() => _BookedServicesPageState();
}

class _BookedServicesPageState extends State<BookedServicesPage>
    with TickerProviderStateMixin {
  PageController controller = PageController();
  late TabController _controller;
  int initialTableIndex = 0;

  List<Widget> pages = [
    const BookedCompleteServicePage(),
    const BookedPendingServicePage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Booked Services"),
        bottom: TabBar(
          controller: _controller,
          onTap: (val) {
            // print(val);
            setState(() {
              initialTableIndex = val;
            });

            controller.animateToPage(
              val,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          },
          indicatorColor: Colors.white,
          indicatorWeight: 2,
          labelStyle: const TextStyle(fontSize: 15),
          tabs: const [
            Tab(child: Text("COMPLATE")),
            Tab(child: Text("PENDING")),
          ],
        ),
      ),
      body: PageView.builder(
        controller: controller,
        onPageChanged: (val) {
          setState(() {
            // print(val);
            initialTableIndex = val;
          });

          _controller.animateTo(val);
        },
        physics: const BouncingScrollPhysics(),
        itemCount: pages.length,
        itemBuilder: (context, i) => pages[i],
      ),
    );
  }
}
