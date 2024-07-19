import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/randomutilities/text_field_input.dart';

import '../randomutilities/errordisplay.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    Navigator.pushNamed(context, '/Loading');

    String res = await Authentication().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    Navigator.pop(context);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacementNamed(context, '/Home');
    }
  }

  void navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/Signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:

      Stack(
          children: [
            Image.asset('assets/nutricareicon.png'),

      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
          image: NetworkImage(""), // background image
      fit: BoxFit.cover,
    ),
    ),
    ),


      SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 5),
                  //image
                  // Image.asset('assets/opensourceavengers.png',
                  //     height: 200),
                  const SizedBox(height: 200),
                  //text field input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  //text field input for password
                  TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      isPass: true),
                  const SizedBox(height: 24),
                  //button login
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: Color(0xFF2abca4)),
                      child: _isLoading
                          ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                          : const Text('Log in',
                      style:TextStyle(
                        color:Colors.white,
                          fontWeight: FontWeight.bold,

                      )),

                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(child: Container(), flex: 2),

                  //transition to signing up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height:10),
                          InkWell(
                            onTap: navigateToSignup,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjust padding as needed
                              decoration: BoxDecoration(
                                color: Color(0xFF2abca4), // Background color of the button
                                borderRadius: BorderRadius.circular(5), // Rounded corners
                                // Add more decoration properties as needed
                              ),
                              child: const Text(
                                "Sign up.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Text color
                                  // Add more text style properties as needed
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40,), // Adjust the space below the button as needed
                        ],
                      ),
                    ],
                  )
                ],
              ))),
      ]),);
  }
}
