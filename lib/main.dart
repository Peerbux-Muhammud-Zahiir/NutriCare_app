import 'package:flutter/material.dart';
import 'package:untitled/pages/loadingscreen.dart';
import 'package:untitled/pages/login.dart';
import 'package:untitled/pages/signup.dart';
import 'package:untitled/pages/welcomesceen.dart';
import 'package:untitled/randomutilities/bottomnavigationbarpagemanager.dart';

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
