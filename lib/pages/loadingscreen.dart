import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00bda6), // Set the background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Align children to the center vertically
        children: <Widget>[
          // Align(
          //   alignment: Alignment.topCenter, // Align to top center
          //   child: Image.asset('assets/nutricaretitlewhite.png'), // Top center image
          // ),
          Expanded(
            child: Align(
              alignment: Alignment.center, // Align to center
              child: Image.asset('assets/nutricareiconwhite.png'), // Center image
            ),
          ),
      SpinKitThreeInOut(
        color: Colors.white,
        size: 50.0,),

        ],
      ),
    );
  }
}