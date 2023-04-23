import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFireStoreDatabaseHelper {
  CloudFireStoreDatabaseHelper._();

  static CloudFireStoreDatabaseHelper cloudFireStoreDatabaseHelper =
      CloudFireStoreDatabaseHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // var serviceCategories = fireStore.collection('serviceCategories');

  setCounter({required int counter, required String collection}) async {
    await CloudFireStoreDatabaseHelper.cloudFireStoreDatabaseHelper.fireStore
        .collection('counter')
        .doc(collection)
        .set(
      {'counter': counter},
    );
  }

  Future<int> gerCounter({required String collection}) async {
    dynamic data = await CloudFireStoreDatabaseHelper
        .cloudFireStoreDatabaseHelper.fireStore
        .collection('counter')
        .doc(collection)
        .get()
        .then((value) => value.data());

    return data['counter'];
  }
}
