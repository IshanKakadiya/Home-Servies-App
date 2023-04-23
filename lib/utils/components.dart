// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_element

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import '../helper/firebaseRegistrationHelper.dart';
import 'GLoble.dart';

Widget userHomePageDrawer({required BuildContext context}) {
  List drawerIteams = [
    {
      "icon": Icons.person,
      "name": "Profile Page",
      "onTap": () {
        Navigator.of(context).pushNamed('editProfilePage');
      }
    },
    {
      "icon": Icons.my_library_books_rounded,
      "name": "Booked Services",
      "navigator": null,
      "onTap": () {
        Navigator.of(context).pushNamed('bookedServicesPage');
      }
    },
    {
      "icon": Icons.all_inclusive_outlined,
      "name": "All Services",
      "onTap": () {
        Navigator.of(context).pushNamed('allCategoryPage');
      }
    },
    {
      "icon": Icons.cleaning_services_rounded,
      "name": "All Sub-Services",
      "onTap": () {
        Navigator.of(context).pushNamed('AllSubServicesPage');
      }
    },
    // {
    //   "icon": Icons.share,
    //   "name": "Refer & Earn",
    //   "navigator": null,
    // },
    {
      "icon": Icons.headphones_outlined,
      "name": "About Us",
      "onTap": () {
        Navigator.of(context).pushNamed('aboutUsPage');
      }
    },
    // {
    //   "icon": Icons.help_sharp,
    //   "name": "Helps",
    //   "navigator": null,
    // },
    {
      "icon": Icons.call,
      "name": "Contact Us",
      "onTap": () {
        Navigator.of(context).pushNamed('contactUsPage');
      }
    },
    {
      "icon": Icons.logout,
      "name": "Log Out",
      "onTap": () async {
        await FirebaseRegistrationHelper.firebaseRegistrationHelper
            .signOutUser();

        Navigator.of(context)
            .pushNamedAndRemoveUntil('loginPage', (route) => false);
      }
    },
  ];

  return Drawer(
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          // height: _height * 0.22,
          color: Colors.grey.withOpacity(0.3),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 194,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Globle.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          Globle.email,
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: drawerIteams
                .map(
                  (e) => GestureDetector(
                    onTap: e['onTap'],
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(e["icon"]),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 5),
                        Text(
                          e["name"],
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Spacer(),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.system_update_tv_sharp),
                onPressed: () {},
              ),
              const SizedBox(width: 5),
              Text(
                "Updates",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                child: Text(
                  "Check for Updates",
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "App Version 1.0.0.0",
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Made in INDIA with ❤",
          style: GoogleFonts.openSans(),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    ),
  );
}

Widget adminHomePageDrawer({required BuildContext context}) {
  List drawerIteams = [
    {
      "icon": Icons.person,
      "name": "Profile Page",
      "onTap": () {
        Navigator.of(context).pushNamed('editProfilePage');
      }
    },

    {
      "icon": Icons.reviews,
      "name": "View Review & Rating",
      "onTap": () {
        Navigator.of(context).pushNamed('Show_Rating_Page');
      }
    },
    {
      "icon": Icons.feedback,
      "name": "Show Feedback",
      "onTap": () {
        Navigator.of(context).pushNamed('Show_Feedback_Page');
      }
    },
    {
      "icon": Icons.code,
      "name": "Add New Promocode",
      "onTap": () {
        Navigator.of(context).pushNamed('Add_Promocode');
      }
    },
    {
      "icon": Icons.newspaper,
      "name": "Add News",
      "onTap": () {
        Navigator.of(context).pushNamed('Add_News_Page');
      }
    },

    // {
    //   "icon": Icons.headphones_outlined,
    //   "name": "About Us",
    //   "onTap": () {
    //     Navigator.of(context).pushNamed('aboutUsPage');
    //   }
    // },
    // {
    //   "icon": Icons.help_sharp,
    //   "name": "Helps",
    //   "navigator": null,
    // },
    // {
    //   "icon": Icons.call,
    //   "name": "Contact Us",
    //   "onTap": () {
    //     Navigator.of(context).pushNamed('contactUsPage');
    //   }
    // },
    {
      "icon": Icons.logout,
      "name": "Log Out",
      "onTap": () async {
        await FirebaseRegistrationHelper.firebaseRegistrationHelper
            .signOutUser();

        Navigator.of(context)
            .pushNamedAndRemoveUntil('loginPage', (route) => false);
      }
    },
  ];

  return Drawer(
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          // height: _height * 0.22,
          color: Colors.grey.withOpacity(0.3),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 194,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FirebaseRegistrationHelper
                              .firebaseAuth.currentUser!.displayName!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          FirebaseRegistrationHelper
                              .firebaseAuth.currentUser!.email!,
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: drawerIteams
                .map(
                  (e) => GestureDetector(
                    onTap: e['onTap'],
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(e["icon"]),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 5),
                        Text(
                          e["name"],
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Spacer(),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.system_update_tv_sharp),
                onPressed: () {},
              ),
              const SizedBox(width: 5),
              Text(
                "Updates",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                child: Text(
                  "Check for Updates",
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "App Version 1.0.0.0",
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Made in INDIA with ❤",
          style: GoogleFonts.openSans(),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    ),
  );
}

Widget workerHomePageDrawer({required BuildContext context}) {
  List drawerIteams = [
    {
      "icon": Icons.person,
      "name": "Profile Page",
      "onTap": () {
        Navigator.of(context).pushNamed('Worker_Edit_Profile_Page');
      }
    },
    {
      "icon": Icons.reviews,
      "name": "View Review & Rating",
      "onTap": () {
        Navigator.of(context).pushNamed('Worker_Rating_Page');
      }
    },
    {
      "icon": Icons.sell_rounded,
      "name": "Your Pending Service",
      "onTap": () {
        Navigator.of(context).pushNamed('Worker_Pading_Page');
      }
    },
    {
      "icon": Icons.paid_outlined,
      "name": "Your Completed Service",
      "onTap": () {
        Navigator.of(context).pushNamed('Worker_Complleted_Page');
      }
    },
    {
      "icon": Icons.logout,
      "name": "Log Out",
      "onTap": () async {
        await FirebaseRegistrationHelper.firebaseRegistrationHelper
            .signOutUser();

        Globle.workerDetails = [];

        Navigator.of(context)
            .pushNamedAndRemoveUntil('loginPage', (route) => false);
      }
    },
  ];

  return Drawer(
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          color: Colors.grey.withOpacity(0.3),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 194,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Globle.workerDetails[0].fullName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          Globle.workerDetails[0].emailId,
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: drawerIteams
                .map(
                  (e) => GestureDetector(
                    onTap: e['onTap'],
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(e["icon"]),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 5),
                        Text(
                          e["name"],
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Spacer(),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.system_update_tv_sharp),
                onPressed: () {},
              ),
              const SizedBox(width: 5),
              Text(
                "Updates",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                child: Text(
                  "Check for Updates",
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "App Version 1.0.0.0",
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Made in INDIA with ❤",
          style: GoogleFonts.openSans(),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    ),
  );
}
