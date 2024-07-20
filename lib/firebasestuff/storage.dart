import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add image to Firebase Storage
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    String uid = _auth.currentUser!.uid;
    Reference ref = _storage.ref().child(uid).child(childName).child(Uuid().v4());

    // Create metadata for the image
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/jpeg', // Specify the content type as image/jpeg
    );

    // Upload the file with metadata
    UploadTask uploadTask = ref.putData(file, metadata);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}