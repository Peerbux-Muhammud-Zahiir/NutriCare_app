import 'package:flutter/material.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/firebasestuff/chatservice.dart';
import 'package:nutricare/models/chatmessagemodel.dart';
import 'package:nutricare/randomutilities/buildmessageitemtyGPT.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  String currentUserUsername = '';

  @override
  void initState() {
    super.initState();
    _initUserDetails();
  }

  void _initUserDetails() async {
    final userDetails = await Authentication().getUserDetails();
    setState(() {
      currentUserUsername = userDetails.username; // Set username once available
    });
  }

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      final userDetails = await Authentication().getUserDetails();
      final username = userDetails.username;
      final senderId = userDetails.uid;
      final photoUrl = userDetails.photoUrl;
      await _chatService.sendMessage(text, senderId, username,photoUrl);
      _controller.clear();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Forum',
        style: TextStyle(
          color: Colors.white,
        )),
        centerTitle: true,
        elevation: 0.0,
          backgroundColor: Color(0xFF2abca4),
          automaticallyImplyLeading: false,

      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return buildMessageItem(messages[index], currentUserUsername);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}