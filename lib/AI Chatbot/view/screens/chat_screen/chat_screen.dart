import 'package:nutricare/AI Chatbot/configs/provider/message_provider.dart';
import 'package:nutricare/AI Chatbot/configs/provider/theme_provider.dart';
import 'package:nutricare/AI Chatbot/view/screens/chat_screen/ui/chat_bubble.dart';
import 'package:nutricare/AI Chatbot/view/screens/chat_screen/ui/write_message_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriBot'),
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
