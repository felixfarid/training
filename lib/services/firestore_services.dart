// [293]

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // * [293]
  // Let's make FirestoreService accessible by a single object
  // adding a private constructor to this class
  // so that objects of type FireStoreService can't be created
  // outside of this file
  FirestoreService._();
  // and then we are declaring a singelton as a static final object
  // of type FirestoreService.
  static final instance = FirestoreService._();

  // * Generic type method.
  // helper method that is Generic on type T
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    // * Copying from jobStream
    final reference = FirebaseFirestore.instance.collection(path);
    // snapshots is a method that returns Stream<QuerySnapshot>
    // it's an instance of Firestore in a given time
    final snapshots = reference.snapshots();
    // here we want to convert collection snapshot into a list of jobs
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (document) => builder(document.data(), document.id),
          )
          .toList(),
    );
  }

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  // [318]
  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }
}
