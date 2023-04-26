import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ty_demo_home_services_app/utils/GLoble.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 15),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Welcome ${Globle.name}\n",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Present-day lives want comfort, and On-Demand Services give the equivalent. A home repair app is needed since it offers all home-related assistance at one-click, which makes life simple for individuals running by the clock. Clients can peruse distinctive filters, examine via rating and audits, recruit somebody according to their inclinations, and pay for the services using their preferred payment method – all in just a few minutes.",
              style: GoogleFonts.openSans(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "\n- Our Partners",
              style: GoogleFonts.openSans(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              " -  Ishan Kakadiya\n -  Dhruvin Kathrotiya\n -  Rutvik Manvar\n -  Yash Bhavani",
              style: GoogleFonts.openSans(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
