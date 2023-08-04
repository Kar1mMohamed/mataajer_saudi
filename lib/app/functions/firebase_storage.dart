import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p show basename;

class FirebaseStorageFunctions {
  FirebaseStorageFunctions._();

  static Future<String> uploadImage(XFile image) async {
    final firebaseStorage = FirebaseStorage.instance;
    Reference ref;
    ref = firebaseStorage.ref().child('images/${p.basename(image.path)}');
    final uploadTask = ref.putFile(File(image.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadFile(File file) async {
    final firebaseStorage = FirebaseStorage.instance;
    Reference ref;
    ref = firebaseStorage.ref().child('files/${p.basename(file.path)}');
    final uploadTask = ref.putFile(File(file.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
