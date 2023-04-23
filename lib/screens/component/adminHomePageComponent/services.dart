import 'package:flutter/material.dart';
import 'addService.dart';
import 'addServiceCategories.dart';

class Service extends StatefulWidget {
  const Service({Key? key}) : super(key: key);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> with SingleTickerProviderStateMixin {
  late TabController tabController;

  int initialPageIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            onTap: (val) {
              setState(() {
                initialPageIndex = val;
              });
            },
            indicatorColor: Colors.white,
            controller: tabController,
            tabs: const [
              Tab(
                text: "Sub-Sevice",
              ),
              Tab(
                text: "Service",
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: initialPageIndex,
              children: const [
                AddService(),
                AddServiceCategories(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
