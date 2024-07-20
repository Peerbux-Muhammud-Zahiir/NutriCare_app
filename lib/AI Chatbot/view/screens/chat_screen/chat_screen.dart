import 'package:nutricare/AI Chatbot/configs/provider/message_provider.dart';
import 'package:nutricare/AI Chatbot/configs/provider/theme_provider.dart';
import 'package:nutricare/AI Chatbot/view/screens/chat_screen/ui/chat_bubble.dart';
import 'package:nutricare/AI Chatbot/view/screens/chat_screen/ui/write_message_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nutricare/pages/home.dart';
import 'package:nutricare/randomutilities/bottomnavigationbarpagemanager.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PageManager(initialPage: 2), // Index for Home page
              )
            );
          },

        ),
        title: const Text(
          'NutriBot',
          style: TextStyle(
            fontSize: 24,              // Adjust font size
            // fontWeight: FontWeight.bold, // Adjust font weight
            color: Colors.white,       // Adjust text color
          ),
          // Center align the text
        ),
        backgroundColor: const Color.fromARGB(255, 47, 148, 50),
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
              onPressed: () => ref.read(themeProvider).toggleTheme(),
              icon: const Icon(Icons.brightness_4_outlined),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // List of all the messages
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final messages = ref.watch(messagesProvider).messages;
              return ListView.builder(
                  controller: ref.read(messagesProvider).scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: messages[index]);
                  });
            }),
          ),
          // TextField for writing message and button
          const WriteMessageTextField(),
        ],
      ),
    );
  }
}