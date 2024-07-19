import 'package:flutter/material.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/firebasestuff/chatservice.dart';
import 'package:nutricare/models/chatmessagemodel.dart';

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

  Widget _buildMessageItem(ChatMessage message) {
    bool isCurrentUser = message.username == currentUserUsername;

    return Row(
      mainAxisAlignment: isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: isCurrentUser
          ? [
        CircleAvatar(
          backgroundImage: NetworkImage(message.photoUrl),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ]
          : [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundImage: NetworkImage(message.photoUrl),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
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
                    return _buildMessageItem(message);
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