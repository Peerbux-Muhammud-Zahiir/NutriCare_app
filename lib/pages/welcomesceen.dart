import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill( // Background image
            child: Image.network(
              'https://cdn.pixabay.com/photo/2016/12/10/21/26/food-1898194_960_720.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column( // Use Column for vertical layout
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between children
                children: [
                  Spacer(), // Push the content to the center
                  Center( // Center the icon and text
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150, // Adjust the height as needed
                          width: 150, // Adjust the width as needed
                          child: Image.asset('assets/nutricareiconwhiteresized.png'),
                        ),
                        Text(
                          'Welcome to Nutricare.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(), // Push the content to the center
                  SizedBox( // Add spacing above the button
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity, // Make the button width larger
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2abca4),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Login');
                      },
                      child: Text('Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),


                    ),
                  ),
    )],
              ),
            ),
          ),
        ],
      ),
    );
  }
}