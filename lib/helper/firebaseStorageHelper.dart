import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper{
  FirebaseStorageHelper._();
  static final FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper._();

  FirebaseStorage storage = FirebaseStorage.instance;


}