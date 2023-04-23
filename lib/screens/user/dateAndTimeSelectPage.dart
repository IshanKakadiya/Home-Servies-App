import 'package:flutter/material.dart';

class DateAndTimeSelectPage extends StatefulWidget {
  const DateAndTimeSelectPage({Key? key}) : super(key: key);

  @override
  State<DateAndTimeSelectPage> createState() => _DateAndTimeSelectPageState();
}

class _DateAndTimeSelectPageState extends State<DateAndTimeSelectPage> {



  List<Map<String,dynamic>> timeSlots = [
    {
      "Weekdays": "Monday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
    {
      "Weekdays": "Tuesday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
    {
      "Weekdays": "Wednesday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
    {
      "Weekdays": "Thursday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
    {
      "Weekdays": "Friday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
    {
      "Weekdays": "Saturday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
    {
      "Weekdays": "Sunday",
      "Time": [
        {'Slot': '8/AM-9/AM', 'Value': 'NotAvailable'},
        {'Slot': '9/AM-10/AM', 'Value': 'NotAvailable'},
        {'Slot': '10/AM-11/AM', 'Value': 'NotAvailable'},
        {'Slot': '11/AM-12/PM', 'Value': 'NotAvailable'},
        {'Slot': '12/PM-1/PM', 'Value': 'NotAvailable'},
        {'Slot': '1/PM-2/PM', 'Value': 'NotAvailable'},
        {'Slot': '2/PM-3/PM', 'Value': 'NotAvailable'},
        {'Slot': '3/PM-4/PM', 'Value': 'NotAvailable'},
        {'Slot': '4/PM-5/PM', 'Value': 'NotAvailable'},
        {'Slot': '5/PM-6/PM', 'Value': 'NotAvailable'},
        {'Slot': '6/PM-7/PM', 'Value': 'NotAvailable'},
        {'Slot': '7/PM-8/PM', 'Value': 'NotAvailable'},
      ]
    },
  ];

  late List activeTime;

  @override
  void initState() {
    super.initState();

    activeTime = timeSlots[0]['Time'];

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date And Time"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
          children: activeTime
              .map(
                (e) => Container(
                  child: Text("${e['Value']}"),
                ),
              )
              .toList()),
    );
  }
}
