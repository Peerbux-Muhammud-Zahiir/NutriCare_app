import 'package:flutter/material.dart';
import 'package:nutricare/models/chatmessagemodel.dart';

Widget buildMessageItem(ChatMessage message, String currentUserUsername) {
  bool isCurrentUser = message.username == currentUserUsername;

  return Row(
    mainAxisAlignment: isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end,
    children: isCurrentUser
        ? [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(message.photoUrl),
          ),
          SizedBox(height: 4),
          Text(
            message.username,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      SizedBox(width: 8),
      Container(
        width: 150.0, // Fixed width for square shape
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: Colors.orange[700],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the text
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Set the text color to white
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ]
        : [
      Container(
        width: 150.0, // Fixed width for square shape
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: Color(0xFF2abca4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the text
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Set the text color to white
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      SizedBox(width: 8),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(message.photoUrl),
          ),
          SizedBox(height: 4),
          Text(
            message.username,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ],
  );
}