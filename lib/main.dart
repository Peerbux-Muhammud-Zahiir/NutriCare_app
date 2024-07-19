import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nutricare/AI%20Chatbot/chatbotmain.dart';
import 'package:nutricare/AI%20Stuff/camerastream.dart';
import 'package:nutricare/AI%20Stuff/imagefoodclassification.dart';
import 'package:nutricare/nutritionix/nutrionixsearch.dart';
import 'package:nutricare/pages/chat.dart';
import 'package:nutricare/pages/daily_tips.dart';
import 'package:nutricare/pages/diet_planner.dart';
import 'package:nutricare/pages/foodloadingscreen.dart';
import 'package:nutricare/pages/home.dart';
import 'package:nutricare/pages/loadingscreen.dart';
import 'package:nutricare/pages/login.dart';
import 'package:nutricare/pages/signup.dart';
import 'package:nutricare/pages/useraccount.dart';
import 'package:nutricare/pages/welcomesceen.dart';
import 'package:nutricare/randomutilities/bottomnavigationbarpagemanager.dart';
import 'nutritionix/nutrionixexercise.dart';
import 'nutritionix/nutritionixapi.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDOw1Abd7hD9nBR63J2rxIiK3GxGMkmpI0',
    appId: '1:286370369103:android:352c4752215ebb3579643a',
    messagingSenderId: '286370369103',
    projectId: 'nutricare-93a2e',
    storageBucket: 'nutricare-93a2e.appspot.com',
  ));

  runApp(MaterialApp(

      initialRoute: '/Welcome',


      routes: {
    '/Home': (context) => managePage('/Home'),
    '/Login': (context) => Login(),
    '/Signup': (context) => Signup(),
    '/Chat': (context) => managePage('/Chat'),
    '/DailyTips': (context) => managePage('/DailyTips'),
    '/DietPlanner': (context) => managePage('/DietPlanner'),
    '/UserAccount': (context) => managePage('/UserAccount'),
    '/Loading': (context) => LoadingScreen(),
        '/Welcome': (context) => WelcomeScreen(),
        '/FoodapiTEST': (context)=> Nutrionixexercise(),
        '/Fruittest': (context)=> FruitWidget(),
  }));
}

Widget managePage(String routeName) {
  switch (routeName) {
    case '/Home':
      return PageManager(initialPage: 2);
    case '/Chat':
      return PageManager(initialPage: 3);
    case '/DailyTips':
      return PageManager(initialPage: 4);
    case '/DietPlanner':
      return PageManager(initialPage: 0);
    case '/UserAccount':
      return PageManager(initialPage: 1);
    default:
      throw Exception('Invalid route');
  }
}
