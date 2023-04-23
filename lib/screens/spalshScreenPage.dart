// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: (value) {
        setState(() {});
      },
      children: <Widget>[
        component(
            image: "assets/images/spalshScreen/1.jpg",
            color: Colors.red,
            title: "Welcome To V-Care\nHome Services",
            subTitle: "Welcome To V-Care\nHome Services",
            onPressed: () {
              controller.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }),
        component(
            image: "assets/images/spalshScreen/2.jpg",
            color: Colors.teal,
            title: "Welcome To V-Care\nHome Services",
            subTitle: "Welcome To V-Care\nHome Services",
            onPressed: () {
              controller.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }),
        component(
            image: "assets/images/spalshScreen/3.jpg",
            color: Colors.orange,
            title: "Welcome To V-Care\nHome Services",
            subTitle: "Welcome To V-Care\nHome Services",
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("loginPage");
            }),
      ],
    );
  }

  component(
      {required String title,
      required String subTitle,
      required Color color,
      required String image,
      required onPressed}) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              const Spacer(),
              TextButton(
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("loginPage");
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          Image.asset(
            image,
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 17,
              color: Colors.white.withOpacity(0.3),
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 100),
          Row(
            children: [
              const Spacer(),
              FloatingActionButton(
                  backgroundColor: color,
                  child: const Icon(Icons.arrow_forward),
                  onPressed: onPressed),
              const SizedBox(width: 5),
            ],
          )
        ],
      ),
    );
  }
}
