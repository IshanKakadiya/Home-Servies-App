// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:intl/intl.dart';

class Demo_Page extends StatefulWidget {
  const Demo_Page({super.key});

  @override
  State<Demo_Page> createState() => _Demo_PageState();
}

class _Demo_PageState extends State<Demo_Page> {
  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    // print("--------------------------");
    // print(dt);
    // print(dt.subtract(const Duration(days: 1)));
    // print("--------------------------");
    return Scaffold(
      appBar: AppBar(
        title: const Text("DEMO"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          DateTimePicker(
            initialSelectedDate: dt,
            endDate: dt.add(const Duration(days: 7)),
            startTime: DateTime(dt.year, dt.month, dt.day, 8),
            endTime: DateTime(dt.year, dt.month, dt.day, 20),
            timeInterval: const Duration(minutes: 60),
            datePickerTitle: 'Pick a Date',
            timePickerTitle: 'Pick a Time',
            timeOutOfRangeError: 'Sorry shop is closed now',
            is24h: false,
            numberOfWeeksToDisplay: 2,
            onDateChanged: (date) {
              setState(() {
                String _d1 = DateFormat('dd MMM, yyyy').format(date);
                print("----------------------");
                print(_d1);
                print("----------------------");
              });
            },
            onTimeChanged: (time) {
              setState(() {
                String _t1 = DateFormat('hh:mm:ss aa').format(time);
                print("----------------------");
                print(_t1);
                print("----------------------");
              });
            },
          ),
        ],
      ),
    );
  }
}
