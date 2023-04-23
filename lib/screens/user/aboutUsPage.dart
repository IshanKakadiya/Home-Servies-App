
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                "Welcome User Name",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Present-day lives want comfort, and On-Demand Services give the equivalent. A home repair app is needed since it offers all home-related assistance at one-click, which makes life simple for individuals running by the clock. Clients can peruse distinctive filters, examine via rating and audits, recruit somebody according to their inclinations, and pay for the services using their preferred payment method – all in just a few minutes.",
              style: GoogleFonts.openSans(
                fontSize: 15,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Our-Services",
              style: GoogleFonts.openSans(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "- Show Services",
              style: GoogleFonts.openSans(
                fontSize: 15,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Our Partners",
              style: GoogleFonts.openSans(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "- Harshit Kikani\n- Ishan Kakadiya\n- Dhruvin Kathrotiya",
              style: GoogleFonts.openSans(
                fontSize: 15,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
