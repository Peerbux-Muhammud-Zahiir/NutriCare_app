import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutricare/models/chatmessagemodel.dart';

class ChatService {
  final _chatCollection = FirebaseFirestore.instance.collection('chats');

  Future<void> sendMessage(String text, String senderId, String username,String photoUrl) async {
    try {
      final message = ChatMessage(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: senderId,
        text: text,
        timestamp: DateTime.now(),
        username: username,
        photoUrl: photoUrl,
      );
      await _chatCollection.add(message.toJson());
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<List<ChatMessage>> getMessages() {
    return _chatCollection.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}