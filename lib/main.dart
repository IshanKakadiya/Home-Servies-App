// ignore_for_file: depend_on_referenced_packages, equal_keys_in_map

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_completed_page.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_edit_profile.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_home_page.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_login.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_pending_page.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_ragister.dart';
import 'package:ty_demo_home_services_app/screens/Worker/worker_rating_page.dart';
import 'package:ty_demo_home_services_app/screens/admin/Show_Feedback.dart';
import 'package:ty_demo_home_services_app/screens/admin/add_news.dart';
import 'package:ty_demo_home_services_app/screens/admin/add_promocode.dart';
import 'package:ty_demo_home_services_app/screens/admin/adminHomePage.dart';
import 'package:ty_demo_home_services_app/screens/admin/showDetails.dart';
import 'package:ty_demo_home_services_app/screens/admin/show_rating.dart';
import 'package:ty_demo_home_services_app/screens/admin/total_booked.dart';
import 'package:ty_demo_home_services_app/screens/component/adminHomePageComponent/workerDetails.dart';
import 'package:ty_demo_home_services_app/screens/loginPage.dart';
import 'package:ty_demo_home_services_app/screens/registrationPage.dart';
import 'package:ty_demo_home_services_app/screens/spalshScreenPage.dart';
import 'package:ty_demo_home_services_app/screens/user/aboutUsPage.dart';
import 'package:ty_demo_home_services_app/screens/user/add_review_rating.dart';
import 'package:ty_demo_home_services_app/screens/user/allCategoryPage.dart';
import 'package:ty_demo_home_services_app/screens/user/allSubService.dart';
import 'package:ty_demo_home_services_app/screens/user/biling_page.dart';
import 'package:ty_demo_home_services_app/screens/user/bookedServicesPage.dart';
import 'package:ty_demo_home_services_app/screens/user/categoryServicesPage.dart';
import 'package:ty_demo_home_services_app/screens/user/contactUsPage.dart';
import 'package:ty_demo_home_services_app/screens/user/dateAndTimeSelectPage.dart';
import 'package:ty_demo_home_services_app/screens/user/demo.dart';
import 'package:ty_demo_home_services_app/screens/user/editProfilePage.dart';
import 'package:ty_demo_home_services_app/screens/user/imageStore.dart';
import 'package:ty_demo_home_services_app/screens/user/serviceDetailsPage.dart';
import 'package:ty_demo_home_services_app/screens/user/serviceSearchPage.dart';
import 'package:ty_demo_home_services_app/screens/user/userHomePage.dart';
import 'screens/component/adminHomePageComponent/show_sub.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: "splashScreenPage",
      routes: {
        "userHomePage": (context) => const UserHomePage(),
        "Add_Review_Rating_Page": (context) => const Add_Review_Rating_Page(),
        "dateAndTimeSelectPage": (context) => const DateAndTimeSelectPage(),
        "categoryServicesPage": (context) => const CategoryServicesPage(),
        "allCategoryPage": (context) => const AllCategoryPage(),
        "serviceSearchPage": (context) => const ServiceSearchPage(),
        "imageStore": (context) => const ImageStore(),
        "adminHomePage": (context) => const AdminHomePage(),
        "splashScreenPage": (context) => const SplashScreenPage(),
        "loginPage": (context) => const LoginPage(),
        "registrationPage": (context) => const RegistrationPage(),
        "adminHomePage": (context) => const AdminHomePage(),
        "serviceDetailsPage": (context) => const ServiceDetailsPage(),
        "editProfilePage": (context) => const EditProfilePage(),
        "contactUsPage": (context) => const ContactUsPage(),
        "aboutUsPage": (context) => const AboutUsPage(),
        "bookedServicesPage": (context) => const BookedServicesPage(),
        "Detail_Page": (context) => const Detail_Page(),
        "Add_News_Page": (context) => const Add_News_Page(),
        "Add_Promocode": (context) => const Add_Promocode(),
        "Show_Feedback_Page": (context) => const Show_Feedback_Page(),
        "Worker_Rating_Page": (context) => const Worker_Rating_Page(),
        "Show_Rating_Page": (context) => const Show_Rating_Page(),
        "Show_Sub_Category": (context) => const Show_Sub_Category(),
        "Wroker_Details_Page": (context) => const Wroker_Details_Page(),
        "AllSubServicesPage": (context) => const AllSubServicesPage(),
        "Worker_Ragister_Page": (context) => const Worker_Ragister_Page(),
        "Worker_Login_Page": (context) => const Worker_Login_Page(),
        "Worker_Home_Page": (context) => const Worker_Home_Page(),
        "Worker_Complleted_Page": (context) => const Worker_Complleted_Page(),
        "Worker_Pading_Page": (context) => const Worker_Pading_Page(),
        "billing_page": (context) => const billing_page(),
        "Worker_Edit_Profile_Page": (context) =>
            const Worker_Edit_Profile_Page(),
        "Total_Booked_Service_Page": (context) =>
            const Total_Booked_Service_Page(),
        "Demo_Page": (context) => const Demo_Page(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
