import 'package:flutter/material.dart';
import 'package:nutricare/AI%20Chatbot/chatbotmain.dart';
import 'package:nutricare/AI%20Chatbot/configs/application.dart';
import 'package:nutricare/AI%20Chatbot/configs/injector.dart';

class ChatBoxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Box'),
        backgroundColor: Color(0xFF2abca4),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            chatbotmain();
          },
          child: Text('Start Chat'),
        ),
      ),
    );
  }
}