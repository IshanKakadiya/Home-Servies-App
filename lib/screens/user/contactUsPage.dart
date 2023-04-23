import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 15),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                    ),
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 260,
                  child: Text(
                    "SCF 98, Phase 11, Sector-67 Mohali, 160062",
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                    ),
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 260,
                  child: Text(
                    "651 B Broad St, Middletown, 19709, county New Castle Delaware, USA",
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                String phoneNumber = "6354279744";

                Uri uri = Uri.parse("tel:+91$phoneNumber");

                try {
                  await launchUrl(uri);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Not Possible due to $e"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: const Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 260,
                    child: Text(
                      "+91 63542 79644",
                      style: GoogleFonts.openSans(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                String email = "ishankakadiys7@gmail.com";
                Uri uri = Uri.parse(
                  "mailto:+91$email?subject=Heading&body=Hii",
                );

                try {
                  await launchUrl(uri);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Not Possible due to $e"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red,
                      ),
                    ),
                    child: const Icon(
                      Icons.mail,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 260,
                    child: Text(
                      "ishankakadiya7@gmail.com",
                      style: GoogleFonts.openSans(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 50,
              indent: 50,
              endIndent: 50,
              color: Colors.black.withOpacity(0.5),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
