import 'package:nutricare/AI Chatbot/configs/application.dart';
import 'package:nutricare/AI Chatbot/configs/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ChatbotMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Injector(child: MainApp());
  }
}

